import 'package:flutter/material.dart';
import 'package:flutter_api/core/components/confirm_dialog.dart';
import 'package:flutter_api/core/constants/app_routes.dart';
import 'package:flutter_api/core/constants/app_styles.dart';
import 'package:flutter_api/core/extensions/localized_extendsion.dart';
import 'package:flutter_api/core/extensions/num_extendsion.dart';
import 'package:flutter_api/core/helpers/navigation_helper.dart';
import 'package:flutter_api/core/models/user_model.dart';
import 'package:flutter_api/core/utils/utils.dart';
import 'package:flutter_api/modules/account/data/repositories/account_repository.dart';
import 'package:flutter_api/modules/account/general/account_module_route.dart';
import 'package:flutter_api/modules/account/presentation/components/user_title.dart';
import 'package:flutter_api/modules/account/presentation/components/user_utility.dart';
import 'package:flutter_api/modules/app/general/app_module_routes.dart';
import 'package:flutter_api/modules/auth/general/auth_module_routes.dart';
import 'package:flutter_api/modules/auth/presentation/blocs/auth_bloc.dart';
import 'package:flutter_api/modules/auth/presentation/blocs/auth_event.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AccountPage extends StatefulWidget {
  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final AuthBloc authBloc = Modular.get<AuthBloc>();
  late final AccountRepository repository;

  UserModel user = UserModel();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    repository = Modular.get<AccountRepository>();
    loadUser();
  }

  Future<void> loadUser() async {
    setState(() {
      isLoading = true;
    });

    try {
      final result = await repository.getCurrentUser();

      if (result == null) {
        Utils.debugLog('User is null');
      } else {
        user = result;
      }
    } catch (e) {
      Utils.debugLog('Error: $e');
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          padding: const EdgeInsets.only(left: 16, bottom: 8, top: 16),
          child: Text(
            context.localization.accountTitle,
            style: Styles.h1.smb.copyWith(color: Colors.white.withValues(alpha: 0.9)),
          ),
        ),
      ),
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: loadUser,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        20.verticalSpace,
                        UserTitle(
                          userName: user.fullName ?? '',
                          userEmail: user.email ?? '',
                          userGender: user.gender ?? '',
                        ),
                        20.verticalSpace,
                        _buildLine(),
                        20.verticalSpace,
                        UserUtility(
                          icon: const Icon(Icons.password),
                          title: context.localization.changePassword,
                          onPress: () {
                            NavigationHelper.navigate(
                              '${AppRoutes.moduleAuth}${AuthModuleRoutes.updatePassword}',
                            );
                          },
                        ),
                        8.verticalSpace,
                        UserUtility(
                          icon: const Icon(
                            Icons.supervised_user_circle_rounded,
                          ),
                          title: context.localization.updateUser,
                          onPress: () {
                            NavigationHelper.navigate(
                              '${AppRoutes.moduleApp}${AppModuleRoutes.updateUser}',
                            );
                          },
                        ),
                        20.verticalSpace,
                        _buildLine(),
                        20.verticalSpace,
                        UserUtility(
                          icon: const Icon(
                            Icons.question_answer_outlined,
                          ),
                          title: 'Trợ giúp & phản hồi',
                          onPress: () {
                            NavigationHelper.navigate(
                              '${AppRoutes.moduleAccount}${AccountModuleRoute.help}',
                            );
                          },
                          color2: Colors.blueGrey,
                        ),
                        20.verticalSpace,
                        _buildLine(),
                        20.verticalSpace,
                        UserUtility(
                          icon: const Icon(Icons.logout),
                          title: context.localization.logOut,
                          onPress: () {
                            authBloc.add(AuthLogoutRequested());
                          },
                          color1: Colors.white,
                          color3: Colors.red.shade200,
                        ),
                        40.verticalSpace,
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}

Widget _buildLine(){
  return Container(
    width: double.infinity,
    height: 1,
    decoration: BoxDecoration(
        color: Colors.white24
    ),
  );
}