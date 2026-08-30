/// How the widget tells Dart which category was tapped.
///
/// The Android quick-add activity boots the engine with this as its initial
/// route, so `main` can decide whether to run the whole app or just the
/// quick-add dialog before the first frame.
class QuickAddLaunch {
  const QuickAddLaunch({this.categoryId});

  static const String routeName = '/quick-add';

  /// Null when the widget's Add button was tapped rather than a category.
  final String? categoryId;

  /// Returns null for a normal app launch.
  static QuickAddLaunch? tryParse(String? route) {
    if (route == null) return null;
    final uri = Uri.tryParse(route);
    if (uri == null || uri.path != routeName) return null;

    final categoryId = uri.queryParameters['category'];
    return QuickAddLaunch(
      categoryId: (categoryId == null || categoryId.isEmpty)
          ? null
          : categoryId,
    );
  }
}
