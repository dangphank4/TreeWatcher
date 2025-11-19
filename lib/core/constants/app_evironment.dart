import 'package:flutter_api/core/helpers/generalHeper.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'app_configs.dart';

class AppEnvironment {
  AppEnvironment._();

  static String get envFileName =>
      AppConfigs.flavorDev == GeneralHelper.appFlavor
          ? '.env.development'
          : '.env.production';

  static String get baseUrl => dotenv.env['BASE_URL'] ?? '';
  static String get websocketUrl => dotenv.env['WEBSOCKET_URL'] ?? '';
  static String get firebaseWebClientId =>
      dotenv.env['FIREBASE_WEB_CLIENT_ID'] ?? '';

}
