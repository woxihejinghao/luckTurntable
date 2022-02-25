import 'package:hive/hive.dart';
part 'options_model.g.dart';

///选项盒子名称
const optionsBox = 'options';

@HiveType(typeId: 1)
class OptionsModel extends HiveObject {
  @HiveField(0)
  String? name;

  @HiveField(1, defaultValue: 1)
  int weight = 1;

  @HiveField(2, defaultValue: [])
  List<OptionsModel> items = [];
}
