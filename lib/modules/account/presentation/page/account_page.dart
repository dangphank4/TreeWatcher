import 'package:flutter/material.dart';
import 'package:flutter_api/core/constants/app_routes.dart';
import 'package:flutter_api/core/extensions/localized_extendsion.dart';
import 'package:flutter_api/core/helpers/navigation_helper.dart';
import 'package:flutter_api/modules/account/presentation/components/user_title.dart';
import 'package:flutter_api/modules/account/presentation/components/user_utility.dart';
import 'package:flutter_api/modules/auth/general/auth_module_routes.dart';
import 'package:flutter_api/modules/auth/presentation/blocs/auth_bloc.dart';
import 'package:flutter_api/modules/auth/presentation/blocs/auth_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AccountPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AccountPageState();
  }
}

class _AccountPageState extends State<AccountPage> {
  final AuthBloc authBloc = Modular.get<AuthBloc>();


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UserTitle(
                  userName: 'Nguyen Van A',
                  userEmail: 'UserEmail@gmail.cosgsdfgsdfgsgfgagdsdgsfgdsbhsa jsnfjasnf askjfnsjadm',
                ),
                UserUtility(
                  icon: Icon(Icons.password),
                  title: context.localization.changePassword,
                  onPress: () {
                    NavigationHelper.navigate('${AppRoutes.moduleAuth}${AuthModuleRoutes.updatePassword}',);
                  },
                ),
                UserUtility(
                  icon: Icon(Icons.logout),
                  title: context.localization.logOut,
                  onPress: () {
                    authBloc.add(AuthLogoutRequested());
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
