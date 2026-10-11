import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:my_budget/core/database/app_database.dart';
import 'package:my_budget/core/database/device_settings.dart';
import 'package:my_budget/core/error/api_result.dart';
import 'package:my_budget/core/error/failures.dart';
import 'package:my_budget/features/assistant/data/datasources/assistant_local_data_source.dart';
import 'package:my_budget/features/assistant/data/datasources/assistant_remote_data_source.dart';
import 'package:my_budget/features/assistant/data/repositories/assistant_repository_impl.dart';
import 'package:my_budget/features/assistant/domain/entities/assistant_message.dart';
import 'package:my_budget/features/assistant/domain/entities/assistant_reply.dart';
import 'package:my_budget/features/assistant/domain/entities/assistant_sharing.dart';
import 'package:my_budget/features/assistant/domain/entities/spending_summary.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// The real data layer over a fake server: what goes out, and how each of
/// the ai-assistant function's answers comes back.
void main() {
  late AppDatabase database;
  late List<http.Request> requests;

  const summary = SpendingSummary(
    currency: r'$',
    generatedOn: '2026-10-10',
    months: [],
    budget: SummaryBudget(period: '2026-10', spent: 0, categories: []),
    trend: [('2026-10', 12.5)],
  );

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() {
    database = AppDatabase(inMemory: true);
    requests = [];
  });

  tearDown(() => database.close());

  AssistantRepositoryImpl repositoryAnswering(
    Future<http.Response> Function(http.Request request) server,
  ) {
    final functions = FunctionsClient(
      'https://example.supabase.co/functions/v1',
      const {},
      httpClient: MockClient((request) {
        requests.add(request);
        return server(request);
      }),
    );
    addTearDown(functions.dispose);
    return AssistantRepositoryImpl(
      remote: AssistantRemoteDataSourceImpl(functions),
      local: AssistantLocalDataSourceImpl(database),
      deviceSettings: DeviceSettings(database),
    );
  }

  http.Response reply(Object body, int status) => http.Response(
    jsonEncode(body),
    status,
    headers: {'content-type': 'application/json'},
  );

  Future<ApiResult<AssistantReply>> askWith(
    AssistantRepositoryImpl repository,
  ) => repository.ask(
    question: 'Where can I save?',
    summary: summary,
    history: const [
      AssistantMessage.user('Hi'),
      AssistantMessage.assistant('Hello'),
    ],
    languageCode: 'ar',
  );

  test('sends the question, summary, history and language', () async {
    final repository = repositoryAnswering(
      (_) async => reply({'answer': 'Cook at home.'}, 200),
    );

    final result = await askWith(repository);

    expect(result.dataOrNull, const AssistantReply(answer: 'Cook at home.'));
    final request = requests.single;
    expect(request.url.path, '/functions/v1/ai-assistant');
    final body = jsonDecode(request.body) as Map<String, Object?>;
    expect(body['deviceId'], matches(RegExp(r'^[0-9a-f]{32}$')));
    expect(body..remove('deviceId'), {
      'question': 'Where can I save?',
      'summary': summary.toJson(),
      'history': [
        {'role': 'user', 'text': 'Hi'},
        {'role': 'assistant', 'text': 'Hello'},
      ],
      'language': 'ar',
    });
  });

  group('maps the server answers', () {
    Future<Failure?> failureFor(http.Response response) async {
      final repository = repositoryAnswering((_) async => response);
      return (await askWith(repository)).failureOrNull;
    }

    test(
      'a 401 from an older server is unavailable: no sign-in needed',
      () async {
        final failure = await failureFor(
          reply({'error': 'not_signed_in'}, 401),
        );
        expect(failure, isA<AssistantFailure>());
        expect(failure?.code, FailureCode.aiUnavailable);
      },
    );

    test('429 daily_limit is the account quota', () async {
      final failure = await failureFor(reply({'error': 'daily_limit'}, 429));
      expect(failure, isA<AssistantFailure>());
      expect(failure?.code, FailureCode.aiDailyLimit);
    });

    test('429 busy is the provider rate limit', () async {
      final failure = await failureFor(reply({'error': 'busy'}, 429));
      expect(failure?.code, FailureCode.aiBusy);
    });

    test('any other error is unavailable', () async {
      for (final status in [400, 500, 502, 503]) {
        final failure = await failureFor(reply({'error': 'x'}, status));
        expect(failure?.code, FailureCode.aiUnavailable, reason: '$status');
      }
    });

    test('a reply without an answer is unavailable', () async {
      final failure = await failureFor(reply({'answer': ''}, 200));
      expect(failure?.code, FailureCode.aiUnavailable);
    });

    test('no connection is a network failure', () async {
      final repository = repositoryAnswering(
        (_) async => throw const SocketException('offline'),
      );
      expect((await askWith(repository)).failureOrNull, isA<NetworkFailure>());

      final client = repositoryAnswering(
        (_) async => throw http.ClientException('reset'),
      );
      expect((await askWith(client)).failureOrNull, isA<NetworkFailure>());
    });
  });

  test('consent is off until given, and can be withdrawn', () async {
    final repository = repositoryAnswering((_) async => reply({}, 200));

    expect((await repository.hasConsent()).dataOrNull, isFalse);
    await repository.setConsent(granted: true);
    expect((await repository.hasConsent()).dataOrNull, isTrue);
    await repository.setConsent(granted: false);
    expect((await repository.hasConsent()).dataOrNull, isFalse);
    expect(requests, isEmpty);
  });

  test(
    'sharing choices start at the default and are kept on the phone',
    () async {
      final repository = repositoryAnswering((_) async => reply({}, 200));
      expect(
        (await repository.getSharing()).dataOrNull,
        AssistantSharing.defaults,
      );

      const chosen = AssistantSharing(
        range: AssistantRange.last6Months,
        transactions: true,
        people: true,
      );
      await repository.setSharing(chosen);

      expect((await repository.getSharing()).dataOrNull, chosen);
      final stored = await DeviceSettings(
        database,
      ).readValue(DeviceSettings.aiSharing);
      expect(stored, contains('last_6_months'));
      expect(requests, isEmpty);
    },
  );

  test('reads the suggested questions, skipping anything odd', () async {
    final repository = repositoryAnswering(
      (_) async => reply({
        'answer': '**Food** costs most.',
        'followUps': ['Last month?', 7, '  ', ' Where to save? '],
      }, 200),
    );

    final result = (await askWith(repository)).dataOrNull!;

    expect(result.answer, '**Food** costs most.');
    expect(result.followUps, ['Last month?', 'Where to save?']);
  });

  test('the device id is made once, kept on this phone, and reused', () async {
    final repository = repositoryAnswering(
      (_) async => reply({'answer': 'OK'}, 200),
    );

    await askWith(repository);
    await askWith(repository);

    final ids = {
      for (final request in requests)
        (jsonDecode(request.body) as Map)['deviceId'],
    };
    expect(ids, hasLength(1));
    expect(
      await DeviceSettings(database).readValue(DeviceSettings.aiDeviceId),
      ids.single,
    );
  });
}
