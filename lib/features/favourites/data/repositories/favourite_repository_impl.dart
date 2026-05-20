import 'package:dio/dio.dart';
import 'package:petfinder/core/network/failures.dart';
import 'package:petfinder/core/utils/pet_type.dart';
import 'package:petfinder/features/favourites/data/datsources/favourites_local_data_source.dart';
import 'package:petfinder/features/favourites/data/datsources/favourites_remote_data_source.dart';
import 'package:petfinder/features/favourites/domain/entities/favourite_entity.dart';
import 'package:petfinder/features/favourites/domain/repositories/favourite_repository.dart';

class FavouritesRepositoryImpl implements FavouritesRepository {
  final FavouritesRemoteDataSource remote;
  final FavouritesLocalDataSource local;

  FavouritesRepositoryImpl(this.remote, this.local);

  @override
  Future<List<FavouriteEntity>> getFavourites(PetType type) async {
    try{
      final favouriteModels = await remote.getFavourites(type);

      return favouriteModels.map((model) {
        final metadata = local.getFavouriteMetadata(model.imageId, type);

        return model.toEntity(
          imageUrl: metadata?['imageUrl'],
          breedName: metadata?['name'],
          origin: metadata?['origin'],
        );
      }).toList();
    } on DioException catch (e) {
      throw ServerFailure.fromDioException(dioException: e);
    }
  }

  @override
  Future<FavouriteEntity> addFavourite(PetType type, String imageId, String subId, String name, String imageUrl, String origin,) async {
    try{
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
    } on DioException catch (e) {
      throw ServerFailure.fromDioException(dioException: e);
    }
  }

  @override
  Future<void> removeFavourite(PetType type, int favouriteId) async {
    try {
      // Get the imageId before removing
      final favouriteModels = await remote.getFavourites(type);
      final favModel = favouriteModels.firstWhere((f) => f.id == favouriteId);

      // Remove from API
      await remote.removeFavourite(type, favouriteId);

      // Remove metadata from local storage
      await local.removeFavouriteMetadata(favModel.imageId, type);
    } on DioException catch (e) {
      throw ServerFailure.fromDioException(dioException: e);
    }
  }
}