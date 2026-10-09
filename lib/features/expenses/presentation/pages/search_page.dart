import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/l10n/app_strings.dart';
import '../../../../core/utils/app_formats.dart';
import '../../../categories/domain/entities/expense_category.dart';
import '../../../categories/domain/entities/transaction_type.dart';
import '../../../categories/presentation/category_label.dart';
import '../../../categories/presentation/cubit/categories_cubit.dart';
import '../../../categories/presentation/cubit/categories_state.dart';
import '../../../categories/presentation/widgets/category_avatar.dart';
import '../../../settings/presentation/cubit/settings_cubit.dart';
import '../../domain/entities/expense.dart';
import '../../domain/entities/transaction_search.dart';
import '../cubit/home_cubit.dart';
import '../cubit/search_cubit.dart';
import '../cubit/search_state.dart';
import '../widgets/expense_tile.dart';
import 'expense_form_page.dart';

/// Finds transactions in every month by their note or amount, narrowed down
/// by type, category and date.
class SearchPage extends StatefulWidget {
  const SearchPage({super.key, this.focusText = true});

  /// Whether the keyboard opens on the text field. Not when the page opens
  /// on a filter already chosen: the results are what the user came for.
  final bool focusText;

  /// [initial] opens the page with those filters applied, such as one
  /// category over one month from the analyses.
  static Route<void> route({TransactionSearch? initial}) =>
      MaterialPageRoute<void>(
        builder: (_) => BlocProvider(
          create: (_) {
            final cubit = sl<SearchCubit>();
            if (initial != null) cubit.start(initial);
            return cubit;
          },
          child: SearchPage(focusText: initial == null),
        ),
      );

  /// Every transaction in [categoryId] from [from] to [to], both included.
  static Route<void> forCategory(
    String categoryId, {
    required DateTime from,
    required DateTime to,
  }) => route(
    initial: TransactionSearch(categoryIds: {categoryId}, from: from, to: to),
  );

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _clearText() {
    _textController.clear();
    context.read<SearchCubit>().setText('');
  }

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: TextField(
          controller: _textController,
          autofocus: widget.focusText,
          textInputAction: TextInputAction.search,
          onChanged: context.read<SearchCubit>().setText,
          decoration: InputDecoration(
            hintText: strings.searchHint,
            border: InputBorder.none,
            filled: false,
          ),
        ),
        actions: [
          // Rebuilds only the clear button while typing.
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: _textController,
            builder: (context, value, _) => value.text.isEmpty
                ? const SizedBox.shrink()
                : IconButton(
                    tooltip: MaterialLocalizations.of(
                      context,
                    ).deleteButtonTooltip,
                    icon: const Icon(Icons.close_rounded),
                    onPressed: _clearText,
                  ),
          ),
        ],
      ),
      body: const Column(
        children: [
          _FilterBar(),
          Expanded(child: _Results()),
        ],
      ),
    );
  }
}

/// Type, category and date, in a row that scrolls sideways in any language.
/// Clearing them sits at the start, where it is always in view.
class _FilterBar extends StatelessWidget {
  const _FilterBar();

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;
    final formats = context.select<SettingsCubit, AppFormats>(
      (cubit) => cubit.state.formats,
    );

    return BlocSelector<SearchCubit, SearchState, TransactionSearch>(
      selector: (state) => state.search,
      builder: (context, search) {
        final cubit = context.read<SearchCubit>();
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
          child: Row(
            children: [
              if (search.hasFilters)
                IconButton(
                  tooltip: strings.clearFilters,
                  icon: const Icon(Icons.filter_alt_off_rounded),
                  onPressed: cubit.clearFilters,
                ),
              for (final (type, label) in [
                (null, strings.allTypes),
                (TransactionType.expense, strings.expense),
                (TransactionType.income, strings.income),
              ])
                Padding(
                  padding: const EdgeInsetsDirectional.only(end: 8),
                  child: ChoiceChip(
                    label: Text(label),
                    selected: search.type == type,
                    onSelected: (_) => cubit.setType(type),
                  ),
                ),
              Padding(
                padding: const EdgeInsetsDirectional.only(end: 8),
                child: _CategoryChip(search: search),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.only(end: 8),
                child: InputChip(
                  avatar: const Icon(Icons.date_range_rounded, size: 18),
                  label: Text(_dateLabel(search, strings, formats)),
                  selected: search.from != null,
                  showCheckmark: false,
                  onPressed: () => _pickDates(context, search),
                  onDeleted: search.from == null
                      ? null
                      : () => cubit.setDates(null, null),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static String _dateLabel(
    TransactionSearch search,
    AppStrings strings,
    AppFormats formats,
  ) => switch ((search.from, search.to)) {
    (final from?, final to?) when AppFormats.isSameDay(from, to) =>
      formats.fullDate(from),
    (final from?, final to?) =>
      '${formats.fullDate(from)} – ${formats.fullDate(to)}',
    _ => strings.anyDate,
  };

  static Future<void> _pickDates(
    BuildContext context,
    TransactionSearch search,
  ) async {
    final cubit = context.read<SearchCubit>();
    final now = DateTime.now();
    final from = search.from;
    final to = search.to;
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(now.year + 5, 12, 31),
      initialDateRange: from != null && to != null
          ? DateTimeRange(start: from, end: to)
          : null,
    );
    if (picked == null) return;
    await cubit.setDates(picked.start, picked.end);
  }
}

/// "Any category", one category's name, or the first name and how many more.
class _CategoryChip extends StatelessWidget {
  const _CategoryChip({required this.search});

  final TransactionSearch search;

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;
    final categories = _categoriesFor(
      context.watch<CategoriesCubit>().state,
      search.type,
    );
    final chosen = [
      for (final category in categories)
        if (search.categoryIds.contains(category.id)) category,
    ];
    final label = switch (chosen) {
      [] => strings.anyCategory,
      [final only] => categoryLabel(strings, only),
      [final first, ...final rest] =>
        '${categoryLabel(strings, first)} +${rest.length}',
    };

    return InputChip(
      avatar: const Icon(Icons.label_outline_rounded, size: 18),
      label: Text(label),
      selected: chosen.isNotEmpty,
      showCheckmark: false,
      onPressed: () => _pickCategories(context, categories),
      onDeleted: chosen.isEmpty
          ? null
          : () => context.read<SearchCubit>().setCategories(const {}),
    );
  }

  /// Every category, or only those of the chosen type.
  static List<ExpenseCategory> _categoriesFor(
    CategoriesState state,
    TransactionType? type,
  ) => switch (state) {
    CategoriesReady(:final categories) => [
      for (final category in categories)
        if (type == null || category.type == type) category,
    ],
    _ => const [],
  };

  Future<void> _pickCategories(
    BuildContext context,
    List<ExpenseCategory> categories,
  ) async {
    final cubit = context.read<SearchCubit>();
    final picked = await showModalBottomSheet<Set<String>>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) =>
          _CategorySheet(categories: categories, initial: search.categoryIds),
    );
    if (picked == null) return;
    await cubit.setCategories(picked);
  }
}

class _CategorySheet extends StatefulWidget {
  const _CategorySheet({required this.categories, required this.initial});

  final List<ExpenseCategory> categories;
  final Set<String> initial;

  @override
  State<_CategorySheet> createState() => _CategorySheetState();
}

class _CategorySheetState extends State<_CategorySheet> {
  /// Local UI state: the ticks, handed back only when the sheet is confirmed.
  late final Set<String> _selected = {...widget.initial};

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;

    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.7,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: [
                  for (final category in widget.categories)
                    CheckboxListTile(
                      value: _selected.contains(category.id),
                      secondary: CategoryAvatar(category: category),
                      title: Text(categoryLabel(strings, category)),
                      onChanged: (checked) => setState(
                        () => checked == true
                            ? _selected.add(category.id)
                            : _selected.remove(category.id),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.of(context).pop(_selected),
                  child: Text(strings.ok),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Results extends StatelessWidget {
  const _Results();

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;

    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) => switch (state) {
        SearchIdle() => _Message(
          icon: Icons.search_rounded,
          text: strings.searchPrompt,
        ),
        SearchLoading(previous: []) => const Center(
          child: CircularProgressIndicator(),
        ),
        SearchLoading(:final previous) => Column(
          children: [
            const LinearProgressIndicator(minHeight: 2),
            Expanded(child: _ResultList(results: previous)),
          ],
        ),
        SearchResults(results: []) => _Message(
          icon: Icons.search_off_rounded,
          text: strings.noSearchResults,
        ),
        SearchResults(:final results) => _ResultList(results: results),
        SearchFailure(:final error) => _Message(
          icon: Icons.error_outline_rounded,
          text: strings.failure(error),
        ),
      },
    );
  }
}

class _ResultList extends StatelessWidget {
  const _ResultList({required this.results});

  final List<Expense> results;

  Future<void> _open(BuildContext context, Expense expense) async {
    final search = context.read<SearchCubit>();
    final home = context.read<HomeCubit>();
    final saved = await Navigator.of(
      context,
    ).push(ExpenseFormPage.route(existing: expense));
    if (!(saved ?? false)) return;
    await Future.wait([search.refresh(), home.refresh()]);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final strings = context.strings;
    final formats = context.select<SettingsCubit, AppFormats>(
      (cubit) => cubit.state.formats,
    );
    var spent = 0.0;
    var received = 0.0;
    for (final expense in results) {
      if (expense.isIncome) {
        received += expense.amount;
      } else {
        spent += expense.amount;
      }
    }

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(24, 4, 24, 4),
          sliver: SliverToBoxAdapter(
            child: Text(
              [
                strings.transactionCount(results.length),
                if (spent > 0)
                  '${strings.totalExpenses} ${formats.money(spent)}',
                if (received > 0)
                  '${strings.totalIncome} +${formats.money(received)}',
              ].join(' · '),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 24),
          sliver: SliverList.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              final expense = results[index];
              final tile = ExpenseTile(
                expense: expense,
                formats: formats,
                onTap: () => _open(context, expense),
              );
              final startsNewDay =
                  index == 0 ||
                  !AppFormats.isSameDay(results[index - 1].date, expense.date);
              if (!startsNewDay) return tile;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 16, 12, 4),
                    // Results span months and years, so the year is shown.
                    child: Text(
                      formats.fullDate(expense.date),
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  tile,
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: theme.colorScheme.onSurfaceVariant),
            const SizedBox(height: 12),
            Text(
              text,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
