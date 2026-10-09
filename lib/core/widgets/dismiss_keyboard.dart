import 'package:flutter/widgets.dart';

/// Closes the keyboard when the user taps anywhere that does not take the
/// tap itself: empty space, a label, a card.
///
/// Placed once above every route. A button, a chip or a text field wins the
/// tap over this one, so tapping them works as before and does not first
/// close the keyboard (which would slide a button out from under the finger).
/// Scrolling is a drag, not a tap, so it leaves the keyboard open.
class DismissKeyboard extends StatelessWidget {
  const DismissKeyboard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => GestureDetector(
    behavior: HitTestBehavior.translucent,
    onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
    child: child,
  );
}
