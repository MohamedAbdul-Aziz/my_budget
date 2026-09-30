import 'package:equatable/equatable.dart';

/// The reminder's wording, already in the user's language.
///
/// The domain never writes user-facing text, so the presentation layer
/// supplies it every time the reminder is scheduled.
class ReminderMessage extends Equatable {
  const ReminderMessage({
    required this.title,
    required this.body,
    required this.channelName,
  });

  final String title;
  final String body;

  /// How Android lists this kind of notification in the app's settings.
  final String channelName;

  @override
  List<Object?> get props => [title, body, channelName];
}
