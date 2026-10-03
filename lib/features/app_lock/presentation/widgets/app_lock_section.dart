import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/l10n/app_strings.dart';
import '../app_lock_texts.dart';
import '../cubit/app_lock_cubit.dart';
import '../cubit/app_lock_state.dart';

/// The settings sheet's app lock switch. Left out where the app offers no
/// lock (desktop), and disabled on a phone with no screen lock to use.
class AppLockSection extends StatelessWidget {
  const AppLockSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final strings = context.strings;

    return BlocBuilder<AppLockCubit, AppLockState>(
      builder: (context, state) {
        final status = state.status;
        if (!status.supported) return const SizedBox.shrink();
        final error = switch (state) {
          AppLockOpen(:final error) => error,
          _ => null,
        };
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            Text(strings.security, style: theme.textTheme.labelLarge),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              secondary: const Icon(Icons.lock_outline_rounded),
              title: Text(strings.appLock),
              subtitle: Text(
                status.available
                    ? strings.appLockHint
                    : strings.appLockUnavailable,
              ),
              value: status.enabled && status.available,
              onChanged: status.available
                  ? (enabled) => context.read<AppLockCubit>().setEnabled(
                      enabled,
                      changeLockPrompt(strings),
                    )
                  : null,
            ),
            if (error != null)
              Text(
                strings.failure(error),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
          ],
        );
      },
    );
  }
}
