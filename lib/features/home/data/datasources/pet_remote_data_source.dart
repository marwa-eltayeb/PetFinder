import 'package:flutter/cupertino.dart';

import '../../../../core/network/dio_client.dart';
import '../../../../core/network/network_config.dart';
import '../../../../core/utils/api_constants.dart';
import '../../../../core/utils/pet_type.dart';
import '../models/pet_model.dart';

abstract class PetRemoteDataSource {
  Future<List<PetModel>> getPets({required PetType type, int limit = 10, int page = 0,});
  Future<List<PetModel>> searchPets(PetType type, String query);
}

class PetRemoteDataSourceImpl implements PetRemoteDataSource {
  final DioClient client;

  PetRemoteDataSourceImpl(this.client);

  @override
  Future<List<PetModel>> getPets({required PetType type, int limit = 10, int page = 0,}) async {

    debugPrint('API Key: ${NetworkConfig.getApiKey(type)}');
    debugPrint('URL: ${NetworkConfig.getBaseUrl(type)}${ApiConstants.breeds}?limit=$limit&page=$page&api_key=${NetworkConfig.getApiKey(type)}');

    final response = await client.get(
      NetworkConfig.getBaseUrl(type),
      '${ApiConstants.breeds}?limit=$limit&page=$page&api_key=${NetworkConfig.getApiKey(type)}',
    );

    final List data = response.data;
    return data.map((json) => PetModel.fromJson(json, type)).toList();
  }

  @override
  Future<List<PetModel>> searchPets(PetType type, String query) async {
    final response = await client.get(
      NetworkConfig.getBaseUrl(type),
      '${ApiConstants.breeds}/search?q=$query&attach_image=1&api_key=${NetworkConfig.getApiKey(type)}',
    );
    final List data = response.data;
    return data.map((json) => PetModel.fromJson(json, type)).toList();
  }
}