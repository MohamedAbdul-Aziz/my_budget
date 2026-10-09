import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/l10n/app_strings.dart';
import '../../domain/usecases/save_currency_symbol.dart';
import '../cubit/settings_cubit.dart';
import '../currency_choices.dart';

/// The currency row in Settings: the current currency, tapped to open a
/// searchable list of currencies with "Other" last for any symbol.
class CurrencySelector extends StatelessWidget {
  const CurrencySelector({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final strings = context.strings;
    final symbol = context.select<SettingsCubit, String>(
      (cubit) => cubit.state.formats.symbol,
    );
    final choice = currencyChoiceFor(symbol);

    return OutlinedButton(
      key: const Key('currency_selector'),
      onPressed: () => _pick(context, symbol),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 10, 12, 10),
        alignment: AlignmentDirectional.centerStart,
      ),
      child: Row(
        children: [
          _Flag(code: choice?.code),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              choice == null
                  ? strings.currencyOther
                  : strings.currencyName(choice.code) ?? choice.code,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyLarge,
            ),
          ),
          const SizedBox(width: 8),
          Text(symbol, style: theme.textTheme.titleMedium),
          const Icon(Icons.expand_more_rounded),
        ],
      ),
    );
  }

  Future<void> _pick(BuildContext context, String current) async {
    final cubit = context.read<SettingsCubit>();
    final picked = await showModalBottomSheet<_Pick>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      useSafeArea: true,
      builder: (_) => _CurrencySheet(current: current),
    );
    switch (picked) {
      case _Choice(:final symbol) when symbol != current:
        await cubit.setCurrencySymbol(symbol);
      case _Other() when context.mounted:
        final typed = await showDialog<String>(
          context: context,
          builder: (_) => _OtherSymbolDialog(
            initial: currencyChoiceFor(current) == null ? current : '',
          ),
        );
        if (typed != null && typed != current) {
          await cubit.setCurrencySymbol(typed);
        }
      case _Choice() || _Other() || null:
        break;
    }
  }
}

sealed class _Pick {
  const _Pick();
}

final class _Choice extends _Pick {
  const _Choice(this.symbol);

  final String symbol;
}

final class _Other extends _Pick {
  const _Other();
}

/// The country's flag, or a money icon for a currency the list lacks.
class _Flag extends StatelessWidget {
  const _Flag({required this.code});

  final String? code;

  @override
  Widget build(BuildContext context) {
    final code = this.code;
    return SizedBox(
      width: 32,
      child: code == null
          ? Icon(
              Icons.payments_outlined,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            )
          : Text(
              currencyFlag(code),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24),
            ),
    );
  }
}

class _CurrencySheet extends StatefulWidget {
  const _CurrencySheet({required this.current});

  /// The symbol in use now, shown as selected.
  final String current;

  @override
  State<_CurrencySheet> createState() => _CurrencySheetState();
}

class _CurrencySheetState extends State<_CurrencySheet> {
  late final TextEditingController _search;

  /// Local UI state: what the list is filtered by.
  String _query = '';

  @override
  void initState() {
    super.initState();
    _search = TextEditingController();
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  /// Matches the code, the symbol, or the name in the app's language or in
  /// English, so "dollar", "usd" and "$" all find the US dollar.
  bool _matches(
    ({String code, String symbol}) choice,
    AppStrings strings,
    String query,
  ) {
    if (query.isEmpty) return true;
    final haystack = [
      choice.code,
      choice.symbol,
      strings.currencyName(choice.code) ?? '',
      const AppStringsEn().currencyName(choice.code) ?? '',
    ].join(' ').toLowerCase();
    return haystack.contains(query);
  }

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;
    final query = _query.trim().toLowerCase();
    final shown = [
      for (final choice in currencyChoices)
        if (_matches(choice, strings, query)) choice,
    ];
    // Only the first row with the current symbol is marked: CNY and JPY
    // share "¥".
    final selected = currencyChoiceFor(widget.current);
    final isCustom = selected == null;

    return FractionallySizedBox(
      heightFactor: 0.85,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: TextField(
              controller: _search,
              textInputAction: TextInputAction.search,
              onChanged: (text) => setState(() => _query = text),
              decoration: InputDecoration(
                hintText: strings.search,
                prefixIcon: const Icon(Icons.search_rounded),
                border: const OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              key: const Key('currency_options'),
              itemCount: shown.length + 1,
              itemBuilder: (context, index) {
                if (index == shown.length) {
                  return _OtherTile(
                    symbol: isCustom ? widget.current : null,
                    onTap: () => Navigator.of(context).pop(const _Other()),
                  );
                }
                final choice = shown[index];
                return _CurrencyTile(
                  choice: choice,
                  selected: choice == selected,
                  onTap: () =>
                      Navigator.of(context).pop(_Choice(choice.symbol)),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CurrencyTile extends StatelessWidget {
  const _CurrencyTile({
    required this.choice,
    required this.selected,
    required this.onTap,
  });

  final ({String code, String symbol}) choice;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      selected: selected,
      leading: _Flag(code: choice.code),
      title: Text(choice.code),
      subtitle: Text(
        context.strings.currencyName(choice.code) ?? choice.code,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            choice.symbol,
            style: theme.textTheme.titleMedium?.copyWith(
              color: selected ? theme.colorScheme.primary : null,
            ),
          ),
          if (selected) ...[
            const SizedBox(width: 8),
            Icon(Icons.check_rounded, color: theme.colorScheme.primary),
          ],
        ],
      ),
      onTap: onTap,
    );
  }
}

/// Last in the list: a symbol of the user's own.
class _OtherTile extends StatelessWidget {
  const _OtherTile({required this.symbol, required this.onTap});

  /// The custom symbol in use now, if any.
  final String? symbol;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final symbol = this.symbol;
    return ListTile(
      selected: symbol != null,
      leading: const _Flag(code: null),
      title: Text(context.strings.currencyOther),
      trailing: symbol == null
          ? const Icon(Icons.chevron_right_rounded)
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  symbol,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.check_rounded, color: theme.colorScheme.primary),
              ],
            ),
      onTap: onTap,
    );
  }
}

/// Any symbol of up to [SaveCurrencySymbol.maxSymbolLength] characters.
class _OtherSymbolDialog extends StatefulWidget {
  const _OtherSymbolDialog({required this.initial});

  final String initial;

  @override
  State<_OtherSymbolDialog> createState() => _OtherSymbolDialogState();
}

class _OtherSymbolDialogState extends State<_OtherSymbolDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initial);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    Navigator.of(context).pop(text);
  }

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;
    return AlertDialog(
      title: Text(strings.currencyOther),
      content: TextField(
        controller: _controller,
        autofocus: true,
        maxLength: SaveCurrencySymbol.maxSymbolLength,
        textInputAction: TextInputAction.done,
        onSubmitted: (_) => _save(),
        decoration: InputDecoration(
          labelText: strings.currencySymbol,
          helperText: strings.currencySymbolHint,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(strings.cancel),
        ),
        FilledButton(onPressed: _save, child: Text(strings.save)),
      ],
    );
  }
}
