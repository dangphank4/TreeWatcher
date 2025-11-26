import 'package:flutter/material.dart';
import 'package:flutter_api/core/constants/app_routes.dart';
import 'package:flutter_api/core/constants/app_styles.dart';
import 'package:flutter_api/core/extensions/num_extendsion.dart';
import 'package:flutter_api/core/helpers/navigation_helper.dart';
import 'package:flutter_api/core/utils/globals.dart';
import 'package:flutter_api/core/utils/utils.dart';
import 'package:flutter_api/modules/app/general/app_module_routes.dart';
import 'package:flutter_api/modules/auth/general/auth_module_routes.dart';
import 'package:flutter_api/modules/auth/presentation/blocs/auth_bloc.dart';
import 'package:flutter_api/modules/auth/presentation/blocs/auth_event.dart';
import 'package:flutter_api/modules/auth/presentation/blocs/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;
  final _authBloc = Modular.get<AuthBloc>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      bloc: _authBloc,
      listener: (context, state) {
        if (state is AuthLoading) {
        } else if (state is AuthAuthenticated) {
          Utils.debugLog('Login success: ${state.data}');
          Utils.debugLog('Global: ${Globals.globalAccessToken}');
          Utils.debugLog('Global: ${Globals.globalUserId}');
          NavigationHelper.replace(
            '${AppRoutes.moduleApp}${AppModuleRoutes.main}',
          );
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('LogIn', style: Styles.h1.smb.copyWith(color: Colors.white)),
              SizedBox(height: 20),
              // Email
              TextField(
                controller: _emailController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Email',

                  labelStyle: const TextStyle(color: Colors.white70),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.white24),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Mật khẩu
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Mật khẩu',
                  labelStyle: const TextStyle(color: Colors.white70),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.white24),
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.white70,
                    ),
                  ),
                ),
              ),
              10.verticalSpace,
              Container(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    NavigationHelper.replace('${AppRoutes.moduleAuth}${AuthModuleRoutes.forgotPassword}');
                  },
                  child: Text(
                    'Fogot Password?',
                    style: Styles.sfNormal.regular.copyWith(
                      color: Colors.lightBlueAccent,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.lightBlueAccent,
                    ),
                  ),
                ),
              ),
              24.verticalSpace,

              // BUTTON LOGIN
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    final email = _emailController.text;
                    final password = _passwordController.text;

                    if (email.isEmpty || password.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Vui lòng nhập đủ thông tin'),
                        ),
                      );
                      return;
                    }

                    // Giả lập loading
                    await Future.delayed(const Duration(milliseconds: 500));

                    // NavigationHelper.replace(
                    //   '${AppRoutes.moduleApp}${AppModuleRoutes.main}',
                    // );
                    Utils.debugLog('Login successed}');
                    _authBloc.add(
                      AuthLoginRequested(email: email, password: password),
                    );
                  },
                  child: const Text(
                    'Đăng nhập',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              12.verticalSpace,
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    NavigationHelper.replace(
                      '${AppRoutes.moduleAuth}${AuthModuleRoutes.register}',
                    );
                  },
                  child: Text('Create an account?'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
