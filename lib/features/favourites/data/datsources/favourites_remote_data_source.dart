import 'package:dio/dio.dart';
import 'package:petfinder/core/network/dio_client.dart';
import 'package:petfinder/core/network/network_config.dart';
import 'package:petfinder/core/utils/pet_type.dart';
import 'package:petfinder/features/favourites/data/models/favourite_model.dart';

abstract class FavouritesRemoteDataSource {
  Future<List<FavouriteModel>> getFavourites(PetType type);
  Future<FavouriteModel> addFavourite(PetType type, String imageId, String subId);
  Future<void> removeFavourite(PetType type, int favouriteId);
}

class FavouritesDataSourceImpl implements FavouritesRemoteDataSource {

  final DioClient client;
  FavouritesDataSourceImpl(this.client);

  @override
  Future<List<FavouriteModel>> getFavourites(PetType type) async {
    final response = await client.get(
      NetworkConfig.getBaseUrl(type),
      '/v1/favourites',
      headers: {'x-api-key': NetworkConfig.getApiKey(type)},
    );

    final List data = response.data;
    return data.map((json) => FavouriteModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      imageId: json['image_id'] ?? '',
      subId: json['sub_id'],
      type: type,
    )).toList();
  }

  @override
  Future<FavouriteModel> addFavourite(PetType type, String imageId, String subId) async {
    final response = await client.post(
      NetworkConfig.getBaseUrl(type),
      '/v1/favourites',
      data: {'image_id': imageId, 'sub_id': subId},
      headers: {
        'x-api-key': NetworkConfig.getApiKey(type),
        'Content-Type': 'application/json',
      },
    );

    return FavouriteModel(
      id: response.data['id'] is int ? response.data['id'] : int.tryParse(response.data['id'].toString()) ?? 0,
      imageId: imageId,
      subId: subId,
      type: type,
    );
  }

  @override
  Future<void> removeFavourite(PetType type, int favouriteId) async {
      await client.delete(
        NetworkConfig.getBaseUrl(type),
        '/v1/favourites/$favouriteId',
        headers: {'x-api-key': NetworkConfig.getApiKey(type)},
      );
  }
}