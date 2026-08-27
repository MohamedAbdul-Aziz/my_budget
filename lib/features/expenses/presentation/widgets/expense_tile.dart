import 'package:flutter/material.dart';

import '../../../../core/l10n/app_strings.dart';
import '../../../../core/utils/app_formats.dart';
import '../../../categories/presentation/category_label.dart';
import '../../../categories/presentation/widgets/category_avatar.dart';
import '../../domain/entities/expense.dart';

/// One row in the expense list. Swipe it away to delete.
class ExpenseTile extends StatelessWidget {
  const ExpenseTile({
    super.key,
    required this.expense,
    required this.formats,
    required this.onTap,
    required this.onDismissed,
  });

  final Expense expense;
  final AppFormats formats;
  final VoidCallback onTap;
  final VoidCallback onDismissed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final strings = context.strings;
    final description = expense.description;
    final category = categoryLabel(strings, expense.category);

    return Dismissible(
      key: ValueKey(expense.id),
      // Always "swipe towards the end", which flips with the text direction.
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismissed(),
      background: _DismissBackground(color: theme.colorScheme.errorContainer),
      child: ListTile(
        onTap: onTap,
        leading: CategoryAvatar(category: expense.category),
        title: Text(
          description ?? category,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          description == null
              ? strings.dayLabel(expense.date, formats)
              : '$category · ${strings.dayLabel(expense.date, formats)}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Text(
          formats.money(expense.amount),
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _DismissBackground extends StatelessWidget {
  const _DismissBackground({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    alignment: AlignmentDirectional.centerEnd,
    padding: const EdgeInsetsDirectional.only(end: 24),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Icon(
      Icons.delete_outline_rounded,
      color: Theme.of(context).colorScheme.onErrorContainer,
    ),
  );
}
