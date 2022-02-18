import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
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
        child: ListTile(
          title: Text(
            model.name ?? "模版",
            style: const TextStyle(fontSize: 20),
          ),
          trailing: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, "/options/edit", arguments: model);
              },
              icon: const Icon(Icons.mode_edit)),
        ),
      );
    }

    //列表
    return ValueListenableBuilder(
        valueListenable: Hive.box(optionsBox).listenable(),
        builder: (ctx, Box box, widget) {
          return Padding(
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
