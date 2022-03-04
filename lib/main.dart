import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:luck_turntable/common/instances.dart';
import 'package:luck_turntable/common/routes.dart';
import 'package:luck_turntable/choice_page.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:luck_turntable/models/options_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    return ScreenUtilInit(
        minTextAdapt: true,
        splitScreenMode: true,
        builder: () => _buildMaterialApp());
  }

  MaterialApp _buildMaterialApp() {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      builder: (context, widget) {
        //add this line
        ScreenUtil.setContext(context);
        return MediaQuery(
          //Setting font does not change with system font size
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: widget!,
        );
      },
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
        scheme: FlexScheme.aquaBlue,
        surfaceMode: FlexSurfaceMode.highScaffoldLevelSurface,
        blendLevel: 19,
        appBarStyle: FlexAppBarStyle.surface,
        appBarOpacity: 0.95,
        appBarElevation: 0.5,
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
          // navigationBarOpacity: 0.95,

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
        scheme: FlexScheme.aquaBlue,
        surfaceMode: FlexSurfaceMode.highScaffoldLevelSurface,
        blendLevel: 19,
        appBarStyle: FlexAppBarStyle.background,
        appBarOpacity: 0.95,
        appBarElevation: 0.5,
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
