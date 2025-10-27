import '../../domain/entities/favourite_entity.dart';
import '../../../../core/utils/pet_type.dart';
import '../../domain/repositories/favourite_repository.dart';
import '../datsources/favourites_remote_data_source.dart';
import '../datsources/favourites_local_data_source.dart';

class FavouritesRepositoryImpl implements FavouritesRepository {
  final FavouritesRemoteDataSource remote;
  final FavouritesLocalDataSource local;

  FavouritesRepositoryImpl(this.remote, this.local);

  @override
  Future<List<FavouriteEntity>> getFavourites(PetType type) async {
    final favouriteModels = await remote.getFavourites(type);

    return favouriteModels.map((model) {
      final metadata = local.getFavouriteMetadata(model.imageId, type);

      return model.toEntity(
        imageUrl: metadata?['imageUrl'],
        breedName: metadata?['name'],
        origin: metadata?['origin'],
      );
    }).toList();
  }

  @override
  Future<FavouriteEntity> addFavourite(PetType type, String imageId, String subId, String name, String imageUrl, String origin,) async {

    // Save to API and get the result model
    final resultModel = await remote.addFavourite(type, imageId, subId);

    // Save metadata locally
    await local.saveFavouriteMetadata(imageId, type, name, imageUrl, origin);

    // Convert model to entity with the provided metadata
    return resultModel.toEntity(
      imageUrl: imageUrl,
      breedName: name,
      origin: origin,
    );
  }

  @override
  Future<void> removeFavourite(PetType type, int favouriteId) async {
    // Get the imageId before removing
    final favouriteModels = await remote.getFavourites(type);
    final favModel = favouriteModels.firstWhere((f) => f.id == favouriteId);

    // Remove from API
    await remote.removeFavourite(type, favouriteId);

    // Remove metadata from local storage
    await local.removeFavouriteMetadata(favModel.imageId, type);
  }
}