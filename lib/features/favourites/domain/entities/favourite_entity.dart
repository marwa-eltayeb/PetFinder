import 'package:petfinder/core/utils/pet_type.dart';

class FavouriteEntity {
  final int id;
  final String imageId;
  final String? petId;
  final String? subId;
  final PetType type;
  final String? imageUrl;
  final String? breedName;
  final String? origin;

  const FavouriteEntity({
    required this.id,
    required this.imageId,
    this.petId,
    this.subId,
    required this.type,
    this.imageUrl,
    this.breedName,
    this.origin,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FavouriteEntity &&
        other.id == id &&
        other.imageId == imageId &&
        other.petId == petId &&
        other.subId == subId &&
        other.type == type &&
        other.imageUrl == imageUrl &&
        other.breedName == breedName &&
        other.origin == origin;
  }

  @override
  int get hashCode =>
      Object.hash(id, imageId, petId, subId, type, imageUrl, breedName, origin);
}
