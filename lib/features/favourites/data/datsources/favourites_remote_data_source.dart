import 'package:dio/dio.dart';
import '../../../../core/network/network_config.dart';
import '../../../../core/utils/api_constants.dart';
import '../../../../core/utils/pet_type.dart';
import '../models/favourite_model.dart';

abstract class FavouritesRemoteDataSource {
  Future<List<FavouriteModel>> getFavourites(PetType type);
  Future<FavouriteModel> addFavourite(PetType type, String imageId, String subId);
  Future<void> removeFavourite(PetType type, int favouriteId);
}

class FavouritesDataSourceImpl implements FavouritesRemoteDataSource {

  final Dio dio;
  FavouritesDataSourceImpl(this.dio);

  @override
  Future<List<FavouriteModel>> getFavourites(PetType type) async {
    try {
      final response = await dio.get(
        '${_getFullFavouritesUrl(type)}?api_key=${NetworkConfig.getApiKey(type)}',
      );

      if (response.statusCode == 200 && response.data is List) {
        final List data = response.data;

        return data.map((json) {
          return FavouriteModel(
            id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
            imageId: json['image_id'] ?? '',
            subId: json['sub_id'],
            type: type,
          );
        }).toList();
      } else {
        throw Exception(
          'Failed to load favourites: ${response.statusCode} ${response.statusMessage}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching favourites: $e');
    }
  }

  @override
  Future<FavouriteModel> addFavourite(
      PetType type, String imageId, String subId) async {
    try {
      final response = await dio.post(
        _getFullFavouritesUrl(type),
        options: Options(headers: {
          'x-api-key': NetworkConfig.getApiKey(type),
          'Content-Type': 'application/json',
        }),
        data: {'image_id': imageId, 'sub_id': subId},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return FavouriteModel(
          id: response.data['id'] is int ? response.data['id'] : int.tryParse(response.data['id'].toString()) ?? 0,
          imageId: imageId,
          subId: subId,
          type: type,
        );
      } else {
        throw Exception(
          'Failed to add favourite: ${response.statusCode} ${response.statusMessage}',
        );
      }
    } catch (e) {
      throw Exception('Error adding favourite: $e');
    }
  }

  @override
  Future<void> removeFavourite(PetType type, int favouriteId) async {
    try {
      final response = await dio.delete(
        '${_getFullFavouritesUrl(type)}/$favouriteId',
        options: Options(headers: {'x-api-key': NetworkConfig.getApiKey(type)}),
      );

      if (response.statusCode != 200) {
        throw Exception(
          'Failed to remove favourite: ${response.statusCode} ${response.statusMessage}',
        );
      }
    } catch (e) {
      throw Exception('Error removing favourite: $e');
    }
  }

  String _getFullFavouritesUrl(PetType type) {
    return '${NetworkConfig.getBaseUrl(type)}/v1/favourites';
  }
}