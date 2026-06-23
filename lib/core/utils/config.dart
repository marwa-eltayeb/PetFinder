class Config {
  static const String environment = String.fromEnvironment('ENV', defaultValue: 'development');

  static bool get isProd => environment == 'production';
  static bool get isDev => environment == 'development';
}
