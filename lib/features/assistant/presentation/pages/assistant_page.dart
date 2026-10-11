import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/l10n/app_strings.dart';
import '../../../categories/domain/entities/expense_category.dart';
import '../../../categories/presentation/category_label.dart';
import '../../../data_management/domain/entities/share_anchor.dart';
import '../../../settings/presentation/cubit/settings_cubit.dart';
import '../../domain/entities/assistant_message.dart';
import '../../domain/usecases/ask_assistant.dart';
import '../cubit/assistant_cubit.dart';
import '../cubit/assistant_state.dart';
import '../widgets/assistant_sharing_sheet.dart';
import '../widgets/markdown_answer.dart';
import 'assistant_history_page.dart';

/// A conversation with the AI assistant about the user's own totals. It is
/// forgotten when the page closes.
class AssistantPage extends StatelessWidget {
  const AssistantPage({super.key});

  static Route<void> route() => MaterialPageRoute<void>(
    builder: (_) => BlocProvider(
      create: (_) => sl<AssistantCubit>()..load(),
      child: const AssistantPage(),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;
    return Scaffold(
      appBar: AppBar(
        title: Text(strings.assistantTitle),
        actions: const [_ChatButtons(), _StopSharingMenu()],
      ),
      body: SafeArea(
        child: BlocBuilder<AssistantCubit, AssistantState>(
          builder: (context, state) => switch (state) {
            AssistantLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
            AssistantNeedsConsent(:final failure) => _ConsentView(
              failure: failure,
            ),
            AssistantReady() => const _ChatView(),
          },
        ),
      ),
    );
  }
}

/// What the page sends along with each question: how the user reads their
/// categories, money and language.
({String Function(ExpenseCategory) labelOf, String currency, String language})
_askContext(BuildContext context) {
  final strings = context.strings;
  return (
    labelOf: (category) => categoryLabel(strings, category),
    currency: context.read<SettingsCubit>().state.formats.symbol,
    language: Localizations.localeOf(context).languageCode,
  );
}

/// New chat and History, shown once the user can ask. Both wait while a
/// question is on its way, so its answer lands in the chat it belongs to.
class _ChatButtons extends StatelessWidget {
  const _ChatButtons();

  @override
  Widget build(BuildContext context) {
    final ready = context.select<AssistantCubit, ({bool shown, bool idle})>(
      (cubit) => switch (cubit.state) {
        AssistantReady(:final sending) => (shown: true, idle: !sending),
        _ => (shown: false, idle: false),
      },
    );
    if (!ready.shown) return const SizedBox.shrink();
    final strings = context.strings;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          tooltip: strings.assistantSharingTitle,
          icon: const Icon(Icons.tune),
          onPressed: ready.idle
              ? () => AssistantSharingSheet.show(context)
              : null,
        ),
        IconButton(
          tooltip: strings.assistantNewChat,
          icon: const Icon(Icons.add_comment_outlined),
          onPressed: ready.idle
              ? () => context.read<AssistantCubit>().newChat()
              : null,
        ),
        IconButton(
          tooltip: strings.assistantHistory,
          icon: const Icon(Icons.history),
          onPressed: ready.idle
              ? () async {
                  final cubit = context.read<AssistantCubit>();
                  final chatId = await Navigator.of(
                    context,
                  ).push(AssistantHistoryPage.route());
                  if (chatId != null) await cubit.openChat(chatId);
                }
              : null,
        ),
      ],
    );
  }
}

class _StopSharingMenu extends StatelessWidget {
  const _StopSharingMenu();

  @override
  Widget build(BuildContext context) {
    final ready = context.select<AssistantCubit, bool>(
      (cubit) => cubit.state is AssistantReady,
    );
    if (!ready) return const SizedBox.shrink();
    return PopupMenuButton<void>(
      itemBuilder: (context) => [
        PopupMenuItem<void>(
          onTap: () => context.read<AssistantCubit>().revokeConsent(),
          child: Text(context.strings.assistantStopSharing),
        ),
      ],
    );
  }
}

class _ConsentView extends StatelessWidget {
  const _ConsentView({this.failure});

  final FailureCode? failure;

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;
    final theme = Theme.of(context);
    final failure = this.failure;
    return ListView(
      padding: const EdgeInsetsDirectional.all(24),
      children: [
        Icon(
          Icons.privacy_tip_outlined,
          size: 48,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(height: 16),
        Text(
          strings.assistantConsentTitle,
          style: theme.textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(strings.assistantConsentBody, style: theme.textTheme.bodyMedium),
        if (failure != null) ...[
          const SizedBox(height: 12),
          Text(
            strings.failure(failure),
            style: TextStyle(color: theme.colorScheme.error),
          ),
        ],
        const SizedBox(height: 24),
        FilledButton(
          onPressed: () => context.read<AssistantCubit>().grantConsent(),
          child: Text(strings.assistantConsentAgree),
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: () => Navigator.of(context).maybePop(),
          child: Text(strings.cancel),
        ),
      ],
    );
  }
}

class _ChatView extends StatefulWidget {
  const _ChatView();

  @override
  State<_ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<_ChatView> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _send([String? text]) {
    final question = text ?? _controller.text;
    if (AskAssistant.validate(question) != null) return;
    final ask = _askContext(context);
    context.read<AssistantCubit>().ask(
      question,
      labelOf: ask.labelOf,
      currency: ask.currency,
      languageCode: ask.language,
    );
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;
    return Column(
      children: [
        const Expanded(child: _Messages()),
        const _SharingNotice(),
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 4),
          child: Text(
            strings.assistantDisclaimer,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(12, 4, 8, 12),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  maxLength: AskAssistant.maxQuestionLength,
                  minLines: 1,
                  maxLines: 4,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _send(),
                  decoration: InputDecoration(
                    hintText: strings.assistantHint,
                    counterText: '',
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              _SendButton(onSend: _send),
            ],
          ),
        ),
      ],
    );
  }
}

/// Shown while the user shares more than the totals, so it is never
/// forgotten; tapping it opens the choices again.
class _SharingNotice extends StatelessWidget {
  const _SharingNotice();

  @override
  Widget build(BuildContext context) {
    final sharesMore = context.select<AssistantCubit, bool>(
      (cubit) => switch (cubit.state) {
        AssistantReady(:final sharing) => !sharing.isDefault,
        _ => false,
      },
    );
    if (!sharesMore) return const SizedBox.shrink();
    final theme = Theme.of(context);
    return InkWell(
      onTap: () => AssistantSharingSheet.show(context),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 6, 16, 2),
        child: Row(
          children: [
            Icon(Icons.tune, size: 16, color: theme.colorScheme.tertiary),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                context.strings.assistantSharingMore,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.tertiary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SendButton extends StatelessWidget {
  const _SendButton({required this.onSend});

  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    final sending = context.select<AssistantCubit, bool>(
      (cubit) => switch (cubit.state) {
        AssistantReady(:final sending) => sending,
        _ => false,
      },
    );
    return IconButton.filled(
      tooltip: context.strings.assistantSend,
      onPressed: sending ? null : onSend,
      icon: const Icon(Icons.send),
    );
  }
}

class _Messages extends StatelessWidget {
  const _Messages();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AssistantCubit>().state;
    if (state is! AssistantReady) return const SizedBox.shrink();
    final strings = context.strings;
    final failure = state.failure;

    if (state.messages.isEmpty && failure == null) {
      return _Suggestions(
        onPick: (question) => _askSuggested(context, question),
      );
    }

    // Newest at the bottom, kept in view as the list grows.
    final items = [
      for (final message in state.messages) _Bubble(message),
      if (!state.sending && failure == null && state.followUps.isNotEmpty)
        _FollowUps(state.followUps),
      if (state.sending)
        const Padding(
          padding: EdgeInsetsDirectional.all(16),
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: SizedBox.square(
              dimension: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        ),
      if (failure != null)
        _FailureLine(
          message: strings.failure(failure),
          canRetry: state.messages.lastOrNull?.isUser ?? false,
        ),
    ];
    return ListView(
      reverse: true,
      padding: const EdgeInsetsDirectional.symmetric(vertical: 8),
      children: items.reversed.toList(),
    );
  }
}

class _Suggestions extends StatelessWidget {
  const _Suggestions({required this.onPick});

  final ValueChanged<String> onPick;

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsetsDirectional.all(24),
      children: [
        Icon(Icons.auto_awesome, size: 40, color: theme.colorScheme.primary),
        const SizedBox(height: 12),
        Text(
          strings.assistantEmpty,
          style: theme.textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        for (final question in strings.assistantSuggestions)
          Padding(
            padding: const EdgeInsetsDirectional.only(bottom: 8),
            child: ActionChip(
              label: Text(question),
              onPressed: () => onPick(question),
            ),
          ),
      ],
    );
  }
}

/// Asks a suggested question as if the user had typed it.
void _askSuggested(BuildContext context, String question) {
  final ask = _askContext(context);
  context.read<AssistantCubit>().ask(
    question,
    labelOf: ask.labelOf,
    currency: ask.currency,
    languageCode: ask.language,
  );
}

/// The questions the assistant suggested after its last answer.
class _FollowUps extends StatelessWidget {
  const _FollowUps(this.questions);

  final List<String> questions;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(12, 4, 12, 4),
      child: Wrap(
        spacing: 8,
        runSpacing: 4,
        children: [
          for (final question in questions)
            ActionChip(
              avatar: const Icon(Icons.subdirectory_arrow_right, size: 16),
              label: Text(question),
              onPressed: () => _askSuggested(context, question),
            ),
        ],
      ),
    );
  }
}

Future<void> _copyAnswer(BuildContext context, String answer) async {
  final messenger = ScaffoldMessenger.of(context);
  final copied = context.strings.assistantCopied;
  await Clipboard.setData(ClipboardData(text: plainAnswer(answer)));
  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(copied)));
}

Future<void> _shareAnswer(BuildContext context, String answer) async {
  final messenger = ScaffoldMessenger.of(context);
  final strings = context.strings;
  // iPads point the share sheet at the answer it came from.
  final box = context.findRenderObject() as RenderBox?;
  final origin = box == null ? null : box.localToGlobal(Offset.zero) & box.size;
  final failure = await context.read<AssistantCubit>().share(
    plainAnswer(answer),
    anchor: origin == null
        ? null
        : ShareAnchor(
            left: origin.left,
            top: origin.top,
            width: origin.width,
            height: origin.height,
          ),
  );
  if (failure != null) {
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(strings.failure(failure))));
  }
}

/// Copy and Share for an answer, from a long press.
Future<void> _showAnswerActions(BuildContext context, String answer) {
  final strings = context.strings;
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (sheetContext) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.copy),
            title: Text(strings.assistantCopy),
            onTap: () {
              Navigator.of(sheetContext).pop();
              _copyAnswer(context, answer);
            },
          ),
          ListTile(
            leading: const Icon(Icons.share_outlined),
            title: Text(strings.assistantShare),
            onTap: () {
              Navigator.of(sheetContext).pop();
              _shareAnswer(context, answer);
            },
          ),
        ],
      ),
    ),
  );
}

class _Bubble extends StatelessWidget {
  const _Bubble(this.message);

  final AssistantMessage message;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isUser = message.isUser;
    final textStyle = DefaultTextStyle.of(context).style.copyWith(
      color: isUser ? scheme.onPrimaryContainer : scheme.onSurface,
    );
    final bubble = Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.sizeOf(context).width * 0.8,
      ),
      margin: const EdgeInsetsDirectional.symmetric(
        horizontal: 12,
        vertical: 4,
      ),
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: 14,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: isUser
            ? scheme.primaryContainer
            : scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: isUser
          ? Text(message.text, style: textStyle)
          : MarkdownAnswer(message.text, style: textStyle),
    );
    if (isUser) {
      return Align(alignment: AlignmentDirectional.centerEnd, child: bubble);
    }

    final strings = context.strings;
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onLongPress: () => _showAnswerActions(context, message.text),
            child: bubble,
          ),
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  visualDensity: VisualDensity.compact,
                  iconSize: 18,
                  tooltip: strings.assistantCopy,
                  icon: const Icon(Icons.copy),
                  onPressed: () => _copyAnswer(context, message.text),
                ),
                Builder(
                  builder: (buttonContext) => IconButton(
                    visualDensity: VisualDensity.compact,
                    iconSize: 18,
                    tooltip: strings.assistantShare,
                    icon: const Icon(Icons.share_outlined),
                    onPressed: () => _shareAnswer(buttonContext, message.text),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FailureLine extends StatelessWidget {
  const _FailureLine({required this.message, required this.canRetry});

  final String message;
  final bool canRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(message, style: TextStyle(color: theme.colorScheme.error)),
          if (canRetry)
            TextButton(
              onPressed: () {
                final ask = _askContext(context);
                context.read<AssistantCubit>().retry(
                  labelOf: ask.labelOf,
                  currency: ask.currency,
                  languageCode: ask.language,
                );
              },
              child: Text(context.strings.tryAgain),
            ),
        ],
      ),
    );
  }
}
