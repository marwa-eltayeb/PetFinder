// In-memory fake remote data sources used by the integration tests
import 'package:petfinder/core/utils/pet_type.dart';
import 'package:petfinder/features/home/data/datasources/pet_remote_data_source.dart';
import 'package:petfinder/features/home/data/models/pet_model.dart';
import 'package:petfinder/features/details/data/datasources/pet_details_remote_data_source.dart';
import 'package:petfinder/features/details/data/models/pet_details_model.dart';
import 'package:petfinder/features/favourites/data/datsources/favourites_remote_data_source.dart';
import 'package:petfinder/features/favourites/data/models/favourite_model.dart';

// Fake pet list source. Returns a fixed set of cats and dogs.
class FakePetRemoteDataSource implements PetRemoteDataSource {
  PetModel _cat(String id, String name) => PetModel(
        id: id,
        name: name,
        typeIndex: PetType.cat.index,
        imageUrl: '',
        origin: 'Testland',
        temperament: 'Calm',
        imageId: 'img_$id',
      );

  PetModel _dog(String id, String name) => PetModel(
        id: id,
        name: name,
        typeIndex: PetType.dog.index,
        imageUrl: '',
        origin: 'Testland',
        temperament: 'Loyal',
        imageId: 'img_$id',
      );

  @override
  Future<List<PetModel>> getPets({
    required PetType type,
    int limit = 10,
    int page = 0,
  }) async {
    // Only return data for the first page so hasMoreData becomes false
    // (avoids the infinite-scroll loading spinner).
    if (page > 0) return [];

    if (type == PetType.cat) {
      return [_cat('c1', 'Persian'), _cat('c2', 'Siamese')];
    } else if (type == PetType.dog) {
      return [_dog('d1', 'Labrador'), _dog('d2', 'Beagle')];
    }
    return [];
  }

  @override
  Future<List<PetModel>> searchPets(PetType type, String query) async {
    // Return one matching result per type so search always has data.
    if (type == PetType.cat) {
      return [_cat('cs1', 'Search Cat')];
    } else if (type == PetType.dog) {
      return [_dog('ds1', 'Search Dog')];
    }
    return [];
  }
}

// Fake details source. Always returns valid details with a description.
class FakePetDetailsRemoteDataSource implements PetDetailsRemoteDataSource {
  @override
  Future<PetDetailsModel> getPetDetails(PetType type, dynamic id) async {
    return PetDetailsModel(
      id: id.toString(),
      name: 'Test Pet',
      typeIndex: type.index,
      origin: 'Testland',
      temperament: 'Friendly',
      description: 'A lovely test companion.',
      imageUrl: '',
      weight: '5',
      lifeSpan: '12',
      imageId: 'img_$id',
    );
  }
}

// Fake favourites source. Stores favourites in memory only.
class FakeFavouritesRemoteDataSource implements FavouritesRemoteDataSource {
  final List<FavouriteModel> _store = [];
  int _nextId = 1;

  @override
  Future<List<FavouriteModel>> getFavourites(PetType type) async {
    return _store.where((f) => f.type == type).toList();
  }

  @override
  Future<FavouriteModel> addFavourite(
      PetType type, String imageId, String subId) async {
    final model = FavouriteModel(
      id: _nextId++,
      imageId: imageId,
      subId: subId,
      type: type,
    );
    _store.add(model);
    return model;
  }

  @override
  Future<void> removeFavourite(PetType type, int favouriteId) async {
    _store.removeWhere((f) => f.id == favouriteId && f.type == type);
  }
}
