import '../repositories/favourite_repository.dart';
import '../../../../core/utils/pet_type.dart';

class RemoveFavouriteUseCase {
  final FavouritesRepository repository;

  RemoveFavouriteUseCase(this.repository);

  Future<void> call(PetType type, int id) =>
      repository.removeFavourite(type, id);
}
