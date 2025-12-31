import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_api/modules/app/general/app_module_routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'core/constants/app_key.dart';
import 'core/constants/app_routes.dart';
import 'core/constants/app_theme.dart';
import 'core/helpers/generalHeper.dart';
import 'core/utils/globals.dart';
import 'core/utils/utils.dart';
import 'l10n/app_localizations.dart';
import 'modules/app/presentation/blocs/app_bloc.dart';
import 'modules/app/presentation/blocs/app_event.dart';
import 'modules/app/presentation/blocs/app_state.dart';

String appState = 'foreground';

class MainWidget extends StatefulWidget {
  const MainWidget({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MainWidgetState();
  }
}

class _MainWidgetState extends State<MainWidget> with WidgetsBindingObserver {
  bool _firstLoad = false;
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    Modular.setInitialRoute('${AppRoutes.moduleApp}${AppModuleRoutes.splash}');
    Modular.setNavigatorKey(AppKeys.navigatorKey);

    Modular.to.addListener(() {
      Utils.debugLog('Current path: ${Modular.to.path}');
      final currentPath = Modular.to.path;
      FirebaseAnalytics.instance.logScreenView(screenName: currentPath);
    });
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => Modular.get<AppBloc>()
        )
      ],
      child: MediaQuery(
        data: MediaQuery.of(
          context,
        ).copyWith(textScaler: const TextScaler.linear(1)),
        child: Portal(
          child: BlocListener<AppBloc, AppState>(
            listenWhen: (previous, current) =>
                previous.isConfigLoaded != current.isConfigLoaded,
            listener: (context, state) {
              Utils.debugLog('BlocListener: New state: $state');
              if (state.isConfigLoaded != -1) {
                if (!_firstLoad) {
                  _firstLoad = true;
                  //WebsocketService.init();
                  // await Signaling.instance.connect();
                }
              }
            },
            child: MaterialApp.router(
              title: GeneralHelper.appName,
              debugShowCheckedModeBanner: false,
              theme: AppTheme.theme,
              // locale: appLanguage.locale,
              scaffoldMessengerKey: AppKeys.scaffoldMessengerKey,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: AppLocalizations.supportedLocales,
              routerConfig: Modular.routerConfig,
              localeResolutionCallback: (locale, supportedLocales) {
                Locale resolvedLocale = supportedLocales.first;

                if (locale != null) {
                  for (final supported in supportedLocales) {
                    if (supported.languageCode == locale.languageCode) {
                      resolvedLocale = supported;
                      break;
                    }
                  }
                }

                // Update global locale for use in static methods
                Globals.globalLocale = resolvedLocale;
                return resolvedLocale;
              },
              localeListResolutionCallback: (locales, supportedLocales) {
                Locale resolvedLocale = supportedLocales.first;

                if (locales != null && locales.isNotEmpty) {
                  for (final locale in locales) {
                    for (final supported in supportedLocales) {
                      if (supported.languageCode == locale.languageCode) {
                        resolvedLocale = supported;
                        break;
                      }
                    }
                    if (resolvedLocale != supportedLocales.first) break;
                  }
                }

                // Update global locale for use in static methods
                Globals.globalLocale = resolvedLocale;
                return resolvedLocale;
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    Utils.debugLog('AppLifecycleState: $state');
    if (state == AppLifecycleState.resumed) {
      Modular.get<AppBloc>().add(AppConfigRequested());
    } else {
      setState(() {
        appState = 'background';
      });
    }
    super.didChangeAppLifecycleState(state);
  }
}
