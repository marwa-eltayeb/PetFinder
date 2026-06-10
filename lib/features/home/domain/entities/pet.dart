import '../../../../core/utils/pet_type.dart';

class Pet {
  final String id;
  final String name;
  final PetType type;
  final String? imageId;
  final String? imageUrl;
  final String? origin;
  final String? temperament;

  Pet({
    required this.id,
    required this.name,
    required this.type,
    this.imageId,
    this.imageUrl,
    this.origin,
    this.temperament,
  });
}
