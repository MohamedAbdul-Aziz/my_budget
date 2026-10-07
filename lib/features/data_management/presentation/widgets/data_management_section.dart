import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/l10n/app_strings.dart';
import '../../../../core/utils/app_formats.dart';
import '../../../categories/presentation/cubit/categories_cubit.dart';
import '../../../settings/presentation/cubit/settings_cubit.dart';
import '../../domain/entities/backup_preview.dart';
import '../../domain/entities/export_format.dart';
import '../../domain/entities/export_locale.dart';
import '../../domain/entities/import_mode.dart';
import '../../domain/entities/share_anchor.dart';
import '../cubit/data_management_cubit.dart';
import '../cubit/data_management_state.dart';
import 'assisted_import_sheet.dart';

/// Files the user keeps themselves: a restorable backup, spreadsheets and a
/// report to share or save, and importing a backup. Shown to everyone,
/// signed in or not, and works offline.
class DataManagementSection extends StatelessWidget {
  const DataManagementSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final strings = context.strings;

    return BlocListener<DataManagementCubit, DataManagementState>(
      listenWhen: (_, state) =>
          state is DataExportReady || state is DataImportReview,
      listener: (context, state) => switch (state) {
        DataExportReady() => _chooseDestination(context),
        DataImportReview(:final backup) => _confirmImport(context, backup),
        _ => null,
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            strings.dataManagementHint,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          const _Actions(),
          const _DataStatus(),
        ],
      ),
    );
  }

  Future<void> _chooseDestination(BuildContext context) async {
    final cubit = context.read<DataManagementCubit>();
    final choice = await showModalBottomSheet<_Destination>(
      context: context,
      builder: (_) => const _DestinationSheet(),
    );
    switch (choice) {
      case _Share(:final anchor):
        await cubit.share(anchor: anchor);
      case _Save():
        await cubit.save();
      case null:
        cubit.dismiss();
    }
  }

  Future<void> _confirmImport(
    BuildContext context,
    BackupPreview backup,
  ) async {
    final cubit = context.read<DataManagementCubit>();
    final mode = await showDialog<ImportMode>(
      context: context,
      builder: (_) => _ImportDialog(backup: backup),
    );
    if (mode == ImportMode.replace && context.mounted) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (_) => const _ReplaceDialog(),
      );
      if (confirmed != true) {
        cubit.dismiss();
        return;
      }
    }
    if (mode == null) {
      cubit.dismiss();
      return;
    }
    await cubit.importBackup(mode);
  }
}

class _Actions extends StatelessWidget {
  const _Actions();

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;

    return BlocSelector<DataManagementCubit, DataManagementState, bool>(
      selector: (state) => state.isBusy,
      builder: (context, isBusy) {
        final cubit = context.read<DataManagementCubit>();
        void export(ExportFormat format) =>
            cubit.export(format, _exportLocale(context));

        return Column(
          children: [
            _ActionTile(
              icon: Icons.save_alt_rounded,
              title: strings.backUpToFile,
              subtitle: strings.backUpToFileHint,
              onTap: isBusy ? null : () => export(ExportFormat.backup),
            ),
            _ActionTile(
              icon: Icons.table_chart_outlined,
              title: strings.exportCsv,
              subtitle: strings.exportCsvHint,
              onTap: isBusy ? null : () => export(ExportFormat.spreadsheet),
            ),
            _ActionTile(
              icon: Icons.picture_as_pdf_outlined,
              title: strings.exportPdf,
              subtitle: strings.exportPdfHint,
              onTap: isBusy ? null : () => export(ExportFormat.report),
            ),
            _ActionTile(
              icon: Icons.file_open_outlined,
              title: strings.importData,
              subtitle: strings.importDataHint,
              onTap: isBusy ? null : cubit.chooseBackup,
            ),
            _ActionTile(
              icon: Icons.auto_awesome_outlined,
              title: strings.importFromAi,
              subtitle: strings.importFromAiHint,
              onTap: isBusy ? null : () => _importWithAi(context),
            ),
          ],
        );
      },
    );
  }

  /// Exports read the way the app does: its language and number formats.
  static ExportLocale _exportLocale(BuildContext context) {
    final settings = context.read<SettingsCubit>().state;
    return ExportLocale(
      languageCode: settings.languageCode,
      formatsLocale: settings.formats.localeName,
      currencySymbol: settings.formats.symbol,
    );
  }
}

/// Another app's data, rewritten by an AI chat from the import prompt. The
/// answer comes back pasted or as a file, and is then checked and confirmed
/// exactly like a backup.
Future<void> _importWithAi(BuildContext context) async {
  final cubit = context.read<DataManagementCubit>();
  final source = await showModalBottomSheet<AssistedImportSource>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => BlocProvider.value(
      value: context.read<CategoriesCubit>(),
      child: const AssistedImportSheet(),
    ),
  );
  switch (source) {
    case AssistedImportSource.paste:
      final pasted = await Clipboard.getData(Clipboard.kTextPlain);
      await cubit.pasteBackup(pasted?.text ?? '');
    case AssistedImportSource.file:
      await cubit.chooseBackup();
    case null:
      break;
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => ListTile(
    contentPadding: EdgeInsets.zero,
    leading: Icon(icon),
    title: Text(title),
    subtitle: Text(subtitle),
    enabled: onTap != null,
    onTap: onTap,
  );
}

/// Progress while working, then the outcome: saved, imported or why not.
class _DataStatus extends StatelessWidget {
  const _DataStatus();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final strings = context.strings;

    return BlocBuilder<DataManagementCubit, DataManagementState>(
      builder: (context, state) {
        final Widget? status = switch (state) {
          DataWorking(:final task, :final progress) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              LinearProgressIndicator(value: progress),
              const SizedBox(height: 6),
              Text(
                task == DataTask.export
                    ? strings.preparingFile
                    : strings.importingData,
              ),
            ],
          ),
          DataSaved() => _StatusLine(
            icon: Icons.check_circle_outline_rounded,
            color: theme.colorScheme.primary,
            text: strings.fileSaved,
          ),
          DataImported(:final changes) => _StatusLine(
            icon: Icons.check_circle_outline_rounded,
            color: theme.colorScheme.primary,
            text: changes == 0 ? strings.importNothingNew : strings.importDone,
          ),
          DataFailed(:final error) => _StatusLine(
            icon: Icons.error_outline_rounded,
            color: theme.colorScheme.error,
            text: strings.failure(error),
          ),
          DataIdle() || DataExportReady() || DataImportReview() => null,
        };
        return status == null
            ? const SizedBox.shrink()
            : Padding(padding: const EdgeInsets.only(top: 8), child: status);
      },
    );
  }
}

class _StatusLine extends StatelessWidget {
  const _StatusLine({
    required this.icon,
    required this.color,
    required this.text,
  });

  final IconData icon;
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Icon(icon, size: 18, color: color),
      const SizedBox(width: 8),
      Expanded(
        child: Text(text, style: TextStyle(color: color)),
      ),
    ],
  );
}

sealed class _Destination {
  const _Destination();
}

final class _Share extends _Destination {
  const _Share(this.anchor);

  final ShareAnchor? anchor;
}

final class _Save extends _Destination {
  const _Save();
}

/// Share (WhatsApp, email, Drive, Files, other apps) or save to the phone.
class _DestinationSheet extends StatelessWidget {
  const _DestinationSheet();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final strings = context.strings;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Text(
                strings.fileReady,
                style: theme.textTheme.titleMedium,
              ),
            ),
            Builder(
              builder: (tileContext) => ListTile(
                leading: const Icon(Icons.share_outlined),
                title: Text(strings.shareFile),
                subtitle: Text(strings.shareFileHint),
                onTap: () =>
                    Navigator.of(context).pop(_Share(_anchorOf(tileContext))),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.download_outlined),
              title: Text(strings.saveToPhone),
              subtitle: Text(strings.saveToPhoneHint),
              onTap: () => Navigator.of(context).pop(const _Save()),
            ),
          ],
        ),
      ),
    );
  }

  /// Where the share sheet points from on an iPad.
  static ShareAnchor? _anchorOf(BuildContext context) {
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return null;
    final origin = box.localToGlobal(Offset.zero);
    return ShareAnchor(
      left: origin.dx,
      top: origin.dy,
      width: box.size.width,
      height: box.size.height,
    );
  }
}

/// Merge is the default action; replacing is offered but never assumed.
class _ImportDialog extends StatelessWidget {
  const _ImportDialog({required this.backup});

  final BackupPreview backup;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final strings = context.strings;
    final formats = context.select<SettingsCubit, AppFormats>(
      (cubit) => cubit.state.formats,
    );
    final exportedAt = backup.exportedAt;

    return AlertDialog(
      title: Text(strings.importTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            strings.importSummary(
              exportedAt == null ? null : formats.fullDate(exportedAt),
              backup.expenses,
              backup.categories,
              people: backup.people,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            strings.importMergeHint,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(strings.cancel),
        ),
        TextButton(
          style: TextButton.styleFrom(foregroundColor: theme.colorScheme.error),
          onPressed: () => Navigator.of(context).pop(ImportMode.replace),
          child: Text(strings.replaceEverything),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(ImportMode.merge),
          child: Text(strings.merge),
        ),
      ],
    );
  }
}

class _ReplaceDialog extends StatelessWidget {
  const _ReplaceDialog();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final strings = context.strings;

    return AlertDialog(
      title: Text(strings.replaceTitle),
      content: Text(strings.replaceBody),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(strings.cancel),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: theme.colorScheme.error,
            foregroundColor: theme.colorScheme.onError,
          ),
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(strings.replace),
        ),
      ],
    );
  }
}
