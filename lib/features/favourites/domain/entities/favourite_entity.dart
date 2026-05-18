import 'package:petfinder/core/utils/pet_type.dart';

class FavouriteEntity {
  final int id;
  final String imageId;
  final String? subId;
  final PetType type;
  final String? imageUrl;
  final String? breedName;
  final String? origin;

  const FavouriteEntity({
    required this.id,
    required this.imageId,
    this.subId,
    required this.type,
    this.imageUrl,
    this.breedName,
    this.origin,
  });
}