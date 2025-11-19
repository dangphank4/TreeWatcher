
import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../utils/utils.dart';

mixin RouteFocusMixin<T extends StatefulWidget> on State<T> {
  late final VoidCallback _listener;

  String get routePath;
  bool isFocused = false;
  String previousPath = Modular.to.path;

  @override
  void initState() {
    super.initState();

    // Immediately check current route on first build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Modular.to.path == routePath) {
        onFocus();
        setState(() {
          isFocused = true;
        });
        Utils.debugLog('$routePath is focused');
        previousPath = Modular.to.path;
      }
    });

    _listener = () {
      if (Modular.to.path == routePath) {
        onFocus();
        setState(() {
          isFocused = true;
        });
        Utils.debugLog('$routePath is focused');
      } else if (previousPath == routePath) {
        onBlur();
        setState(() {
          isFocused = false;
        });
        Utils.debugLog('$routePath is blurred');
      }

      previousPath = Modular.to.path;
    };

    Modular.to.addListener(_listener);
  }

  void onFocus() {}

  void onBlur() {}

  @override
  void dispose() {
    Modular.to.removeListener(_listener);
    super.dispose();
  }
}
