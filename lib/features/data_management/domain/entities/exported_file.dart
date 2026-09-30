import 'package:equatable/equatable.dart';

/// A file written by an export, ready to share or save.
class ExportedFile extends Equatable {
  const ExportedFile({
    required this.path,
    required this.name,
    required this.mimeType,
  });

  /// Where it was written, in the app's temporary storage.
  final String path;

  /// What it is called wherever the user sends or saves it.
  final String name;

  final String mimeType;

  @override
  List<Object?> get props => [path, name, mimeType];
}
