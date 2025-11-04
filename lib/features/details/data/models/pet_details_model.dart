import 'package:hive/hive.dart';

import '../../../../core/utils/pet_type.dart';
import '../../domain/entities/pet_details.dart';

part 'pet_details_model.g.dart';

@HiveType(typeId: 1)
class PetDetailsModel {

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final int typeIndex;

  @HiveField(3)
  final String? origin;

  @HiveField(4)
  final String? temperament;

  @HiveField(5)
  final String? description;

  @HiveField(6)
  final String? imageUrl;

  @HiveField(7)
  final String weight;

  @HiveField(8)
  final String lifeSpan;

  PetDetailsModel({
    required this.id,
    required this.name,
    required this.typeIndex,
    this.origin,
    this.temperament,
    this.description,
    this.imageUrl,
    required this.weight,
    required this.lifeSpan,
  });

  PetType get type => PetType.values[typeIndex];

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
      typeIndex: type.index,
      origin: json['origin'],
      temperament: json['temperament'],
      description: description,
      imageUrl: imageUrl,
      weight: json['weight']?['metric'] ?? 'Unknown',
      lifeSpan: lifeSpan,
    );
  }

  factory PetDetailsModel.fromEntity(PetDetails petDetails) {
    return PetDetailsModel(
      id: petDetails.id,
      name: petDetails.name,
      typeIndex: petDetails.type.index,
      origin: petDetails.origin,
      temperament: petDetails.temperament,
      description: petDetails.description,
      imageUrl: petDetails.imageUrl,
      weight: petDetails.weight ?? 'Unknown',
      lifeSpan: petDetails.lifeSpan ?? 'Unknown',
    );
  }

  PetDetails toEntity() {
    return PetDetails(
      id: id,
      name: name,
      type: type,
      origin: origin,
      temperament: temperament,
      description: description,
      imageUrl: imageUrl,
      weight: weight,
      lifeSpan: lifeSpan,
    );
  }

}
