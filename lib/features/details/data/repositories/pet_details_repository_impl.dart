import '../../../../core/utils/pet_type.dart';
import '../../domain/entities/pet_details.dart';
import '../../domain/repositories/pet_details_repository.dart';
import '../datasources/pet_details_data_source.dart';

class PetDetailsRepositoryImpl implements PetDetailsRepository {
  final PetDetailsDataSource remoteDataSource;

  PetDetailsRepositoryImpl(this.remoteDataSource);

  @override
  Future<PetDetails> getPetDetails(PetType type, dynamic id) async {
    return await remoteDataSource.getPetDetails(type, id);
  }
}
