import 'package:equatable/equatable.dart';

/// Someone the user shares costs with: a friend, a relative, a colleague.
///
/// Pure Dart. The avatar is the person's initials on [colorValue], an ARGB
/// int, so it travels with backups and the cloud copy without any image.
class Person extends Equatable {
  const Person({
    required this.id,
    required this.name,
    required this.colorValue,
    required this.createdAt,
    this.phone,
  });

  final String id;
  final String name;

  /// Optional, free text as the user typed it.
  final String? phone;
  final int colorValue;
  final DateTime createdAt;

  /// Up to two letters for the avatar: the first letter of the first two
  /// words, or of the only one.
  String get initials {
    final words = name.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty);
    return words.take(2).map((w) => String.fromCharCode(w.runes.first)).join();
  }

  @override
  List<Object?> get props => [id, name, phone, colorValue, createdAt];
}
