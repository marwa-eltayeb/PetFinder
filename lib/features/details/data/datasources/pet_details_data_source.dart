import '../../../../core/network/dio_client.dart';
import '../../../../core/utils/api_constants.dart';
import '../../../../core/utils/pet_type.dart';
import '../models/pet_details_model.dart';

abstract class PetDetailsDataSource {
  Future<PetDetailsModel> getPetDetails(PetType type, dynamic id);
}

class PetDetailsDataSourceImpl implements PetDetailsDataSource {
  final DioClient client;
  PetDetailsDataSourceImpl(this.client);

  @override
  Future<PetDetailsModel> getPetDetails(PetType type, dynamic id) async {
    late final String baseUrl;

    switch (type) {
      case PetType.cat:
        baseUrl = ApiConstants.catBaseUrl;
        break;
      case PetType.dog:
        baseUrl = ApiConstants.dogBaseUrl;
        break;
      }

    final response = await client.get(baseUrl, '${ApiConstants.breeds}/$id');
    return PetDetailsModel.fromJson(type, response.data);
  }
}
