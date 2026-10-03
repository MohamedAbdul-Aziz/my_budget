import 'package:equatable/equatable.dart';

/// Where on screen the share sheet should point from. iPads show it as a
/// popover anchored to the button that opened it; phones ignore it.
class ShareAnchor extends Equatable {
  const ShareAnchor({
    required this.left,
    required this.top,
    required this.width,
    required this.height,
  });

  final double left;
  final double top;
  final double width;
  final double height;

  @override
  List<Object?> get props => [left, top, width, height];
}
