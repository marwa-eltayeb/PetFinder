import '../../domain/entities/pet.dart';

class PetFilterUtils {

  static List<String> extractOrigins(List<Pet> pets, {int limit = 10}) {
    return _countAndSort(
      pets.map((p) => p.origin).whereType<String>(),
      limit: limit,
    );
  }

  static List<String> extractTemperaments(List<Pet> pets, {int limit = 10}) {
    return _countAndSort(
      pets.expand((p) => p.temperament?.split(',') ?? []),
      limit: limit,
    );
  }

  static List<String> _countAndSort(Iterable<String> values, {required int limit}) {
    final counts = <String, int>{};

    for (var value in values) {
      final trimmed = value.trim();
      if (trimmed.isNotEmpty) {
        counts[trimmed] = (counts[trimmed] ?? 0) + 1;
      }
    }

    return (counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value)))
        .take(limit)
        .map((e) => e.key)
        .toList();
  }
}