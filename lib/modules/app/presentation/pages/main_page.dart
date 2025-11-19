

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_api/core/components/app_annotated_region.dart';
import 'package:flutter_api/core/constants/app_routes.dart';
import 'package:flutter_api/core/mixin/route_focus_mixin.dart';
import 'package:flutter_api/main.dart' as AppModuleRoutes;
import 'package:flutter_modular/flutter_modular.dart';
import 'package:preload_page_view/preload_page_view.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with RouteFocusMixin<MainPage> {
  late PreloadPageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    _pageController = PreloadPageController();

    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();

    super.dispose();
  }

  List<Widget> _pageViews() {
    return [];
  }

  // void navigatePageView(int value) {
  //   _pageController.jumpToPage(
  //     value,
  //     // duration: const Duration(milliseconds: 200),
  //     // curve: Curves.easeInOut,
  //   );
  // }

  void navigatePageView(int value) {
    _pageController.jumpToPage(value);
  }

  @override
  String get routePath => '${AppRoutes.moduleApp}${AppModuleRoutes.main}';

  @override
  onFocus() {
    final args = Modular.args; // updated on each navigation
    if (args.data != null) {
      int? index = args.data['tabIndex'] is int
          ? args.data['tabIndex']
          : int.tryParse(args.data['tabIndex'] ?? '');

      if (index != null) {
        navigatePageView(index);
      }
    }
    navigatePageView(0);
  }

  @override
  onBlur() {}

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AppAnnotatedRegion(
          child: Scaffold(
            backgroundColor: Colors.red,
            body: PreloadPageView(
              pageSnapping: true,
              controller: _pageController,
              preloadPagesCount: 2,
              physics: const NeverScrollableScrollPhysics(),
              children: _pageViews(),
              onPageChanged: (value) {},
            ),
            extendBody: true,
            bottomNavigationBar: Stack(
              alignment: Alignment.bottomCenter,
              children: [

              ],
            ),
          ),
        ),
        // Positioned(
        //   right: 30,
        //   bottom: 40,
        //   child: FloatingActionButton(
        //     onPressed: () {
        //       Utils.debugLog('pressed');
        //       Modular.to.pushNamed(
        //         '${AppRoutes.moduleApp}${AppModuleRoutes.callSreen}',
        //       );
        //     },
        //   ),
        // ),
      ],
    );
  }
}
