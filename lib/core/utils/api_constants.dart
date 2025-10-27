import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  static const catBaseUrl = 'https://api.thecatapi.com';
  static const dogBaseUrl = 'https://api.thedogapi.com';
  static const breeds = '/v1/breeds';
  static String get catApiKey => dotenv.env['CAT_API_KEY'] ?? '';
  static String get dogApiKey => dotenv.env['DOG_API_KEY'] ?? '';
}


