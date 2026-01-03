import 'package:flutter/material.dart';
import 'package:flutter_api/core/constants/app_images.dart';
import 'package:flutter_api/core/constants/app_routes.dart';
import 'package:flutter_api/core/constants/app_styles.dart';
import 'package:flutter_api/core/extensions/localized_extendsion.dart';
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
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                40.verticalSpace,
                Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 210,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          AppImages.gradenImg,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 210,
                      padding: EdgeInsets.only(left: 8, bottom: 10),
                      alignment: Alignment.bottomLeft,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                          colors: [
                            Colors.black26,
                            Colors.transparent,
                          ],
                          stops: [0.3 , 1.0],
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Wellcom back',
                          style: Styles.h2.smb.copyWith(
                            color: Colors.white
                          ),),
                          Text('This green world is waiting for you',
                          style: Styles.large.regular.copyWith(
                            color: Colors.white.withValues(alpha: 0.9)
                          ),)
                        ],
                      ),
                    ),

                  ],
                ),
                20.verticalSpace,
                Text(
                  context.localization.logIn,
                  style: Styles.h1.smb.copyWith(color: Colors.white),
                ),
                20.verticalSpace,
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
                      NavigationHelper.navigate(
                        '${AppRoutes.moduleAuth}${AuthModuleRoutes.forgotPassword}',
                      );
                    },
                    child: Text(
                      '${context.localization.forgotPassword}?',
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
                          SnackBar(
                            content: Text(
                              context
                                  .localization
                                  .pleaseEnterCompleteInformation,
                            ),
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
                    child: Text(
                      context.localization.logIn,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                12.verticalSpace,
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      NavigationHelper.navigate(
                        '${AppRoutes.moduleAuth}${AuthModuleRoutes.register}',
                      );
                    },
                    child: Text('${context.localization.createAnAccount}?'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
