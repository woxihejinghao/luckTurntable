import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:luck_turntable/common/instances.dart';
import 'package:luck_turntable/common/routes.dart';
import 'package:luck_turntable/choice_page.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:luck_turntable/models/options_model.dart';

void main() async {
  Hive.registerAdapter(OptionsModelAdapter());
  await Hive.initFlutter();
  await Hive.openBox(optionsBox);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      navigatorKey: LTInstances.navigatorKey,
      navigatorObservers: [LTInstances.routeObserver],
      initialRoute: "/",
      onGenerateRoute: (RouteSettings settings) {
        final String? name = settings.name;
        final pageContentBuider = ltRoutes[name];
        if (pageContentBuider != null) {
          return CupertinoPageRoute(
              builder: (context) =>
                  pageContentBuider(context, arguments: settings.arguments));
        }

        return null;
      },

      theme: FlexThemeData.light(
        colors: const FlexSchemeColor(
          primary: Color(0xff9b1b30),
          primaryVariant: Color(0xff6c1322),
          secondary: Color(0xFFFEB716),
          secondaryVariant: Color(0xFF0093C7),
          appBarColor: Color(0xffa4121c),
          error: Color(0xffb00020),
        ),
        surfaceMode: FlexSurfaceMode.highScaffoldLevelSurface,
        blendLevel: 18,
        appBarStyle: FlexAppBarStyle.primary,
        appBarOpacity: 0.95,
        appBarElevation: 0,
        transparentStatusBar: true,
        tabBarStyle: FlexTabBarStyle.forAppBar,
        tooltipsMatchBackground: true,
        swapColors: false,
        lightIsWhite: true,
        useSubThemes: true,
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        // To use playground font, add GoogleFonts package and uncomment:
        // fontFamily: GoogleFonts.notoSans().fontFamily,
        subThemesData: const FlexSubThemesData(
          useTextTheme: true,
          fabUseShape: true,
          interactionEffects: true,
          bottomNavigationBarElevation: 0,
          bottomNavigationBarOpacity: 0.95,
          navigationBarOpacity: 0.95,
          navigationBarMutedUnselectedText: true,
          navigationBarMutedUnselectedIcon: true,
          inputDecoratorIsFilled: true,
          inputDecoratorBorderType: FlexInputBorderType.outline,
          inputDecoratorUnfocusedHasBorder: true,
          blendOnColors: true,
          blendTextTheme: true,
          popupMenuOpacity: 0.95,
        ),
      ),
      darkTheme: FlexThemeData.dark(
        colors: const FlexSchemeColor(
          primary: Color(0xffe4677c),
          primaryVariant: Color(0xffb25867),
          secondary: Color.fromARGB(255, 235, 197, 108),
          secondaryVariant: Color.fromARGB(255, 105, 164, 185),
          appBarColor: Color(0xffbd545b),
          error: Color(0xffcf6679),
        ),
        surfaceMode: FlexSurfaceMode.highScaffoldLevelSurface,
        blendLevel: 18,
        appBarStyle: FlexAppBarStyle.background,
        appBarOpacity: 0.95,
        appBarElevation: 0,
        transparentStatusBar: true,
        tabBarStyle: FlexTabBarStyle.forAppBar,
        tooltipsMatchBackground: true,
        swapColors: false,
        darkIsTrueBlack: false,
        useSubThemes: true,
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        // To use playground font, add GoogleFonts package and uncomment:
        // fontFamily: GoogleFonts.notoSans().fontFamily,
        subThemesData: const FlexSubThemesData(
          useTextTheme: true,
          fabUseShape: true,
          interactionEffects: true,
          bottomNavigationBarElevation: 0,
          bottomNavigationBarOpacity: 0.95,
          navigationBarOpacity: 0.95,
          navigationBarMutedUnselectedText: true,
          navigationBarMutedUnselectedIcon: true,
          inputDecoratorIsFilled: true,
          inputDecoratorBorderType: FlexInputBorderType.outline,
          inputDecoratorUnfocusedHasBorder: true,
          blendOnColors: true,
          blendTextTheme: true,
          popupMenuOpacity: 0.95,
        ),
      ),
// If you do not have a themeMode switch, uncomment this line
// to let the device system mode control the theme mode:
// themeMode: ThemeMode.system,

      themeMode: ThemeMode.system,
      home: const ChoicePage(),
    );
  }
}
