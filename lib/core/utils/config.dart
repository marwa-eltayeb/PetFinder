class Config {
  static late String environment;

  static bool get isProd => environment == 'production';
  static bool get isDev => environment == 'development';
}
