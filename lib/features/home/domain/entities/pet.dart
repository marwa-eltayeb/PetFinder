import '../../../../core/utils/pet_type.dart';

class Pet {
  final String id;
  final String name;
  final PetType type;
  final String? imageUrl;
  final String? origin;

  Pet({
    required this.id,
    required this.name,
    required this.type,
    this.imageUrl,
    this.origin,
  });
}
