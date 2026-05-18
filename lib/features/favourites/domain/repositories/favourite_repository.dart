import 'package:petfinder/core/utils/pet_type.dart';
import 'package:petfinder/features/favourites/domain/entities/favourite_entity.dart';

abstract class FavouritesRepository {
  Future<List<FavouriteEntity>> getFavourites(PetType type);

  Future<FavouriteEntity> addFavourite(
    PetType type,
    String imageId,
    String subId,
    String name,
    String imageUrl,
    String origin,
  );

  Future<void> removeFavourite(PetType type, int favouriteId);
}
