import 'package:petfinder/core/network/dio_client.dart';
import 'package:petfinder/core/network/network_config.dart';
import 'package:petfinder/core/utils/api_constants.dart';
import 'package:petfinder/core/utils/pet_type.dart';
import 'package:petfinder/features/home/data/models/pet_model.dart';

abstract class PetRemoteDataSource {
  Future<List<PetModel>> getPets({required PetType type, int limit = 10, int page = 0,});
  Future<List<PetModel>> searchPets(PetType type, String query);
}

class PetRemoteDataSourceImpl implements PetRemoteDataSource {
  final DioClient client;

  PetRemoteDataSourceImpl(this.client);

  @override
  Future<List<PetModel>> getPets({required PetType type, int limit = 10, int page = 0,}) async {
    final response = await client.get(
      NetworkConfig.getBaseUrl(type),
      ApiConstants.breeds,
      queryParams: {'limit': limit, 'page': page},
      headers: {'x-api-key': NetworkConfig.getApiKey(type)},
    );
    final List data = response.data;
    return data.map((json) => PetModel.fromJson(json, type)).toList();
  }

  @override
  Future<List<PetModel>> searchPets(PetType type, String query) async {
    final response = await client.get(
      NetworkConfig.getBaseUrl(type),
      '${ApiConstants.breeds}/search',
      queryParams: {'q': query, 'attach_image': 1},
      headers: {'x-api-key': NetworkConfig.getApiKey(type)},
    );
    final List data = response.data;
    return data.map((json) => PetModel.fromJson(json, type)).toList();
  }
}