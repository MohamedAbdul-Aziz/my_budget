import 'package:flutter/widgets.dart';

/// A Scaffold's `bottomNavigationBar` kept above the on-screen keyboard.
///
/// Scaffold shrinks its body for the keyboard but leaves the bottom bar at
/// the foot of the screen, under the keyboard, so a submit button placed
/// there disappears while the user types. This lifts [child] by the
/// keyboard's height. A SafeArea inside adds nothing while the keyboard is
/// up: the keyboard already covers the system bar.
class KeyboardLiftedBar extends StatelessWidget {
  const KeyboardLiftedBar({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
    child: child,
  );
}
