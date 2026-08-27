import 'package:flutter/material.dart';

/// Icons are persisted by name, never by code point.
///
/// Storing a raw code point would force us to build non-const `IconData` at
/// runtime, which disables Flutter's icon tree shaking. Every icon the user can
/// pick is a `const` entry here instead.
abstract final class CategoryIcons {
  static const String fallbackName = 'category';

  static const Map<String, IconData> all = <String, IconData>{
    'category': Icons.category_rounded,
    'restaurant': Icons.restaurant_rounded,
    'local_cafe': Icons.local_cafe_rounded,
    'local_grocery_store': Icons.local_grocery_store_rounded,
    'fastfood': Icons.fastfood_rounded,
    'directions_bus': Icons.directions_bus_rounded,
    'directions_car': Icons.directions_car_rounded,
    'local_gas_station': Icons.local_gas_station_rounded,
    'flight': Icons.flight_rounded,
    'train': Icons.train_rounded,
    'receipt_long': Icons.receipt_long_rounded,
    'home': Icons.home_rounded,
    'bolt': Icons.bolt_rounded,
    'water_drop': Icons.water_drop_rounded,
    'wifi': Icons.wifi_rounded,
    'phone_iphone': Icons.phone_iphone_rounded,
    'shopping_bag': Icons.shopping_bag_rounded,
    'checkroom': Icons.checkroom_rounded,
    'devices': Icons.devices_rounded,
    'card_giftcard': Icons.card_giftcard_rounded,
    'fitness_center': Icons.fitness_center_rounded,
    'favorite': Icons.favorite_rounded,
    'medical_services': Icons.medical_services_rounded,
    'spa': Icons.spa_rounded,
    'movie': Icons.movie_rounded,
    'sports_esports': Icons.sports_esports_rounded,
    'music_note': Icons.music_note_rounded,
    'sports_soccer': Icons.sports_soccer_rounded,
    'work': Icons.work_rounded,
    'school': Icons.school_rounded,
    'pets': Icons.pets_rounded,
    'child_care': Icons.child_care_rounded,
    'savings': Icons.savings_rounded,
    'volunteer_activism': Icons.volunteer_activism_rounded,
    'build': Icons.build_rounded,
    'more_horiz': Icons.more_horiz_rounded,
  };

  /// Never throws — unknown names fall back to a generic icon so a row from an
  /// older build can still render.
  static IconData resolve(String? name) =>
      all[name] ?? all[fallbackName] ?? Icons.category_rounded;

  static List<String> get names => all.keys.toList(growable: false);
}

/// The colors offered when creating or editing a category.
abstract final class CategoryColors {
  static const List<int> palette = <int>[
    0xFFEF6C00,
    0xFFF4511E,
    0xFFD81B60,
    0xFF8E24AA,
    0xFF5E35B1,
    0xFF3949AB,
    0xFF1E88E5,
    0xFF039BE5,
    0xFF00ACC1,
    0xFF00897B,
    0xFF43A047,
    0xFF7CB342,
    0xFFC0CA33,
    0xFFFDD835,
    0xFFFFB300,
    0xFF6D4C41,
    0xFF546E7A,
    0xFF757575,
  ];

  static int get defaultColor => palette[6];
}
