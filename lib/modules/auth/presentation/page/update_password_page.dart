import 'package:flutter/material.dart';
import 'package:flutter_api/core/components/confirm_dialog.dart';
import 'package:flutter_api/core/constants/app_routes.dart';
import 'package:flutter_api/core/constants/app_styles.dart';
import 'package:flutter_api/core/extensions/localized_extendsion.dart';
import 'package:flutter_api/core/helpers/navigation_helper.dart';
import 'package:flutter_api/modules/app/general/app_module_routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_api/modules/auth/presentation/blocs/auth_bloc.dart';
import 'package:flutter_api/modules/auth/presentation/blocs/auth_event.dart';
import 'package:flutter_api/modules/auth/presentation/blocs/auth_state.dart';

class UpdatePasswordPage extends StatefulWidget {
  const UpdatePasswordPage({super.key});

  @override
  State<UpdatePasswordPage> createState() => _UpdatePasswordPageState();
}

class _UpdatePasswordPageState extends State<UpdatePasswordPage> {
  final TextEditingController _oldController = TextEditingController();
  final TextEditingController _newController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  bool _isLoading = false;

  final _authBloc = Modular.get<AuthBloc>();

  @override
  void dispose() {
    _oldController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  /// Hàm validate và check dữ liệu trước khi submit
  bool _validateInputs() {
    final oldPass = _oldController.text.trim();
    final newPass = _newController.text.trim();
    final confirm = _confirmController.text.trim();

    if (oldPass.isEmpty || newPass.isEmpty || confirm.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.localization.pleaseEnterCompleteInformation),
        ),
      );
      return false;
    }

    if (newPass != confirm) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.localization.pleaseEnterRightPassword)),
      );
      return false;
    }

    return true;
  }

  /// Hàm submit chỉ gửi event
  void _submit() {
    final oldPass = _oldController.text.trim();
    final newPass = _newController.text.trim();

    _authBloc.add(
      AuthUpdatePasswordRequested(
        currentPassword: oldPass,
        newPassword: newPass,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      bloc: _authBloc,
      listener: (context, state) {
        if (state is AuthLoading) {
          setState(() => _isLoading = true);
        } else {
          setState(() => _isLoading = false);
        }

        if (state is AuthUpdatePasswordSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.localization.resetPasswordSuccess),
              backgroundColor: Colors.green,
            ),
          );
          NavigationHelper.reset(
            '${AppRoutes.moduleApp}${AppModuleRoutes.main}',
          ); // quay về màn chính
        } else if (state is AuthUpdatePasswordFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error), backgroundColor: Colors.red),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Color(0xFF000D00),
        appBar: AppBar(
          backgroundColor: Color(0xFF001600),
          title: Title(
            color: Colors.grey,
            child: Text(
              context.localization.resetPassword,
              style: Styles.h5.smb.copyWith(color: Colors.white),
            ),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _oldController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: context.localization.oldPassword,
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _newController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: context.localization.newPassword,
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _confirmController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: context.localization.newPasswordConfirm,
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),
                _isLoading
                    ? const CircularProgressIndicator()
                    : TextButton(
                        onPressed: () async {
                          if (_validateInputs()) {
                            final confirm = await showConfirmDialog(
                              context: context,
                              title: context.localization.confirm,
                              content:
                                  '${context.localization.areYouReallyWantToChangePassword}?',
                            );
                            if (confirm == true) {
                              _submit();
                            }
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 34,
                          width: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                              colors: [
                                Colors.deepPurple.shade400,
                                Colors.deepPurple.shade200,
                              ],
                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight,
                            ),
                            border: Border.all(width: 1.5, color: Colors.white),
                          ),
                          child: Text(
                            context.localization.resetPassword,
                            style: Styles.large.smb.copyWith(
                              color: Colors.white,
                            ),
                          ),
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
