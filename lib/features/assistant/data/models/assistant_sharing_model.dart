import 'dart:convert';

import '../../domain/entities/assistant_sharing.dart';

/// [AssistantSharing] as the JSON kept in `device_settings`. Anything missing
/// or unreadable reads as the default, so a damaged value can only ever
/// share less.
abstract final class AssistantSharingModel {
  static String encode(AssistantSharing sharing) => jsonEncode({
    'range': sharing.range.storageKey,
    if (sharing.customStart case final start?) 'from': _day(start),
    if (sharing.customEnd case final end?) 'to': _day(end),
    'transactions': sharing.transactions,
    'descriptions': sharing.descriptions,
    'recurring': sharing.recurring,
    'people': sharing.people,
  });

  static AssistantSharing decode(String? stored) {
    if (stored == null) return AssistantSharing.defaults;
    final Object? json;
    try {
      json = jsonDecode(stored);
    } on FormatException {
      return AssistantSharing.defaults;
    }
    if (json is! Map<String, Object?>) return AssistantSharing.defaults;
    final map = json;
    bool flag(String key) => map[key] == true;
    return AssistantSharing(
      range: AssistantRange.fromStorageKey(
        map['range'] is String ? map['range']! as String : null,
      ),
      customStart: _parseDay(map['from']),
      customEnd: _parseDay(map['to']),
      transactions: flag('transactions'),
      descriptions: flag('descriptions'),
      recurring: flag('recurring'),
      people: flag('people'),
    );
  }

  static String _day(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';

  static DateTime? _parseDay(Object? value) {
    if (value is! String) return null;
    final parsed = DateTime.tryParse(value);
    return parsed == null
        ? null
        : DateTime(parsed.year, parsed.month, parsed.day);
  }
}
