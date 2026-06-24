import '../entities/pet.dart';
import '../repositories/pet_repository.dart';

class SearchPetsUseCase {
  final PetRepository repository;

  SearchPetsUseCase(this.repository);

  Future<List<PetEntity>> call(String query) {
    return repository.searchPets(query);
  }
}
