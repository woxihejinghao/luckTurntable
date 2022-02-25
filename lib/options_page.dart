import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:luck_turntable/common/instances.dart';
import 'package:luck_turntable/models/options_model.dart';

class OptionsPage extends StatefulWidget {
  const OptionsPage({Key? key}) : super(key: key);

  @override
  _OptionsPageState createState() => _OptionsPageState();
}

class _OptionsPageState extends State<OptionsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("模版列表"),
      ),
      body: SafeArea(child: _buildListView()),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).pushNamed("/options/edit"),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildListView() {
    //列表卡片
    Widget buildItemList(OptionsModel model) {
      return Card(
        elevation: 4,
        child: Dismissible(
            key: ValueKey(model),
            direction: DismissDirection.endToStart,
            confirmDismiss: (dir) {
              return showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: const Text("是否删除该模版?"),
                        actionsAlignment: MainAxisAlignment.spaceAround,
                        actions: [
                          TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text("取消")),
                          TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text("确认"))
                        ],
                      ));
            },
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                  Text(
                    "滑动删除",
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            ),
            onDismissed: (dir) {
              var box = Hive.box(optionsBox);
              box.delete(model.key);
            },
            child: ListTile(
              onTap: () {
                Navigator.pop(context, model);
              },
              title: Text(
                model.name ?? "模版",
                style: const TextStyle(fontSize: 20),
              ),
              trailing: IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/options/edit",
                        arguments: model);
                  },
                  icon: const Icon(Icons.mode_edit)),
            )),
      );
    }

    //列表
    return ValueListenableBuilder(
        valueListenable: Hive.box(optionsBox).listenable(),
        builder: (ctx, Box box, widget) {
          return box.isEmpty
              ? Center(
                  child: Text(
                    "请添加模版...",
                    style: currentTheme.textTheme.subtitle1
                        ?.copyWith(color: Colors.grey),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: ListView.builder(
                    itemCount: box.length,
                    itemBuilder: (BuildContext context, int index) {
                      OptionsModel model = box.getAt(index);
                      return buildItemList(model);
                    },
                  ),
                );
        });
  }
}
