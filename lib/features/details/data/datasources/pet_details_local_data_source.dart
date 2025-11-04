import 'package:hive_flutter/hive_flutter.dart';
import '../models/pet_details_model.dart';
import '../../../../core/utils/pet_type.dart';

abstract class PetDetailsLocalDataSource {
  Future<PetDetailsModel?> getCachedPetDetails({required PetType type, required String id,});
  Future<void> cachePetDetails({required PetDetailsModel petDetails,});
  Future<void> clearCache();
  Future<bool> hasCachedData({required PetType type, required String id,});
}

class PetDetailsLocalDataSourceImpl implements PetDetailsLocalDataSource {

  static const String _boxName = 'pet_details_cache';

  late Box<PetDetailsModel> _box;

  PetDetailsLocalDataSourceImpl() {
    _box = Hive.box<PetDetailsModel>(_boxName);
  }

  String _getCacheKey(PetType type, String id) {
    return '${type.name}_$id';
  }

  @override
  Future<PetDetailsModel?> getCachedPetDetails({
    required PetType type,
    required String id,
  }) async {
    try {
      final key = _getCacheKey(type, id);
      return _box.get(key);
    } catch (e) {
      print('Error getting cached pet details: $e');
      return null;
    }
  }

  @override
  Future<void> cachePetDetails({required PetDetailsModel petDetails,}) async {
    try {
      final key = _getCacheKey(petDetails.type, petDetails.id);
      await _box.put(key, petDetails);
    } catch (e) {
      print('Error caching pet details: $e');
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
  Future<bool> hasCachedData({required PetType type, required String id,}) async {
    try {
      final key = _getCacheKey(type, id);
      return _box.containsKey(key);
    } catch (e) {
      return false;
    }
  }

  static Future<void> init() async {
    await Hive.openBox<PetDetailsModel>(_boxName);
  }
}