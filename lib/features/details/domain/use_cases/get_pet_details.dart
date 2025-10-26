import '../entities/pet_details.dart';
import '../../../../core/utils/pet_type.dart';
import '../repositories/pet_details_repository.dart';

class GetPetDetails {
  final PetDetailsRepository repository;

  GetPetDetails(this.repository);

  Future<PetDetails> call(PetType type, dynamic id) {
    return repository.getPetDetails(type, id);
  }
}
