import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/l10n/app_strings.dart';
import '../../../auth/domain/entities/app_user.dart';
import '../../../auth/presentation/cubit/account_cubit.dart';
import '../../../auth/presentation/cubit/account_state.dart';
import '../../../auth/presentation/pages/sign_in_page.dart';
import '../../../sync/presentation/widgets/backup_section.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/usecases/save_currency_symbol.dart';
import '../cubit/settings_cubit.dart';
import '../cubit/settings_state.dart';

/// Account and backup, appearance, language and currency.
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
              Text(strings.account, style: theme.textTheme.labelLarge),
              const SizedBox(height: 10),
              const _AccountSection(),
              const SizedBox(height: 24),
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
              const _GuestStorageNote(),
            ],
          ),
        ),
      ),
    );
  }
}

/// Who is signed in, or a way to sign in. Signing in is optional.
class _AccountSection extends StatelessWidget {
  const _AccountSection();

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;

    return BlocSelector<AccountCubit, AccountState, AppUser?>(
      selector: (state) => switch (state) {
        SignedIn(:final user) => user,
        SignedOut() => null,
      },
      builder: (context, user) => switch (user) {
        null => SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            icon: const Icon(Icons.login_rounded),
            label: Text(strings.signIn),
            onPressed: () => Navigator.of(context).push(SignInPage.route()),
          ),
        ),
        final user => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const CircleAvatar(child: Icon(Icons.person_rounded)),
              title: Text(user.email, overflow: TextOverflow.ellipsis),
              subtitle: Text(strings.signedIn),
              trailing: TextButton(
                onPressed: () => context.read<AccountCubit>().signOut(),
                child: Text(strings.signOut),
              ),
            ),
            const SizedBox(height: 8),
            const BackupSection(),
            const SizedBox(height: 12),
            const _DeleteAccountButton(),
          ],
        ),
      },
    );
  }
}

/// Google Play requires a way to delete the account from inside any app that
/// lets people create one.
class _DeleteAccountButton extends StatelessWidget {
  const _DeleteAccountButton();

  Future<void> _confirmAndDelete(BuildContext context) async {
    final strings = context.strings;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(strings.deleteAccountTitle),
        content: Text(strings.deleteAccountBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(strings.cancel),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(dialogContext).colorScheme.error,
            ),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(strings.delete),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final deleted = await context.read<AccountCubit>().deleteAccount();
    if (!deleted) return;

    // Close the sheet so the confirmation shows on the home screen.
    navigator.pop();
    messenger.showSnackBar(SnackBar(content: Text(strings.accountDeleted)));
  }

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;
    final errorColor = Theme.of(context).colorScheme.error;

    return BlocSelector<AccountCubit, AccountState, (bool, FailureCode?)>(
      selector: (state) => switch (state) {
        SignedIn(:final isDeleting, :final deleteError) => (
          isDeleting,
          deleteError,
        ),
        SignedOut() => (false, null),
      },
      builder: (context, status) {
        final (isDeleting, error) = status;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isDeleting)
              Row(
                children: [
                  const SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  const SizedBox(width: 12),
                  Text(strings.deletingAccount),
                ],
              )
            else
              TextButton.icon(
                style: TextButton.styleFrom(foregroundColor: errorColor),
                icon: const Icon(Icons.delete_forever_outlined),
                label: Text(strings.deleteAccount),
                onPressed: () => _confirmAndDelete(context),
              ),
            if (error != null)
              Text(strings.failure(error), style: TextStyle(color: errorColor)),
          ],
        );
      },
    );
  }
}

/// Where a guest's data lives. A signed-in user sees the backup controls
/// instead.
class _GuestStorageNote extends StatelessWidget {
  const _GuestStorageNote();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocSelector<AccountCubit, AccountState, bool>(
      selector: (state) => state is SignedOut,
      builder: (context, isGuest) => isGuest
          ? Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text(
                context.strings.storedOnThisDevice,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            )
          : const SizedBox.shrink(),
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
