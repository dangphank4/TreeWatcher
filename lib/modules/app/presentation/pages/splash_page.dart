import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_api/core/constants/app_routes.dart';
import 'package:flutter_api/core/helpers/navigation_helper.dart';
import 'package:flutter_api/core/utils/globals.dart';
import 'package:flutter_api/modules/account/presentation/blocs/account_bloc.dart';
import 'package:flutter_api/modules/account/presentation/blocs/account_event.dart';
import 'package:flutter_api/modules/account/presentation/blocs/account_state.dart';
import 'package:flutter_api/modules/auth/general/auth_module_routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../general/app_module_routes.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<AccountBloc>(
      create: (_) => Modular.get<AccountBloc>()..add(CheckProfileRequested()),
      child: _SplashView(),
    );
  }
}

class _SplashView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AccountBloc, AccountState>(
      listener: (context, state) {

        if (Globals.globalAccessToken == null) {
          NavigationHelper.replace(
            '${AppRoutes.moduleAuth}${AuthModuleRoutes.signIn}',
          );
          return;
        }

        if (state is ProfileIncomplete) {
          NavigationHelper.replace(
            '${AppRoutes.moduleApp}${AppModuleRoutes.updateUser}',
          );
          return;
        }

        if (state is ProfileCompleted) {
          NavigationHelper.replace(
            '${AppRoutes.moduleApp}${AppModuleRoutes.main}',
          );
          return;
        }
      },
      child: const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

