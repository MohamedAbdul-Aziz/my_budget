import 'package:flutter/material.dart';

import '../../domain/entities/person.dart';

/// A person's initials on their color, the way a category's icon sits on
/// its tint.
class PersonAvatar extends StatelessWidget {
  const PersonAvatar({super.key, required this.person, this.size = 44});

  final Person person;
  final double size;

  @override
  Widget build(BuildContext context) {
    final color = Color(person.colorValue);
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.16),
        shape: BoxShape.circle,
      ),
      child: Text(
        person.initials,
        style: TextStyle(
          color: color,
          fontSize: size * 0.36,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
