import 'package:flutter/material.dart';

NavigatorState get navigatorState => LTInstances.navigatorKey.currentState!;

BuildContext get currentContext => navigatorState.context;

ThemeData get currentTheme => Theme.of(currentContext);

ColorScheme get currentColorScheme => currentTheme.colorScheme;

class LTInstances {
  const LTInstances._();

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver();
}
