import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import '../../domain/entities/reminder_message.dart';

/// The phone's notification scheduler, for the one notification the app
/// sends: the daily reminder.
abstract interface class ReminderNotificationsDataSource {
  /// True on the phones the reminder is offered on.
  bool get isSupported;

  Future<bool> areAllowed();

  Future<bool> requestPermission();

  Future<void> scheduleDaily({
    required int hour,
    required int minute,
    required ReminderMessage message,
  });

  Future<void> cancel();
}

class ReminderNotificationsDataSourceImpl
    implements ReminderNotificationsDataSource {
  ReminderNotificationsDataSourceImpl({
    FlutterLocalNotificationsPlugin? plugin,
    TargetPlatform? platform,
  }) : _plugin = plugin ?? FlutterLocalNotificationsPlugin(),
       _platform = platform;

  /// The reminder always reuses this id, so scheduling it again replaces it.
  static const int _reminderId = 1;
  static const String _channelId = 'daily_reminder';

  /// A monochrome drawable in `android/app/src/main/res/drawable`, kept from
  /// resource shrinking by `res/raw/keep.xml`.
  static const String _androidIcon = 'ic_stat_reminder';

  final FlutterLocalNotificationsPlugin _plugin;
  final TargetPlatform? _platform;
  bool _initialized = false;

  TargetPlatform get _target => _platform ?? defaultTargetPlatform;

  @override
  bool get isSupported =>
      !kIsWeb &&
      (_target == TargetPlatform.android || _target == TargetPlatform.iOS);

  @override
  Future<bool> areAllowed() async {
    if (!isSupported) return false;
    await _initialize();
    if (_target == TargetPlatform.android) {
      return await _android?.areNotificationsEnabled() ?? false;
    }
    final options = await _ios?.checkPermissions();
    return options?.isEnabled ?? false;
  }

  @override
  Future<bool> requestPermission() async {
    if (!isSupported) return false;
    await _initialize();
    if (_target == TargetPlatform.android) {
      return await _android?.requestNotificationsPermission() ?? false;
    }
    return await _ios?.requestPermissions(alert: true, sound: true) ?? false;
  }

  @override
  Future<void> scheduleDaily({
    required int hour,
    required int minute,
    required ReminderMessage message,
  }) async {
    if (!isSupported) return;
    await _initialize();
    final location = await _localLocation();
    final now = tz.TZDateTime.now(location);
    var next = tz.TZDateTime(
      location,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    if (!next.isAfter(now)) {
      // Built from the calendar day rather than adding 24 hours, so a
      // daylight saving change never moves the time.
      next = tz.TZDateTime(
        location,
        now.year,
        now.month,
        now.day + 1,
        hour,
        minute,
      );
    }

    await _plugin.zonedSchedule(
      id: _reminderId,
      scheduledDate: next,
      title: message.title,
      body: message.body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(_channelId, message.channelName),
        iOS: const DarwinNotificationDetails(),
      ),
      // A reminder a few minutes late is fine, and this needs no exact-alarm
      // permission, which Android 14 no longer grants by default.
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      // Repeats at this time every day.
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  @override
  Future<void> cancel() async {
    if (!isSupported) return;
    await _initialize();
    await _plugin.cancel(id: _reminderId);
  }

  AndroidFlutterLocalNotificationsPlugin? get _android => _plugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >();

  IOSFlutterLocalNotificationsPlugin? get _ios => _plugin
      .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin
      >();

  Future<void> _initialize() async {
    if (_initialized) return;
    tz_data.initializeTimeZones();
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings(_androidIcon),
        // Permission is asked for when the user turns the reminder on, never
        // at launch.
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      ),
    );
    _initialized = true;
  }

  /// The phone's time zone, which the reminder's time is read in.
  Future<tz.Location> _localLocation() async {
    try {
      final zone = await FlutterTimezone.getLocalTimezone();
      return tz.getLocation(zone.identifier);
    } catch (_) {
      // A zone the database does not know: any zone at the phone's current
      // offset rings at the same time.
      final offset = DateTime.now().timeZoneOffset.inMilliseconds;
      return tz.timeZoneDatabase.locations.values.firstWhere(
        (location) => location.currentTimeZone.offset == offset,
        orElse: () => tz.UTC,
      );
    }
  }
}
