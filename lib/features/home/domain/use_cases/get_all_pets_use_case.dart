import '../repositories/pet_repository.dart';
import '../entities/pet.dart';

class GetAllPetsUseCase {
  final PetRepository repository;

  GetAllPetsUseCase(this.repository);

  Future<List<Pet>> call({int limit = 10, int page = 0}) {
    return repository.getAllPets(limit: limit, page: page);
  }
}
