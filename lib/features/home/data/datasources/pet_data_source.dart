import '../../../../core/network/dio_client.dart';
import '../../../../core/utils/api_constants.dart';
import '../../../../core/utils/pet_type.dart';
import '../models/pet_model.dart';

abstract class PetDataSource {
  Future<List<PetModel>> getPets({
    required PetType type,
    int limit = 10,
    int page = 0,
  });
}

class PetDataSourceImpl implements PetDataSource {
  final DioClient client;

  PetDataSourceImpl(this.client);

  @override
  Future<List<PetModel>> getPets({
    required PetType type,
    int limit = 10,
    int page = 0,
  }) async {
    final baseUrl = type == PetType.cat
        ? ApiConstants.catBaseUrl
        : ApiConstants.dogBaseUrl;

    final response = await client.get(
      baseUrl,
      '${ApiConstants.breeds}?limit=$limit&page=$page',
    );

    final List data = response.data;
    return data.map((json) => PetModel.fromJson(json, type)).toList();
  }
}