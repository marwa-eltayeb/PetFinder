import 'dart:math';
import '../../domain/entities/pet.dart';
import '../../domain/repositories/pet_repository.dart';
import '../../../../core/utils/pet_type.dart';
import '../datasources/pet_data_source.dart';

class PetRepositoryImpl implements PetRepository {
  final PetDataSource remoteDataSource;

  PetRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Pet>> getAllPets({int limit = 10, int page = 0}) async {
    // Fetch both pet types in parallel for efficiency
    final results = await Future.wait([
      remoteDataSource.getPets(type: PetType.cat, limit: limit, page: page),
      remoteDataSource.getPets(type: PetType.dog, limit: limit, page: page),
    ]);

    // Merge and shuffle results
    final allPets = results.expand((e) => e).toList()..shuffle(Random());

    return allPets;
  }

  @override
  Future<List<Pet>> searchPets(String query) async {
    final results = await Future.wait([
      remoteDataSource.searchPets(PetType.cat, query),
      remoteDataSource.searchPets(PetType.dog, query),
    ]);
    return results.expand((e) => e).toList();
  }
}
