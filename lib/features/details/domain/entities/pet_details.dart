import '../../../../core/utils/pet_type.dart';

class PetDetails {
  final dynamic id;
  final String name;
  final PetType type;
  final String? origin;
  final String? temperament;
  final String? description;
  final String? imageUrl;
  final String? weight;
  final String? lifeSpan;

  PetDetails({
    required this.id,
    required this.name,
    required this.type,
    this.origin,
    this.temperament,
    this.description,
    this.imageUrl,
    this.weight,
    this.lifeSpan,
  });
}
