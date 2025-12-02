import 'package:flutter/material.dart';
import 'package:flutter_api/core/components/app_annotated_region.dart';
import 'package:flutter_api/core/constants/app_colors.dart';
import 'package:flutter_api/core/constants/app_routes.dart';
import 'package:flutter_api/core/mixin/route_focus_mixin.dart';
import 'package:flutter_api/modules/app/presentation/components/title_navigaion_bar/navigation_bar.dart';
import 'package:flutter_api/modules/app/presentation/components/title_navigaion_bar/navigation_bar_item.dart';
import 'package:flutter_api/modules/auth/presentation/page/update_password_page.dart';
import 'package:flutter_api/modules/weather/presentation/pages/weather_page.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:preload_page_view/preload_page_view.dart';

import '../../general/app_module_routes.dart';


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
    return [WeatherPage(), UpdatePasswordPage()];
  }


  void navigatePageView(int value) {
    setState(() {
      _currentIndex = value;
    });
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
            backgroundColor: Colors.transparent,
            body: PreloadPageView(
              pageSnapping: true,
              controller: _pageController,
              preloadPagesCount: 2,
              physics: const NeverScrollableScrollPhysics(),
              children: _pageViews(),
              onPageChanged: (value) {},
            ),
            extendBody: true,
            bottomNavigationBar:
                TitledBottomNavigationBar(
                  onTap: (value) {
                    navigatePageView(value);
                  },
                  inactiveColor: Colors.white,
                  activeColor: AppColors.primary,
                  indicatorColor: Colors.transparent,
                  currentIndex: _currentIndex,
                  items: [
                    TitledNavigationBarItem(
                      icon: Icons.cloud_outlined,
                      activeIcon: Icons.cloud,
                      title: 'weather',
                    ),
                    TitledNavigationBarItem(
                      icon: Icons.people_alt_outlined,
                      activeIcon: Icons.people_alt_rounded,
                      title: 'Users',
                    ),
                  ],
                ),
          ),
        ),
      ],
    );
  }
}
