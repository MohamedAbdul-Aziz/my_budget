import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/l10n/app_strings.dart';
import '../cubit/account_cubit.dart';
import '../cubit/account_state.dart';

/// Sign in or create an account with an email and password, then confirm a
/// new account with the code emailed to it. Closes itself once the user is
/// signed in.
class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  static Route<void> route() =>
      MaterialPageRoute<void>(builder: (_) => const SignInPage());

  @override
  State<SignInPage> createState() => _SignInPageState();
}

String? _unconfirmedEmailOf(AccountState state) => switch (state) {
  SignedOut(:final unconfirmedEmail) => unconfirmedEmail,
  SignedIn() => null,
};

class _SignInPageState extends State<SignInPage> {
  // Created once here — never inside build(). Kept by the page rather than the
  // form so the typed email survives a trip to the code step and back.
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final FocusNode _passwordFocus;

  /// Local UI state: which of the two forms is showing.
  bool _isSignUp = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _passwordFocus = FocusNode();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  void _submit() {
    final cubit = context.read<AccountCubit>();
    final email = _emailController.text;
    final password = _passwordController.text;
    if (_isSignUp) {
      cubit.signUp(email: email, password: password);
    } else {
      cubit.signIn(email: email, password: password);
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;

    return BlocListener<AccountCubit, AccountState>(
      listener: (context, state) {
        switch (state) {
          case SignedIn():
            Navigator.of(context).pop();
          case SignedOut(:final error?):
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(strings.failure(error))));
          case SignedOut():
            break;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close_rounded),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          title: _PageTitle(isSignUp: _isSignUp),
        ),
        body: BlocSelector<AccountCubit, AccountState, String?>(
          selector: _unconfirmedEmailOf,
          builder: (context, unconfirmedEmail) => unconfirmedEmail == null
              ? _CredentialsForm(
                  emailController: _emailController,
                  passwordController: _passwordController,
                  passwordFocus: _passwordFocus,
                  isSignUp: _isSignUp,
                  onToggleMode: () => setState(() => _isSignUp = !_isSignUp),
                  onSubmit: _submit,
                )
              : _CodeForm(email: unconfirmedEmail),
        ),
      ),
    );
  }
}

class _PageTitle extends StatelessWidget {
  const _PageTitle({required this.isSignUp});

  final bool isSignUp;

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;

    return BlocSelector<AccountCubit, AccountState, bool>(
      selector: (state) => _unconfirmedEmailOf(state) != null,
      builder: (context, isConfirming) => Text(
        isConfirming
            ? strings.confirmEmail
            : isSignUp
            ? strings.createAccount
            : strings.signIn,
      ),
    );
  }
}

class _CredentialsForm extends StatelessWidget {
  const _CredentialsForm({
    required this.emailController,
    required this.passwordController,
    required this.passwordFocus,
    required this.isSignUp,
    required this.onToggleMode,
    required this.onSubmit,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final FocusNode passwordFocus;
  final bool isSignUp;
  final VoidCallback onToggleMode;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final strings = context.strings;

    return AutofillGroup(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          Text(
            strings.accountOptional,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: emailController,
            autofocus: true,
            autocorrect: false,
            enableSuggestions: false,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.email],
            onSubmitted: (_) => passwordFocus.requestFocus(),
            decoration: InputDecoration(
              labelText: strings.email,
              prefixIcon: const Icon(Icons.alternate_email_rounded),
            ),
          ),
          const SizedBox(height: 16),
          _PasswordField(
            controller: passwordController,
            focusNode: passwordFocus,
            isNewPassword: isSignUp,
            onSubmitted: onSubmit,
          ),
          const SizedBox(height: 24),
          _SubmitButton(
            label: isSignUp ? strings.createAccount : strings.signIn,
            onPressed: onSubmit,
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: onToggleMode,
            child: Text(
              isSignUp ? strings.haveAnAccount : strings.noAccountYet,
            ),
          ),
        ],
      ),
    );
  }
}

/// The code from the confirmation email. Entering it confirms the account and
/// signs the user in without leaving the app.
class _CodeForm extends StatefulWidget {
  const _CodeForm({required this.email});

  final String email;

  @override
  State<_CodeForm> createState() => _CodeFormState();
}

class _CodeFormState extends State<_CodeForm> {
  late final TextEditingController _codeController;

  @override
  void initState() {
    super.initState();
    _codeController = TextEditingController();
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _confirm() =>
      context.read<AccountCubit>().confirmSignUp(_codeController.text);

  Future<void> _resend() async {
    final messenger = ScaffoldMessenger.of(context);
    final sentMessage = context.strings.codeResent;
    final sent = await context.read<AccountCubit>().resendSignUpCode();
    if (!sent) return;
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(sentMessage)));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final strings = context.strings;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      children: [
        Icon(
          Icons.mark_email_unread_outlined,
          size: 48,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(height: 16),
        Text(
          strings.codeSentTo(widget.email),
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyLarge,
        ),
        const SizedBox(height: 24),
        TextField(
          controller: _codeController,
          autofocus: true,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          textInputAction: TextInputAction.done,
          autofillHints: const [AutofillHints.oneTimeCode],
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
          style: theme.textTheme.headlineSmall?.copyWith(letterSpacing: 8),
          onSubmitted: (_) => _confirm(),
          decoration: InputDecoration(labelText: strings.confirmationCode),
        ),
        const SizedBox(height: 24),
        _SubmitButton(label: strings.confirm, onPressed: _confirm),
        const SizedBox(height: 8),
        TextButton(onPressed: _resend, child: Text(strings.resendCode)),
        TextButton(
          onPressed: context.read<AccountCubit>().cancelConfirmation,
          child: Text(strings.useDifferentEmail),
        ),
      ],
    );
  }
}

class _PasswordField extends StatefulWidget {
  const _PasswordField({
    required this.controller,
    required this.focusNode,
    required this.isNewPassword,
    required this.onSubmitted,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isNewPassword;
  final VoidCallback onSubmitted;

  @override
  State<_PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<_PasswordField> {
  /// Local UI state, kept here so toggling it rebuilds only this field.
  bool _obscured = true;

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;

    return TextField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      obscureText: _obscured,
      autocorrect: false,
      enableSuggestions: false,
      textInputAction: TextInputAction.done,
      autofillHints: [
        widget.isNewPassword
            ? AutofillHints.newPassword
            : AutofillHints.password,
      ],
      onSubmitted: (_) => widget.onSubmitted(),
      decoration: InputDecoration(
        labelText: strings.password,
        helperText: widget.isNewPassword ? strings.passwordRules : null,
        prefixIcon: const Icon(Icons.lock_outline_rounded),
        suffixIcon: IconButton(
          tooltip: _obscured ? strings.showPassword : strings.hidePassword,
          icon: Icon(
            _obscured
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
          ),
          onPressed: () => setState(() => _obscured = !_obscured),
        ),
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<AccountCubit, AccountState, bool>(
      selector: (state) => state is SignedOut && state.isSubmitting,
      builder: (context, isSubmitting) => FilledButton(
        onPressed: isSubmitting ? null : onPressed,
        child: isSubmitting
            ? const SizedBox.square(
                dimension: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Text(label),
      ),
    );
  }
}
