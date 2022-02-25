import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:luck_turntable/common/instances.dart';
import 'package:luck_turntable/models/options_model.dart';
import 'package:luck_turntable/view/input_sheet.dart';
import 'package:flutter/services.dart';

class OptionEditPage extends StatefulWidget {
  final OptionsModel? model;
  const OptionEditPage({Key? key, this.model}) : super(key: key);

  @override
  _OptionEditPageState createState() => _OptionEditPageState();
}

class _OptionEditPageState extends State<OptionEditPage> {
  late OptionsModel model;
  @override
  void initState() {
    super.initState();
    if (widget.model == null) {
      model = OptionsModel();
    } else {
      model = widget.model!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("创建模版"),
          actions: [_buildSaveButton()],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                    child: CustomScrollView(
                  slivers: <Widget>[
                    _createTitleSection("名称"),
                    _buildTitleInputCard(),
                    const SliverToBoxAdapter(
                      child: SizedBox(
                        height: 20,
                      ),
                    ),
                    _createTitleSection("选项"),
                    _buildListView()
                  ],
                )),
                _buildBottomButtons()
              ],
            ),
          ),
        ));
  }

  //创建标题输入
  SliverToBoxAdapter _buildTitleInputCard() {
    return SliverToBoxAdapter(
      child: Card(
        elevation: 2,
        child: ListTile(
            onTap: () {
              showModalBottomSheet(
                  context: context,
                  builder: (ctx) => InputBottomSheet(
                        text: model.name,
                        maxLength: 15,
                        textCallback: (text) {
                          setState(() {
                            model.name = text;
                          });
                        },
                      ));
            },
            title: Text(
              model.name ?? "请输入名称",
              style: TextStyle(
                  fontSize: 20,
                  color: model.name != null || (model.name?.isEmpty ?? false)
                      ? null
                      : Colors.grey),
            )),
      ),
    );
  }

  //底部按钮
  Widget _buildBottomButtons() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton.icon(
            onPressed: () {
              if (!_checkCanInsertOption()) {
                return;
              }
              Clipboard.getData(Clipboard.kTextPlain).then((value) {
                setState(() {
                  model.items.add(OptionsModel()..name = value?.text);
                });
              });
            },
            icon: const Icon(Icons.copy),
            label: const Text("从剪切板导入")),
        ElevatedButton.icon(
          onPressed: () {
            if (!_checkCanInsertOption()) {
              return;
            }
            setState(() {
              model.items.add(OptionsModel());
            });
          },
          icon: const Icon(Icons.add),
          label: const Text("添加选项"),
          style: ElevatedButton.styleFrom(
              primary: currentColorScheme.secondary,
              onPrimary: Colors.black,
              textStyle: const TextStyle(fontSize: 18)),
        )
      ],
    );
  }

  //创建列表
  SliverList _buildListView() {
    return SliverList(
        delegate: SliverChildBuilderDelegate(((context, index) {
      OptionsModel item = model.items[index];
      return Card(
        elevation: 2,
        child: _buildListItem(item),
      );
    }), childCount: model.items.length));
  }

  ListTile _buildListItem(OptionsModel item) {
    return ListTile(
      leading: IconButton(
        onPressed: () {
          setState(() {
            model.items.remove(item);
          });
        },
        icon: const Icon(
          Icons.delete,
          color: Colors.red,
          size: 20,
        ),
      ),
      title: TextButton(
        child: Text(
          item.name ?? "选项内容",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              fontSize: 15,
              color: item.name != null || (item.name?.isEmpty ?? false)
                  ? null
                  : Colors.grey),
        ),
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (ctx) => InputBottomSheet(
                    text: item.name,
                    maxLength: 20,
                    textCallback: (result) {
                      setState(() {
                        item.name = result;
                      });
                    },
                  ));
        },
      ),
      trailing: TextButton(
        child: Text(
          "｜ 权重:${item.weight}",
          style: const TextStyle(color: Colors.grey),
        ),
        onPressed: () {},
      ),
    );
  }

  Widget _buildSaveButton() {
    return TextButton(
        onPressed: () {
          if (model.name == null) {
            Fluttertoast.showToast(
                msg: "请输入模版名称", gravity: ToastGravity.CENTER);
            return;
          }

          if (model.items.last.name == null) {
            Fluttertoast.showToast(
                msg: "请输入选项名称", gravity: ToastGravity.CENTER);
            return;
          }
          var box = Hive.box("options");
          if (model.key != null && widget.model != null) {
            box.put(model.key, model);
          } else {
            box.add(model);
          }

          Navigator.pop(context);
        },
        child: const Text(
          "保存",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ));
  }

  //创建标题
  SliverToBoxAdapter _createTitleSection(String title) {
    return SliverToBoxAdapter(
      child: Text(
        title,
        style: currentTheme.textTheme.subtitle1,
      ),
    );
  }

//是否能插入选项
  bool _checkCanInsertOption() {
    if (model.items.isEmpty) {
      return true;
    }
    if (model.items.last.name == null ||
        (model.items.last.name?.isEmpty ?? true)) {
      Fluttertoast.showToast(msg: "请输入选项名称", gravity: ToastGravity.CENTER);
      return false;
    }

    return true;
  }
}
