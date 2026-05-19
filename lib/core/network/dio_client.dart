import 'package:dio/dio.dart';

class DioClient {
  final Dio dio;

  DioClient(this.dio);

  Future<Response> get(
    String baseUrl,
    String endpoint, {
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? headers,
  }) async {
    final response = await dio.get(
      '$baseUrl$endpoint',
      queryParameters: queryParams,
      options: Options(headers: headers),
    );
    return response;
  }
}
