import 'package:petfinder/core/utils/pet_type.dart';
import 'package:petfinder/features/details/data/datasources/pet_details_local_data_source.dart';
import 'package:petfinder/features/details/data/datasources/pet_details_remote_data_source.dart';
import 'package:petfinder/features/details/domain/entities/pet_details.dart';
import 'package:petfinder/features/details/domain/repositories/pet_details_repository.dart';

class PetDetailsRepositoryImpl implements PetDetailsRepository {
  final PetDetailsRemoteDataSource remoteDataSource;
  final PetDetailsLocalDataSource localDataSource;

  PetDetailsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<PetDetails> getPetDetails(PetType type, dynamic id) async {

    // Get from cache first
    final cached = await localDataSource.getCachedPetDetails(type: type, id: id.toString(),);

    // Convert model to entity if cached
    if (cached != null) {return  cached.toEntity();}

    // If no cache, fetch from API
    final petDetails = await remoteDataSource.getPetDetails(type, id);

    // Cache the fetched data
    await localDataSource.cachePetDetails(petDetails: petDetails);

    return petDetails.toEntity();
  }

}
