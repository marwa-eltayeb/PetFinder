import 'dart:math';
import '../../domain/entities/pet.dart';
import '../../domain/repositories/pet_repository.dart';
import '../../../../core/utils/pet_type.dart';
import '../datasources/pet_data_source.dart';
import '../datasources/pet_local_data_source.dart';

class PetRepositoryImpl implements PetRepository {
  final PetDataSource remoteDataSource;
  final PetLocalDataSource localDataSource;

  PetRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<Pet>> getAllPets({int limit = 10, int page = 0}) async {
      // Get cached data first for both types
      final cachedCats = await localDataSource.getCachedPets(
        type: PetType.cat,
        page: page,
      );
      final cachedDogs = await localDataSource.getCachedPets(
        type: PetType.dog,
        page: page,
      );

      // If cache exists for both types, return cached data immediately
      if (cachedCats.isNotEmpty && cachedDogs.isNotEmpty) {
        final allPets = [
          ...cachedCats.map((model) => model.toEntity()),
          ...cachedDogs.map((model) => model.toEntity()),
        ];
        // Shuffle with consistent seed for same results on same page
        final random = Random(page);
        allPets.shuffle(random);
        return allPets;
      }

      // If no complete cache, fetch fresh data from API
      final results = await Future.wait([
        remoteDataSource.getPets(type: PetType.cat, limit: limit, page: page),
        remoteDataSource.getPets(type: PetType.dog, limit: limit, page: page),
      ]);

      final cats = results[0];
      final dogs = results[1];

      // Cache the freshly fetched data for future use
      await Future.wait([
        localDataSource.cachePets(pets: cats, type: PetType.cat, page: page),
        localDataSource.cachePets(pets: dogs, type: PetType.dog, page: page),
      ]);

      // Combine and convert models to entities
      final allPets = [...cats, ...dogs].map((model) => model.toEntity()).toList();

      // Shuffle with consistent seed for same results on same page
      final random = Random(page);
      allPets.shuffle(random);

      return allPets;
  }

  @override
  Future<List<Pet>> searchPets(String query) async {
    final results = await Future.wait([
      remoteDataSource.searchPets(PetType.cat, query),
      remoteDataSource.searchPets(PetType.dog, query),
    ]);
    return results.expand((models) => models).map((model) => model.toEntity()).toList();
  }
}
