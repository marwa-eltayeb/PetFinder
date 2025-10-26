import '../repositories/pet_repository.dart';
import '../entities/pet.dart';

class GetAllPets {
  final PetRepository repository;

  GetAllPets(this.repository);

  Future<List<Pet>> call({int limit = 10, int page = 0}) {
    return repository.getAllPets(limit: limit, page: page);
  }
}
