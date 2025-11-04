import 'package:hive_flutter/hive_flutter.dart';
import '../models/pet_model.dart';
import '../../../../core/utils/pet_type.dart';

abstract class PetLocalDataSource {
  Future<List<PetModel>> getCachedPets({required PetType type, required int page});
  Future<void> cachePets({required List<PetModel> pets, required PetType type, required int page});
  Future<void> clearCache();
  Future<bool> hasCachedData({required PetType type, required int page});
}

class PetLocalDataSourceImpl implements PetLocalDataSource {

  static const String _boxName = 'pets_cache';

  late Box _box;

  PetLocalDataSourceImpl() {
    _box = Hive.box(_boxName);
  }

  String _getCacheKey(PetType type, int page) {
    return '${type.name}_page_$page';
  }

  @override
  Future<List<PetModel>> getCachedPets({required PetType type, required int page}) async {
    try {
      final key = _getCacheKey(type, page);
      final cachedData = _box.get(key);

      if (cachedData == null) {
        return [];
      }

      return (cachedData as List)
          .map((item) => item as PetModel)
          .toList();
    } catch (e) {
      print('Error getting cached pets: $e');
      return [];
    }
  }

  @override
  Future<void> cachePets({required List<PetModel> pets, required PetType type, required int page}) async {
    try {
      final key = _getCacheKey(type, page);
      await _box.put(key, pets);
    } catch (e) {
      print('Error caching pets: $e');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await _box.clear();
    } catch (e) {
      print('Error clearing cache: $e');
    }
  }

  @override
  Future<bool> hasCachedData({required PetType type, required int page}) async {
    try {
      final key = _getCacheKey(type, page);
      return _box.containsKey(key);
    } catch (e) {
      return false;
    }
  }

  static Future<void> init() async {
    await Hive.openBox(_boxName);
  }
}