import 'package:flutter/material.dart';
import 'package:flutter_api/core/constants/app_routes.dart';
import 'package:flutter_api/core/constants/app_styles.dart';
import 'package:flutter_api/core/extensions/localized_extendsion.dart';
import 'package:flutter_api/core/extensions/num_extendsion.dart';
import 'package:flutter_api/core/helpers/navigation_helper.dart';
import 'package:flutter_api/core/utils/utils.dart';
import 'package:flutter_api/modules/auth/general/auth_module_routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../../app/general/app_module_routes.dart';
import '../blocs/auth_bloc.dart';
import '../blocs/auth_event.dart';
import '../blocs/auth_state.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscurerConfirmPassword = true;
  final _authBloc = Modular.get<AuthBloc>();
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      bloc: _authBloc,
      listener: (context, state) {
        if (state is AuthLoading) {
          // Có thể show loading indicator
        } else if (state is AuthAuthenticated) {
          Utils.debugLog('Register success: ${state.data}');
          // Chuyển sang màn hình chính
          NavigationHelper.replace(
            '${AppRoutes.moduleApp}${AppModuleRoutes.main}',
          );
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                context.localization.register,
                style: Styles.h1.smb.copyWith(
                    color: Colors.white
                ),
              ),
              SizedBox(height: 20),
              // Email
              TextField(
                controller: _emailController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: context.localization.email,

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
                  labelText: context.localization.password,
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
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      color: Colors.white70,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _passwordConfirmController,
                obscureText: _obscurerConfirmPassword,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: context.localization.confirmPassword,
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
                        _obscurerConfirmPassword = !_obscurerConfirmPassword;
                      });
                    },
                    icon: Icon(
                      _obscurerConfirmPassword ? Icons.visibility_off : Icons.visibility,
                      color: Colors.white70,
                    ),
                  ),
                ),
              ),
              // BUTTON LOGIN
              const SizedBox(height: 24),
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
                    if(_passwordConfirmController.text != _passwordController.text){
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(context.localization.pleaseEnterRightPassword)),
                      );
                      return;
                    }
                    final password =  _passwordController.text;

                    if (email.isEmpty || password == '') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(context.localization.pleaseEnterCompleteInformation)),
                      );
                      return;
                    }

                    // Giả lập loading
                    await Future.delayed(const Duration(milliseconds: 500));

                    // NavigationHelper.replace(
                    //   '${AppRoutes.moduleApp}${AppModuleRoutes.main}',
                    // );
                    Utils.debugLog('Regisiter successed');
                    _authBloc.add(
                      AuthRegisterRequested(
                        email: email,
                        password: password,
                      ),
                    );

                  },
                  child: Text(
                    context.localization.register,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              12.verticalSpace,
              SizedBox(
                width: double.infinity,
                child: TextButton(
                    onPressed: (){
                      NavigationHelper.replace('${AppRoutes.moduleAuth}${AuthModuleRoutes.signIn}');
                    },
                    child: Text(context.localization.youHaveAnAccount)
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}