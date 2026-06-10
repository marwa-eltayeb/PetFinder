import 'package:petfinder/core/utils/api_constants.dart';
import 'package:petfinder/core/utils/pet_type.dart';

class NetworkConfig {
  static String getBaseUrl(PetType type) {
    return type == PetType.cat ? ApiConstants.catBaseUrl : ApiConstants.dogBaseUrl;
  }

  static String getApiKey(PetType type) {
    return type == PetType.cat ? ApiConstants.catApiKey : ApiConstants.dogApiKey;
  }

  static String? buildImageUrl(String? imageId) {
    if (imageId == null) return null;
    return 'https://cdn2.thecatapi.com/images/$imageId.jpg';
  }
}
