import '../../domain/entities/pet.dart';
import '../../../../core/utils/pet_type.dart';

class PetModel extends Pet {
  PetModel({
    required super.id,
    required super.name,
    required super.type,
    super.imageUrl,
    super.origin,
  });

  factory PetModel.fromJson(Map<String, dynamic> json, PetType type) {
    final imageId = json['reference_image_id'];
    final baseUrl = type == PetType.cat
        ? 'https://cdn2.thecatapi.com/images'
        : 'https://cdn2.thedogapi.com/images';
    final imageUrl = imageId != null ? '$baseUrl/$imageId.jpg' : null;

    return PetModel(
      id: json['id'].toString(),
      name: json['name'],
      imageUrl: imageUrl,
      origin: json['origin'],
      type: type,
    );
  }
}
