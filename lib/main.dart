import 'package:flutter/material.dart';
import 'package:flutter_api/main_module.dart';
import 'package:flutter_api/main_widget.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/constants/app_evironment.dart';
import 'core/helpers/generalHeper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // FIX ⚡ Đợi native channel khởi tạo 150ms
  await Future.delayed(const Duration(milliseconds: 150));

  // ENV
  await dotenv.load(fileName: AppEnvironment.envFileName);

  // SharedPref
  final sharedPreferences = await SharedPreferences.getInstance();

  // Hydrated Storage
  final dir = await getApplicationDocumentsDirectory();
  final storage = await HydratedStorage.build(
    storageDirectory: HydratedStorageDirectory(dir.path),
  );
  HydratedBloc.storage = storage;

  await GeneralHelper.init();

  runApp(
    ModularApp(
      module: MainModule(sharedPreferences: sharedPreferences),
      child: const MainWidget(),
    ),
  );
}
