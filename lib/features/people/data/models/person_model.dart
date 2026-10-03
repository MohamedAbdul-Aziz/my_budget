import '../../domain/entities/person.dart';

/// Maps a `people` row to the domain entity and back.
class PersonModel extends Person {
  const PersonModel({
    required super.id,
    required super.name,
    required super.colorValue,
    required super.createdAt,
    super.phone,
  });

  factory PersonModel.fromMap(Map<String, Object?> map) => PersonModel(
    id: map['id']! as String,
    name: map['name']! as String,
    phone: map['phone'] as String?,
    colorValue: (map['color_value']! as num).toInt(),
    createdAt: DateTime.fromMillisecondsSinceEpoch(
      (map['created_at']! as num).toInt(),
    ),
  );

  static Map<String, Object?> toRow(Person person) => {
    'id': person.id,
    'name': person.name,
    'phone': person.phone,
    'color_value': person.colorValue,
    'created_at': person.createdAt.millisecondsSinceEpoch,
  };
}
