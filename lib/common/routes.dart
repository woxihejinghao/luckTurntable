import 'package:luck_turntable/choice_page.dart';
import 'package:luck_turntable/option_edit_page.dart';
import 'package:luck_turntable/options_page.dart';

/// 路由列表
final ltRoutes = {
  '/': (context, {arguments}) => const ChoicePage(),
  '/options': (context, {arguments}) => const OptionsPage(),
  '/options/edit': (context, {arguments}) => OptionEditPage(
        model: arguments,
      )
};
