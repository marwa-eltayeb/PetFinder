import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../../../core/utils/pet_type.dart';

abstract class FavouritesLocalDataSource {
  Future<void> saveFavouriteMetadata(
      String imageId,
      PetType type,
      String name,
      String imageUrl,
      String origin);
  Map<String, dynamic>? getFavouriteMetadata(String imageId, PetType type);
  Future<void> removeFavouriteMetadata(String imageId, PetType type);
}

class FavouritesLocalDataSourceImpl implements FavouritesLocalDataSource {
  final SharedPreferences sharedPreferences;

  FavouritesLocalDataSourceImpl(this.sharedPreferences);

  String _getKey(String imageId, PetType type) => 'fav_${type.name}_$imageId';

  @override
  Future<void> saveFavouriteMetadata(
      String imageId,
      PetType type,
      String name,
      String imageUrl,
      String origin,
      ) async {
    final data = {
      'name': name,
      'imageUrl': imageUrl,
      'origin': origin,
    };
    await sharedPreferences.setString(_getKey(imageId, type), json.encode(data));
  }

  @override
  Map<String, dynamic>? getFavouriteMetadata(String imageId, PetType type) {
    final jsonString = sharedPreferences.getString(_getKey(imageId, type));
    if (jsonString != null) {
      return json.decode(jsonString);
    }
    return null;
  }

  @override
  Future<void> removeFavouriteMetadata(String imageId, PetType type) async {
    await sharedPreferences.remove(_getKey(imageId, type));
  }
}