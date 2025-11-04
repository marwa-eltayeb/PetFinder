import 'package:hive/hive.dart';

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

  PetModel({
    required this.id,
    required this.name,
    required this.typeIndex,
    this.imageUrl,
    this.origin,
    this.temperament,
  });

  PetType get type => PetType.values[typeIndex];

  factory PetModel.fromJson(Map<String, dynamic> json, PetType type) {
    final imageId = json['reference_image_id'];
    final baseUrl = type == PetType.cat
        ? 'https://cdn2.thecatapi.com/images'
        : 'https://cdn2.thedogapi.com/images';
    final imageUrl = imageId != null ? '$baseUrl/$imageId.jpg' : null;

    return PetModel(
      id: json['id'].toString(),
      name: json['name'],
      typeIndex: type.index,
      imageUrl: imageUrl,
      origin: json['origin'],
      temperament: json['temperament'],
    );
  }

  factory PetModel.fromEntity(Pet pet) {
    return PetModel(
      id: pet.id,
      name: pet.name,
      typeIndex: pet.type.index,
      imageUrl: pet.imageUrl,
      origin: pet.origin,
      temperament: pet.temperament,
    );
  }

  Pet toEntity() {
    return Pet(
      id: id,
      name: name,
      type: type,
      imageUrl: imageUrl,
      origin: origin,
      temperament: temperament,
    );
  }

}
