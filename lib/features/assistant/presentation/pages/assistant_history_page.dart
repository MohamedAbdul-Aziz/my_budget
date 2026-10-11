import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/l10n/app_strings.dart';
import '../../../../core/utils/app_formats.dart';
import '../../../settings/presentation/cubit/settings_cubit.dart';
import '../../domain/entities/assistant_chat.dart';
import '../cubit/assistant_history_cubit.dart';
import '../cubit/assistant_history_state.dart';

/// The chats saved on this phone. Picking one pops with its id, for the
/// assistant page to open.
class AssistantHistoryPage extends StatelessWidget {
  const AssistantHistoryPage({super.key});

  static Route<String> route() => MaterialPageRoute<String>(
    builder: (_) => BlocProvider(
      create: (_) => sl<AssistantHistoryCubit>()..load(),
      child: const AssistantHistoryPage(),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;
    return Scaffold(
      appBar: AppBar(
        title: Text(strings.assistantHistory),
        actions: const [_DeleteAllButton()],
      ),
      body: BlocBuilder<AssistantHistoryCubit, AssistantHistoryState>(
        builder: (context, state) => switch (state) {
          AssistantHistoryLoading() => const Center(
            child: CircularProgressIndicator(),
          ),
          AssistantHistoryLoadFailure(:final code) => Center(
            child: Padding(
              padding: const EdgeInsetsDirectional.all(24),
              child: Text(strings.failure(code), textAlign: TextAlign.center),
            ),
          ),
          AssistantHistoryReady(:final chats) when chats.isEmpty => Center(
            child: Padding(
              padding: const EdgeInsetsDirectional.all(24),
              child: Text(
                strings.assistantNoChats,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          AssistantHistoryReady(:final chats) => ListView.separated(
            itemCount: chats.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, index) => _ChatTile(chats[index]),
          ),
        },
      ),
    );
  }
}

/// Asks before anything is deleted: a chat cannot be brought back.
Future<bool> _confirm(
  BuildContext context, {
  required String title,
  String? body,
}) async {
  final strings = context.strings;
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(title),
      content: body == null ? null : Text(body),
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
  return confirmed == true && context.mounted;
}

class _DeleteAllButton extends StatelessWidget {
  const _DeleteAllButton();

  @override
  Widget build(BuildContext context) {
    final hasChats = context.select<AssistantHistoryCubit, bool>(
      (cubit) => switch (cubit.state) {
        AssistantHistoryReady(:final chats) => chats.isNotEmpty,
        _ => false,
      },
    );
    if (!hasChats) return const SizedBox.shrink();
    final strings = context.strings;
    return IconButton(
      tooltip: strings.assistantDeleteAll,
      icon: const Icon(Icons.delete_sweep_outlined),
      onPressed: () async {
        final cubit = context.read<AssistantHistoryCubit>();
        if (await _confirm(
          context,
          title: strings.assistantDeleteAll,
          body: strings.assistantDeleteAllBody,
        )) {
          await cubit.deleteAll();
        }
      },
    );
  }
}

class _ChatTile extends StatelessWidget {
  const _ChatTile(this.chat);

  final AssistantChat chat;

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;
    final formats = context.select<SettingsCubit, AppFormats>(
      (cubit) => cubit.state.formats,
    );
    return ListTile(
      leading: const Icon(Icons.chat_bubble_outline),
      title: Text(chat.title, maxLines: 2, overflow: TextOverflow.ellipsis),
      subtitle: Text(formats.dayLabel(chat.updatedAt)),
      onTap: () => Navigator.of(context).pop(chat.id),
      trailing: IconButton(
        tooltip: strings.delete,
        icon: const Icon(Icons.delete_outline),
        onPressed: () async {
          final cubit = context.read<AssistantHistoryCubit>();
          if (await _confirm(
            context,
            title: strings.assistantDeleteChatTitle,
          )) {
            await cubit.delete(chat.id);
          }
        },
      ),
    );
  }
}
