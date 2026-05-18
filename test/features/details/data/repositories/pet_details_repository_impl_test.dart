import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:petfinder/core/utils/pet_type.dart';
import 'package:petfinder/features/details/data/datasources/pet_details_remote_data_source.dart';
import 'package:petfinder/features/details/data/datasources/pet_details_local_data_source.dart';
import 'package:petfinder/features/details/data/models/pet_details_model.dart';
import 'package:petfinder/features/details/data/repositories/pet_details_repository_impl.dart';
import 'pet_details_repository_impl_test.mocks.dart';

@GenerateMocks([PetDetailsRemoteDataSource, PetDetailsLocalDataSource])
void main() {
  late PetDetailsRepositoryImpl repository;
  late MockPetDetailsDataSource mockRemoteDataSource;
  late MockPetDetailsLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockPetDetailsDataSource();
    mockLocalDataSource = MockPetDetailsLocalDataSource();
    repository = PetDetailsRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  group('getPetDetails', () {
    final tPetType = PetType.cat;
    final tId = '123';
    final tPetDetailsModel = PetDetailsModel(
      id: '123',
      name: 'Persian',
      typeIndex: PetType.cat.index,
      origin: 'Iran',
      temperament: 'Calm, Friendly',
      description: 'A beautiful long-haired cat breed',
      imageUrl: 'https://cdn2.thecatapi.com/images/test.jpg',
      weight: '3-5',
      lifeSpan: '12-17',
    );
    final tPetDetails = tPetDetailsModel.toEntity();

    test('should return cached data when cache is available', () async {
      // Arrange
      when(mockLocalDataSource.getCachedPetDetails(
        type: tPetType,
        id: tId,
      )).thenAnswer((_) async => tPetDetailsModel);

      // Act
      final result = await repository.getPetDetails(tPetType, tId);

      // Assert
      expect(result.id, equals(tPetDetails.id));
      expect(result.name, equals(tPetDetails.name));
      expect(result.type, equals(tPetDetails.type));
      verify(mockLocalDataSource.getCachedPetDetails(
        type: tPetType,
        id: tId,
      ));
      verifyZeroInteractions(mockRemoteDataSource);
    });

    test('should fetch from remote and cache when no cache is available', () async {
      // Arrange
      when(mockLocalDataSource.getCachedPetDetails(
        type: tPetType,
        id: tId,
      )).thenAnswer((_) async => null);

      when(mockRemoteDataSource.getPetDetails(tPetType, tId))
          .thenAnswer((_) async => tPetDetailsModel);

      when(mockLocalDataSource.cachePetDetails(petDetails: tPetDetailsModel))
          .thenAnswer((_) async => Future.value());

      // Act
      final result = await repository.getPetDetails(tPetType, tId);

      // Assert
      expect(result.id, equals(tPetDetails.id));
      expect(result.name, equals(tPetDetails.name));
      expect(result.type, equals(tPetDetails.type));
      verify(mockLocalDataSource.getCachedPetDetails(
        type: tPetType,
        id: tId,
      ));
      verify(mockRemoteDataSource.getPetDetails(tPetType, tId));
      verify(mockLocalDataSource.cachePetDetails(petDetails: tPetDetailsModel));
    });

    test('should throw exception when remote call fails', () async {
      // Arrange
      when(mockLocalDataSource.getCachedPetDetails(
        type: tPetType,
        id: tId,
      )).thenAnswer((_) async => null);

      when(mockRemoteDataSource.getPetDetails(tPetType, tId))
          .thenThrow(Exception('Network error'));

      // Act & Assert
      expect(
            () => repository.getPetDetails(tPetType, tId),
        throwsA(isA<Exception>()),
      );
    });
  });
}