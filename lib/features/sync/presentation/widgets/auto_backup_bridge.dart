import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/sync_cubit.dart';

/// Starts the automatic backup whenever the app goes to the background, and
/// once when it opens to catch anything a closed app missed. The backup
/// decides for itself whether it is turned on and has anything to upload.
class AutoBackupBridge extends StatefulWidget {
  const AutoBackupBridge({super.key, required this.child});

  final Widget child;

  @override
  State<AutoBackupBridge> createState() => _AutoBackupBridgeState();
}

class _AutoBackupBridgeState extends State<AutoBackupBridge> {
  late final AppLifecycleListener _lifecycle;

  @override
  void initState() {
    super.initState();
    _lifecycle = AppLifecycleListener(onHide: _backUp);
    WidgetsBinding.instance.addPostFrameCallback((_) => _backUp());
  }

  void _backUp() {
    if (mounted) context.read<SyncCubit>().autoBackUp();
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
