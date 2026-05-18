import 'package:petfinder/core/utils/pet_type.dart';
import 'package:petfinder/features/details/domain/entities/pet_details.dart';

abstract class PetDetailsRepository {
  Future<PetDetails> getPetDetails(PetType type, dynamic id);
}
