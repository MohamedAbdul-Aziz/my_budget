import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/l10n/app_strings.dart';
import '../../../categories/presentation/cubit/categories_cubit.dart';
import '../../../categories/presentation/cubit/categories_state.dart';
import '../import_prompt.dart';

/// How the user brings the AI's answer back.
enum AssistedImportSource { paste, file }

/// Walks the user through importing another app's data with an AI chat:
/// copy the prompt, give it and the data to any AI, bring the answer back.
/// Pops with the [AssistedImportSource] chosen, or null when closed.
class AssistedImportSheet extends StatefulWidget {
  const AssistedImportSheet({super.key});

  @override
  State<AssistedImportSheet> createState() => _AssistedImportSheetState();
}

class _AssistedImportSheetState extends State<AssistedImportSheet> {
  bool _copied = false;

  Future<void> _copyPrompt() async {
    final strings = context.strings;
    final state = context.read<CategoriesCubit>().state;
    final categories = state is CategoriesReady
        ? state.categories
        : const <Never>[];
    await Clipboard.setData(
      ClipboardData(
        text: buildImportPrompt(
          categories,
          strings,
          batch: newImportBatch(DateTime.now()),
        ),
      ),
    );
    if (mounted) setState(() => _copied = true);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final strings = context.strings;
    final muted = theme.textTheme.bodySmall?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(strings.aiImportTitle, style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(strings.aiImportIntro, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 16),
            _Step(number: 1, text: strings.aiImportStep1),
            Padding(
              padding: const EdgeInsetsDirectional.only(start: 36, top: 4),
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: FilledButton.tonalIcon(
                  onPressed: _copyPrompt,
                  icon: Icon(
                    _copied ? Icons.check_rounded : Icons.copy_rounded,
                  ),
                  label: Text(
                    _copied ? strings.promptCopied : strings.copyPrompt,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            _Step(number: 2, text: strings.aiImportStep2),
            const SizedBox(height: 12),
            _Step(number: 3, text: strings.aiImportStep3),
            Padding(
              padding: const EdgeInsetsDirectional.only(start: 36, top: 4),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilledButton.icon(
                    onPressed: () =>
                        Navigator.of(context).pop(AssistedImportSource.paste),
                    icon: const Icon(Icons.content_paste_rounded),
                    label: Text(strings.pasteAnswer),
                  ),
                  OutlinedButton.icon(
                    onPressed: () =>
                        Navigator.of(context).pop(AssistedImportSource.file),
                    icon: const Icon(Icons.file_open_outlined),
                    label: Text(strings.chooseFile),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.privacy_tip_outlined,
                  size: 18,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 8),
                Expanded(child: Text(strings.aiImportPrivacy, style: muted)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Step extends StatelessWidget {
  const _Step({required this.number, required this.text});

  final int number;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 12,
          backgroundColor: theme.colorScheme.primaryContainer,
          child: Text(
            '$number',
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onPrimaryContainer,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(text, style: theme.textTheme.bodyMedium)),
      ],
    );
  }
}
