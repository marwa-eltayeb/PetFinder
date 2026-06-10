import '../../domain/entities/favourite_entity.dart';
import '../../../../core/utils/pet_type.dart';

class FavouriteModel {
  final int id;
  final String imageId;
  final String? petId;

  final String? subId;
  final PetType type;

  const FavouriteModel({
    required this.id,
    required this.imageId,
    this.petId,
    this.subId,
    required this.type,
  });

  factory FavouriteModel.fromJson(Map<String, dynamic> json, PetType type) {
    return FavouriteModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      imageId: json['image_id'] ?? '',
      petId: json['pet_id']?.toString(),
      subId: json['sub_id'],
      type: type,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image_id': imageId,
      'pet_id': petId,
      'sub_id': subId,
      'type': type.name,
    };
  }


  FavouriteEntity toEntity({
    String? imageUrl,
    String? breedName,
    String? origin,
    String? petId,
  }) {
    return FavouriteEntity(
      id: id,
      imageId: imageId,
      petId: petId ?? this.petId,
      subId: subId,
      type: type,
      imageUrl: imageUrl,
      breedName: breedName,
      origin: origin,
    );
  }

  FavouriteModel copyWith({
    int? id,
    String? imageId,
    String? petId,
    String? subId,
    PetType? type,
  }) {
    return FavouriteModel(
      id: id ?? this.id,
      imageId: imageId ?? this.imageId,
      petId: petId ?? this.petId,
      subId: subId ?? this.subId,
      type: type ?? this.type,
    );
  }
}