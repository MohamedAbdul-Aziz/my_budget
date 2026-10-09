import 'package:flutter/widgets.dart';

/// A form whose fields scroll while its main [action] stays in view.
///
/// With the keyboard open there is little room left, and a button placed at
/// the end of a scrolling form slides out of sight below the keyboard. Here
/// only [content] scrolls; [action] is laid out after it and keeps its
/// place at the bottom of whatever space remains. When everything fits, it
/// looks exactly like one column with the button last.
///
/// Works in a bottom sheet that already rises with the keyboard and in a
/// Scaffold body, which the Scaffold shrinks to sit above it.
class PinnedAction extends StatelessWidget {
  const PinnedAction({
    super.key,
    required this.content,
    required this.action,
    this.spacing = 20,
    this.crossAxisAlignment = CrossAxisAlignment.stretch,
  });

  final Widget content;
  final Widget action;

  /// Gap between [content] and [action].
  final double spacing;

  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: crossAxisAlignment,
    children: [
      Flexible(child: SingleChildScrollView(child: content)),
      SizedBox(height: spacing),
      action,
    ],
  );
}
