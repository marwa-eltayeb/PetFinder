import '../../../../core/utils/pet_type.dart';
import '../../domain/entities/pet_details.dart';

class PetDetailsModel extends PetDetails {
  PetDetailsModel({
    required super.id,
    required super.name,
    required super.type,
    super.origin,
    super.temperament,
    super.description,
    super.imageUrl,
    required super.weight,
    required super.lifeSpan,
  });

  factory PetDetailsModel.fromJson(PetType type, Map<String, dynamic> json) {
    final imageId = json['reference_image_id'];
    final imageUrl = imageId != null
        ? (type == PetType.cat
        ? 'https://cdn2.thecatapi.com/images/$imageId.jpg'
        : 'https://cdn2.thedogapi.com/images/$imageId.jpg')
        : null;

    String lifeSpan = (json['life_span'] ?? 'Unknown').toString();
    lifeSpan = lifeSpan.replaceAll(RegExp(r'\s*years'), '').trim();

    final description = json['description'] ??
        json['bred_for'] ??
        json['breed_group'] ??
        'No description available';

    return PetDetailsModel(
      id: json['id'].toString(),
      name: json['name'],
      type: type,
      origin: json['origin'],
      temperament: json['temperament'],
      description: description,
      imageUrl: imageUrl,
      weight: json['weight']?['metric'] ?? 'Unknown',
      lifeSpan: lifeSpan,
    );
  }
}
