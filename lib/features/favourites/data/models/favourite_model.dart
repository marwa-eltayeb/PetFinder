import '../../domain/entities/favourite_entity.dart';
import '../../../../core/utils/pet_type.dart';

class FavouriteModel {
  final int id;
  final String imageId;
  final String? subId;
  final PetType type;

  const FavouriteModel({
    required this.id,
    required this.imageId,
    this.subId,
    required this.type,
  });

  factory FavouriteModel.fromJson(Map<String, dynamic> json, PetType type) {
    return FavouriteModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      imageId: json['image_id'] ?? '',
      subId: json['sub_id'],
      type: type,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image_id': imageId,
      'sub_id': subId,
      'type': type.name,
    };
  }


  FavouriteEntity toEntity({
    String? imageUrl,
    String? breedName,
    String? origin,
  }) {
    return FavouriteEntity(
      id: id,
      imageId: imageId,
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
    String? subId,
    PetType? type,
  }) {
    return FavouriteModel(
      id: id ?? this.id,
      imageId: imageId ?? this.imageId,
      subId: subId ?? this.subId,
      type: type ?? this.type,
    );
  }
}