
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_api/core/constants/app_routes.dart';
import 'package:flutter_api/core/constants/app_styles.dart';
import 'package:flutter_api/core/helpers/navigation_helper.dart';

import '../../../app/general/app_module_routes.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // final accessToken = sharedPreferenceHelper.get(key: AppStores.kAccessToken);

    // if (accessToken != null) {
    //   NavigationHelper.replace('${AppRoutes.moduleApp}${AppModuleRoutes.main}');
    // }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text('Đăng nhập', style: Styles.h3.smb)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Tên đăng nhập',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final username = _usernameController.text;
                  if (username.isNotEmpty) {
                  }
                  await Future.delayed(Duration(milliseconds: 500));
                  NavigationHelper.replace(
                    '${AppRoutes.moduleApp}${AppModuleRoutes.main}',
                  );
                },
                child: const Text('Đăng nhập'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
