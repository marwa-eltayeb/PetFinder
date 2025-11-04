import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';
import 'package:petfinder/core/network/dio_client.dart';
import 'package:petfinder/core/utils/api_constants.dart';
import 'package:petfinder/core/utils/pet_type.dart';
import 'package:petfinder/features/details/data/datasources/pet_details_data_source.dart';
import 'package:petfinder/features/details/data/models/pet_details_model.dart';

import 'pet_details_data_source_test.mocks.dart';

@GenerateMocks([DioClient])
void main() {
  late PetDetailsDataSourceImpl dataSource;
  late MockDioClient mockDioClient;

  setUp(() {
    mockDioClient = MockDioClient();
    dataSource = PetDetailsDataSourceImpl(mockDioClient);
  });

  group('getPetDetails', () {
    final tPetType = PetType.cat;
    final tId = '123';
    final tResponseData = {
      'id': '123',
      'name': 'Persian',
      'origin': 'Iran',
      'temperament': 'Calm, Friendly',
      'description': 'A beautiful long-haired cat breed',
      'reference_image_id': 'test',
      'weight': {
        'metric': '3-5',
      },
      'life_span': '12-17 years',
    };

    test('should return PetDetailsModel when the call is successful', () async {
      // Arrange
      when(mockDioClient.get(
        ApiConstants.catBaseUrl,
        '${ApiConstants.breeds}/$tId',
      )).thenAnswer((_) async => Response(
        data: tResponseData,
        statusCode: 200,
        requestOptions: RequestOptions(path: ''),
      ));

      // Act
      final result = await dataSource.getPetDetails(tPetType, tId);

      // Assert
      expect(result, isA<PetDetailsModel>());
      verify(mockDioClient.get(
        ApiConstants.catBaseUrl,
        '${ApiConstants.breeds}/$tId',
      ));
      verifyNoMoreInteractions(mockDioClient);
    });

    test('should throw an exception when the call fails', () async {
      // Arrange
      when(mockDioClient.get(
        ApiConstants.catBaseUrl,
        '${ApiConstants.breeds}/$tId',
      )).thenThrow(DioException(
        requestOptions: RequestOptions(path: ''),
        response: Response(
          statusCode: 404,
          requestOptions: RequestOptions(path: ''),
        ),
      ));

      // Act & Assert
      expect(
            () => dataSource.getPetDetails(tPetType, tId),
        throwsA(isA<DioException>()),
      );
    });

    test('should use correct base URL for dog type', () async {
      // Arrange
      final tDogType = PetType.dog;
      when(mockDioClient.get(
        ApiConstants.dogBaseUrl,
        '${ApiConstants.breeds}/$tId',
      )).thenAnswer((_) async => Response(
        data: tResponseData,
        statusCode: 200,
        requestOptions: RequestOptions(path: ''),
      ));

      // Act
      await dataSource.getPetDetails(tDogType, tId);

      // Assert
      verify(mockDioClient.get(
        ApiConstants.dogBaseUrl,
        '${ApiConstants.breeds}/$tId',
      ));
    });
  });
}