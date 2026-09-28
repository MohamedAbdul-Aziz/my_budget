import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/l10n/app_strings.dart';
import '../../../../core/utils/app_formats.dart';
import '../../../settings/presentation/cubit/settings_cubit.dart';
import '../cubit/sync_cubit.dart';
import '../cubit/sync_state.dart';

/// Back up and restore buttons with their progress, result and the time of
/// the last sync. Shown only to a signed-in user.
class BackupSection extends StatefulWidget {
  const BackupSection({super.key});

  @override
  State<BackupSection> createState() => _BackupSectionState();
}

class _BackupSectionState extends State<BackupSection> {
  @override
  void initState() {
    super.initState();
    // Built fresh each time someone signs in, so the time shown is theirs.
    context.read<SyncCubit>().load();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          context.strings.backupHint,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 12),
        const _SyncButtons(),
        const SizedBox(height: 12),
        const _SyncStatus(),
      ],
    );
  }
}

class _SyncButtons extends StatelessWidget {
  const _SyncButtons();

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;

    return BlocSelector<SyncCubit, SyncState, bool>(
      selector: (state) => state.isRunning,
      builder: (context, isRunning) {
        final cubit = context.read<SyncCubit>();
        return Row(
          children: [
            Expanded(
              child: FilledButton.tonalIcon(
                icon: const Icon(Icons.cloud_upload_outlined),
                label: Text(strings.backUpNow),
                onPressed: isRunning ? null : cubit.backUp,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton.icon(
                icon: const Icon(Icons.cloud_download_outlined),
                label: Text(strings.restoreData),
                onPressed: isRunning ? null : cubit.restore,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SyncStatus extends StatelessWidget {
  const _SyncStatus();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final strings = context.strings;
    final formats = context.select<SettingsCubit, AppFormats>(
      (cubit) => cubit.state.formats,
    );

    return BlocBuilder<SyncCubit, SyncState>(
      builder: (context, state) {
        final lastSynced = state.lastSyncedAt;
        final lastSyncedText = lastSynced == null
            ? strings.neverSynced
            : strings.lastSynced(
                '${strings.dayLabel(lastSynced, formats)}, '
                '${formats.time(lastSynced)}',
              );

        final outcome = switch (state) {
          SyncRunning(:final kind, :final progress) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              LinearProgressIndicator(value: progress),
              const SizedBox(height: 6),
              Text(
                kind == SyncKind.backup ? strings.backingUp : strings.restoring,
              ),
            ],
          ),
          SyncSucceeded(:final kind) => _StatusLine(
            icon: Icons.check_circle_outline_rounded,
            color: theme.colorScheme.primary,
            text: kind == SyncKind.backup
                ? strings.backupDone
                : strings.restoreDone,
          ),
          SyncFailed(:final error) => _StatusLine(
            icon: Icons.error_outline_rounded,
            color: theme.colorScheme.error,
            text: strings.failure(error),
          ),
          SyncIdle() => null,
        };

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ?outcome,
            if (outcome != null) const SizedBox(height: 6),
            Text(
              lastSyncedText,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        );
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
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 8),
        Expanded(
          child: Text(text, style: TextStyle(color: color)),
        ),
      ],
    );
  }
}
