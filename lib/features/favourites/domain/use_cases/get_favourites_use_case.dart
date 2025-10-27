import '../entities/favourite_entity.dart';
import '../repositories/favourite_repository.dart';
import '../../../../core/utils/pet_type.dart';

class GetFavouritesUseCase {
  final FavouritesRepository repository;

  GetFavouritesUseCase(this.repository);

  Future<List<FavouriteEntity>> call(PetType type) =>
      repository.getFavourites(type);
}
