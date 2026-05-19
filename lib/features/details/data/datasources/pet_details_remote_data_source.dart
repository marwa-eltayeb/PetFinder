import 'package:petfinder/core/network/dio_client.dart';
import 'package:petfinder/core/network/network_config.dart';
import 'package:petfinder/core/utils/api_constants.dart';
import 'package:petfinder/core/utils/pet_type.dart';
import 'package:petfinder/features/details/data/models/pet_details_model.dart';

abstract class PetDetailsRemoteDataSource {
  Future<PetDetailsModel> getPetDetails(PetType type, dynamic id);
}

class PetDetailsRemoteDataSourceImpl implements PetDetailsRemoteDataSource {
  final DioClient client;
  PetDetailsRemoteDataSourceImpl(this.client);

  @override
  Future<PetDetailsModel> getPetDetails(PetType type, dynamic id) async {
    final response = await client.get(
      NetworkConfig.getBaseUrl(type),
      '${ApiConstants.breeds}/$id',
      headers: {'x-api-key': NetworkConfig.getApiKey(type)},
    );
    return PetDetailsModel.fromJson(type, response.data);
  }
}
