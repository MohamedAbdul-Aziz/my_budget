import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/l10n/app_strings.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/usecases/save_currency_symbol.dart';
import '../cubit/settings_cubit.dart';
import '../cubit/settings_state.dart';

/// Appearance, language and currency. Everything stays on the device.
class SettingsSheet extends StatelessWidget {
  const SettingsSheet({super.key});

  static Future<void> show(BuildContext context) => showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    // The sheet reads the app-level cubit, which lives above this route.
    builder: (_) => BlocProvider.value(
      value: context.read<SettingsCubit>(),
      child: const SettingsSheet(),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final strings = context.strings;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          24,
          0,
          24,
          MediaQuery.viewInsetsOf(context).bottom + 24,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                strings.settings,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 20),
              Text(strings.appearance, style: theme.textTheme.labelLarge),
              const SizedBox(height: 10),
              const _ThemeModeSelector(),
              const SizedBox(height: 24),
              Text(strings.language, style: theme.textTheme.labelLarge),
              const SizedBox(height: 10),
              const _LanguageSelector(),
              const SizedBox(height: 24),
              Text(strings.currency, style: theme.textTheme.labelLarge),
              const SizedBox(height: 10),
              const _CurrencyField(),
              const SizedBox(height: 20),
              Text(
                strings.storedOnThisDevice,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ThemeModeSelector extends StatelessWidget {
  const _ThemeModeSelector();

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;

    return BlocSelector<SettingsCubit, SettingsState, AppThemeMode>(
      selector: (state) => state.settings.themeMode,
      builder: (context, mode) => SegmentedButton<AppThemeMode>(
        segments: [
          ButtonSegment(
            value: AppThemeMode.system,
            icon: const Icon(Icons.brightness_auto_rounded),
            label: Text(strings.themeSystem),
          ),
          ButtonSegment(
            value: AppThemeMode.light,
            icon: const Icon(Icons.light_mode_rounded),
            label: Text(strings.themeLight),
          ),
          ButtonSegment(
            value: AppThemeMode.dark,
            icon: const Icon(Icons.dark_mode_rounded),
            label: Text(strings.themeDark),
          ),
        ],
        selected: {mode},
        showSelectedIcon: false,
        onSelectionChanged: (selection) =>
            context.read<SettingsCubit>().setThemeMode(selection.first),
      ),
    );
  }
}

/// Language names are always written in their own language, so the option is
/// readable even when the app is currently in the other one.
class _LanguageSelector extends StatelessWidget {
  const _LanguageSelector();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<SettingsCubit, SettingsState, AppLanguage>(
      selector: (state) => state.settings.language,
      builder: (context, language) => SegmentedButton<AppLanguage>(
        segments: [
          ButtonSegment(
            value: AppLanguage.system,
            label: Text(context.strings.languageSystem),
          ),
          const ButtonSegment(
            value: AppLanguage.english,
            label: Text('English'),
          ),
          const ButtonSegment(
            value: AppLanguage.arabic,
            label: Text('العربية'),
          ),
        ],
        selected: {language},
        showSelectedIcon: false,
        onSelectionChanged: (selection) =>
            context.read<SettingsCubit>().setLanguage(selection.first),
      ),
    );
  }
}

class _CurrencyField extends StatefulWidget {
  const _CurrencyField();

  @override
  State<_CurrencyField> createState() => _CurrencyFieldState();
}

class _CurrencyFieldState extends State<_CurrencyField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: context.read<SettingsCubit>().state.formats.symbol,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    context.read<SettingsCubit>().setCurrencySymbol(text);
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;

    return TextField(
      controller: _controller,
      maxLength: SaveCurrencySymbol.maxSymbolLength,
      textInputAction: TextInputAction.done,
      onSubmitted: (_) => _save(),
      decoration: InputDecoration(
        labelText: strings.currencySymbol,
        counterText: '',
        helperText: strings.currencySymbolHint,
        suffixIcon: IconButton(
          icon: const Icon(Icons.check_rounded),
          onPressed: _save,
        ),
      ),
    );
  }
}
