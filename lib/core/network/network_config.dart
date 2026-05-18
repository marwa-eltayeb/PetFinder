import 'package:petfinder/core/utils/api_constants.dart';
import 'package:petfinder/core/utils/pet_type.dart';

class NetworkConfig {
  static String getBaseUrl(PetType type) {
    return type == PetType.cat ? ApiConstants.catBaseUrl : ApiConstants.dogBaseUrl;
  }

  static String getApiKey(PetType type) {
    return type == PetType.cat ? ApiConstants.catApiKey : ApiConstants.dogApiKey;
  }
}
