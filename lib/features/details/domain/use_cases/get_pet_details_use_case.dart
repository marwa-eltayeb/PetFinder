import 'package:petfinder/core/utils/pet_type.dart';
import 'package:petfinder/features/details/domain/entities/pet_details.dart';
import 'package:petfinder/features/details/domain/repositories/pet_details_repository.dart';

class GetPetDetailsUseCase {
  final PetDetailsRepository repository;

  GetPetDetailsUseCase(this.repository);

  Future<PetDetails> call(PetType type, dynamic id) {
    return repository.getPetDetails(type, id);
  }
}
