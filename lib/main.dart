import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_api/main_module.dart';
import 'package:flutter_api/main_widget.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/constants/app_evironment.dart';
import 'core/constants/app_store.dart';
import 'core/helpers/generalHeper.dart';
import 'core/utils/globals.dart';
import 'core/utils/utils.dart';
import 'firebase_options.dart';
import 'modules/device/presentation/page/add_device_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.delayed(const Duration(milliseconds: 150));
  await dotenv.load(fileName: AppEnvironment.envFileName);

  // SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();

  // LOAD LẠI SESSION
  Globals.globalAccessToken =
      sharedPreferences.getString(AppStores.kAccessToken);
  Globals.globalUserUUID =
      sharedPreferences.getString(AppStores.kUserId);
  Globals.globalUsername =
      sharedPreferences.getString(AppStores.kUsername);

  Utils.debugLog('USER ID AFTER RESTART = ${Globals.globalUserUUID}');

  // HydratedBloc
  final dir = await getApplicationDocumentsDirectory();
  final storage = await HydratedStorage.build(
    storageDirectory: HydratedStorageDirectory(dir.path),
  );
  HydratedBloc.storage = storage;

  // Khởi tạo Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Khởi tạo các helper
  await GeneralHelper.init();

  runApp(
    ModularApp(
      module: MainModule(sharedPreferences: sharedPreferences),
      child: const MainWidget(),
    ),
  );
}
