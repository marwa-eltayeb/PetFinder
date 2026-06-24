import 'package:hive/hive.dart';
import 'package:petfinder/core/network/network_config.dart';

import '../../domain/entities/pet.dart';
import '../../../../core/utils/pet_type.dart';

part 'pet_model.g.dart';

@HiveType(typeId: 0)
class PetModel {

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final int typeIndex;

  @HiveField(3)
  final String? imageUrl;

  @HiveField(4)
  final String? origin;

  @HiveField(5)
  final String? temperament;

  @HiveField(6)
  final String? imageId;

  PetModel({
    required this.id,
    required this.name,
    required this.typeIndex,
    this.imageUrl,
    this.origin,
    this.temperament,
    this.imageId,
  });

  PetType get type => PetType.values[typeIndex];

  // Used for cats
  factory PetModel.fromCatJson(Map<String, dynamic> json, PetType type) {
    final imageId = json['reference_image_id'] as String?;

    return PetModel(
      id: json['id'].toString(),
      name: json['name'],
      typeIndex: type.index,
      imageUrl: NetworkConfig.buildImageUrl(imageId),
      origin: json['origin'],
      temperament: json['temperament'],
      imageId: imageId ?? json['id'].toString(),
    );
  }

  // Used for dogs
  factory PetModel.fromDogJson(Map<String, dynamic> json, PetType type) {
    final imageId = json['id'] as String;
    final imageUrl = json['url'] as String?;

    final breeds = json['breeds'] as List?;
    final breed = (breeds != null && breeds.isNotEmpty)
        ? breeds[0] as Map<String, dynamic>
        : <String, dynamic>{};

    return PetModel(
      id: breed['id']?.toString() ?? imageId,
      name: breed['name'] as String? ?? 'Unknown',
      typeIndex: type.index,
      imageUrl: imageUrl,
      origin: breed['origin'] as String?,
      temperament: breed['temperament'] as String?,
      imageId: imageId,
    );
  }

  factory PetModel.fromEntity(PetEntity pet) {
    return PetModel(
      id: pet.id,
      name: pet.name,
      typeIndex: pet.type.index,
      imageUrl: pet.imageUrl,
      origin: pet.origin,
      temperament: pet.temperament,
      imageId: pet.imageId,
    );
  }

  PetEntity toEntity() {
    return PetEntity(
      id: id,
      name: name,
      type: type,
      imageUrl: imageUrl,
      origin: origin,
      temperament: temperament,
      imageId: imageId,
    );
  }

}
