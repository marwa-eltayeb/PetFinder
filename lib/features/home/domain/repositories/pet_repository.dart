import '../entities/pet.dart';

abstract class PetRepository {
  Future<List<Pet>> getAllPets({int limit = 10, int page = 0});
  Future<List<Pet>> searchPets(String query);
}
