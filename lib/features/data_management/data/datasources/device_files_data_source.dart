import 'dart:convert';
import 'dart:io';
import 'dart:ui' show Rect;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart' show PlatformException;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/exported_file.dart';
import '../../domain/entities/share_anchor.dart';

/// The phone's own file handling: temporary storage for exports, the system
/// share sheet, the system save dialog and the system file chooser. Each is
/// the native Android or iOS interface, so every installed app that accepts
/// files (WhatsApp, email, Drive, Files...) is offered without integrating
/// any of them.
abstract interface class DeviceFilesDataSource {
  /// Removes files left over from earlier exports.
  Future<void> clearExports();

  /// Writes an export to temporary storage and returns its path.
  Future<String> writeExport(String name, List<int> bytes);

  Future<String> readText(String path);

  /// Keeps pasted text as a file to import, replacing the last one, and
  /// returns its path.
  Future<String> writeImport(String text);

  Future<void> share(List<ExportedFile> files, {ShareAnchor? anchor});

  /// False when the user cancels.
  Future<bool> save(ExportedFile file);

  /// Null when the user cancels.
  Future<String?> pickFile();
}

class DeviceFilesDataSourceImpl implements DeviceFilesDataSource {
  const DeviceFilesDataSourceImpl();

  /// "No space left on device" on both Android and iOS.
  static const int _noSpaceLeft = 28;

  Future<Directory> _exportsDirectory() async =>
      Directory(p.join((await getTemporaryDirectory()).path, 'exports'));

  @override
  Future<void> clearExports() async {
    try {
      final directory = await _exportsDirectory();
      if (await directory.exists()) await directory.delete(recursive: true);
    } on FileSystemException {
      // Old exports only take up space; a new export does not need them gone.
    }
  }

  @override
  Future<String> writeExport(String name, List<int> bytes) async {
    try {
      final directory = await _exportsDirectory();
      await directory.create(recursive: true);
      final file = File(p.join(directory.path, name));
      await file.writeAsBytes(bytes, flush: true);
      return file.path;
    } on FileSystemException catch (error) {
      throw FileFailure(
        error.osError?.errorCode == _noSpaceLeft
            ? FailureCode.storageFull
            : FailureCode.exportFailed,
        '$error',
      );
    }
  }

  @override
  Future<String> writeImport(String text) async {
    try {
      final directory = Directory(
        p.join((await getTemporaryDirectory()).path, 'imports'),
      );
      await directory.create(recursive: true);
      final file = File(p.join(directory.path, 'pasted.mybudget.json'));
      await file.writeAsString(text, flush: true);
      return file.path;
    } on FileSystemException catch (error) {
      throw FileFailure(
        error.osError?.errorCode == _noSpaceLeft
            ? FailureCode.storageFull
            : FailureCode.fileUnavailable,
        '$error',
      );
    }
  }

  @override
  Future<String> readText(String path) async {
    try {
      return utf8.decode(await File(path).readAsBytes());
    } on FileSystemException catch (error) {
      throw FileFailure(FailureCode.fileUnavailable, '$error');
    } on FormatException catch (error) {
      // Not text at all: a photo, a zip, a PDF...
      throw FileFailure(FailureCode.backupNotRecognized, '$error');
    }
  }

  @override
  Future<void> share(List<ExportedFile> files, {ShareAnchor? anchor}) async {
    try {
      await SharePlus.instance.share(
        ShareParams(
          files: [
            for (final file in files)
              XFile(file.path, name: file.name, mimeType: file.mimeType),
          ],
          fileNameOverrides: [for (final file in files) file.name],
          sharePositionOrigin: anchor == null
              ? null
              : Rect.fromLTWH(
                  anchor.left,
                  anchor.top,
                  anchor.width,
                  anchor.height,
                ),
        ),
      );
    } on PlatformException catch (error) {
      throw FileFailure(FailureCode.shareUnavailable, '$error');
    }
  }

  @override
  Future<bool> save(ExportedFile file) async {
    try {
      final bytes = await File(file.path).readAsBytes();
      final saved = await FilePicker.saveFile(
        fileName: file.name,
        bytes: bytes,
      );
      return saved != null;
    } on FileSystemException catch (error) {
      throw FileFailure(FailureCode.fileUnavailable, '$error');
    } on PlatformException catch (error) {
      throw FileFailure(FailureCode.saveFailed, '$error');
    }
  }

  @override
  Future<String?> pickFile() async {
    try {
      // Any file: some apps label a .json attachment as a generic file, and
      // a filter would hide it. The backup check rejects anything else.
      final result = await FilePicker.pickFiles();
      return result?.files.single.path;
    } on PlatformException catch (error) {
      throw FileFailure(FailureCode.fileUnavailable, '$error');
    }
  }
}
