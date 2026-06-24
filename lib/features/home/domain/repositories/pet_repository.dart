import '../entities/pet.dart';

abstract class PetRepository {
  Future<List<PetEntity>> getAllPets({int limit = 10, int page = 0});
  Future<List<PetEntity>> searchPets(String query);
}
