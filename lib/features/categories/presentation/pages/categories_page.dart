import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/l10n/app_strings.dart';
import '../../domain/entities/expense_category.dart';
import '../category_label.dart';
import '../cubit/categories_cubit.dart';
import '../cubit/categories_state.dart';
import '../widgets/category_avatar.dart';
import '../widgets/category_editor_sheet.dart';

/// Manage the categories used when adding expenses.
class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  static Route<void> route() =>
      MaterialPageRoute(builder: (_) => const CategoriesPage());

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;

    return Scaffold(
      appBar: AppBar(title: Text(strings.categories)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _create(context),
        icon: const Icon(Icons.add_rounded),
        label: Text(strings.newCategory),
      ),
      body: BlocConsumer<CategoriesCubit, CategoriesState>(
        listenWhen: (previous, current) =>
            current is CategoriesReady && current.notice != null,
        listener: (context, state) {
          final notice = (state as CategoriesReady).notice!;
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(context.strings.notice(notice))),
            );
        },
        builder: (context, state) => switch (state) {
          CategoriesLoading() => const Center(
            child: CircularProgressIndicator(),
          ),
          CategoriesLoadFailure(:final failure) => _LoadFailure(
            message: strings.failure(failure.code),
          ),
          CategoriesReady(:final categories) => _CategoryList(
            categories: categories,
          ),
        },
      ),
    );
  }

  static Future<void> _create(BuildContext context) async {
    final cubit = context.read<CategoriesCubit>();
    final draft = await CategoryEditorSheet.show(context);
    if (draft == null) return;
    await cubit.create(
      name: draft.name,
      iconName: draft.iconName,
      colorValue: draft.colorValue,
    );
  }
}

class _CategoryList extends StatelessWidget {
  const _CategoryList({required this.categories});

  final List<ExpenseCategory> categories;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 96),
      itemCount: categories.length,
      separatorBuilder: (_, _) => const SizedBox(height: 4),
      itemBuilder: (context, index) =>
          _CategoryRow(category: categories[index]),
    );
  }
}

class _CategoryRow extends StatelessWidget {
  const _CategoryRow({required this.category});

  final ExpenseCategory category;

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;

    return ListTile(
      leading: CategoryAvatar(category: category),
      title: Text(
        categoryLabel(strings, category),
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(category.isDefault ? strings.builtIn : strings.custom),
      onTap: () => _edit(context),
      trailing: PopupMenuButton<_CategoryAction>(
        icon: const Icon(Icons.more_vert_rounded),
        onSelected: (action) => switch (action) {
          _CategoryAction.edit => _edit(context),
          _CategoryAction.delete => _confirmDelete(context),
        },
        itemBuilder: (context) => [
          PopupMenuItem(
            value: _CategoryAction.edit,
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.edit_outlined),
              title: Text(strings.edit),
            ),
          ),
          if (category.isDeletable)
            PopupMenuItem(
              value: _CategoryAction.delete,
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.delete_outline_rounded),
                title: Text(strings.delete),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _edit(BuildContext context) async {
    final cubit = context.read<CategoriesCubit>();
    final previousName = categoryLabel(context.strings, category);
    final draft = await CategoryEditorSheet.show(context, existing: category);
    if (draft == null) return;

    await cubit.edit(
      category.copyWith(
        name: draft.name,
        iconName: draft.iconName,
        colorValue: draft.colorValue,
        // A built-in category shows its translated name, so renaming one has
        // to make it the user's own — otherwise the translation would keep
        // overriding what they typed.
        isDefault: category.isDefault && draft.name == previousName,
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final cubit = context.read<CategoriesCubit>();
    final strings = context.strings;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          strings.deleteCategoryTitle(categoryLabel(strings, category)),
        ),
        content: Text(strings.deleteCategoryBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(strings.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(strings.delete),
          ),
        ],
      ),
    );
    if (confirmed ?? false) await cubit.remove(category);
  }
}

enum _CategoryAction { edit, delete }

class _LoadFailure extends StatelessWidget {
  const _LoadFailure({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded, size: 40),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton.tonal(
              onPressed: () => context.read<CategoriesCubit>().load(),
              child: Text(context.strings.tryAgain),
            ),
          ],
        ),
      ),
    );
  }
}
