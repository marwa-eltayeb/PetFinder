import '../entities/pet_details.dart';
import '../../../../core/utils/pet_type.dart';

abstract class PetDetailsRepository {
  Future<PetDetails> getPetDetails(PetType type, dynamic id);
}
