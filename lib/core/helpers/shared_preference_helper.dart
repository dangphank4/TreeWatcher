import 'package:flutter_api/core/constants/app_store.dart';
import 'package:flutter_api/core/utils/globals.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper {
  final SharedPreferences sharedPreferences;
  SharedPreferenceHelper({required this.sharedPreferences}) {
    String? token = get(key: AppStores.kAccessToken)?.toString();

    if (token != null) {
      Globals.globalAccessToken = token;
    }

    String? userId = get(key: AppStores.kUserId)?.toString();

    if (userId != null) {
      Globals.globalUserId = userId;
    }

    String? userUUID = get(key: AppStores.kUserUUID)?.toString();

    if (userUUID != null) {
      Globals.globalUserUUID = userUUID;
    }

    String? username = get(key: AppStores.kUsername)?.toString();

    if (username != null) {
      Globals.globalUsername = username;
    }
  }

  Future<void> set({required String key, required String value}) async {
    await sharedPreferences.setString(key, value);
  }

  Future<void> remove({required String key}) async {
    await sharedPreferences.remove(key);
  }

  Object? get({required String key}) {
    return sharedPreferences.get(key);
  }
}