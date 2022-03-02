import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:luck_turntable/common/instances.dart';
import 'package:luck_turntable/models/options_model.dart';

class SelectTemplatePage extends StatefulWidget {
  const SelectTemplatePage({Key? key}) : super(key: key);

  @override
  _SelectTemplatePageState createState() => _SelectTemplatePageState();
}

class _SelectTemplatePageState extends State<SelectTemplatePage> {
  List<OptionsModel> _localList = [];
  @override
  void initState() {
    _loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("选择模版"),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          _buildTitle("自定义"),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(left: 14, right: 14),
              child: InkWell(
                child: _buildTemplateItem("创建自定义模板"),
                onTap: () =>
                    Navigator.pushReplacementNamed(context, "/options/edit"),
              ),
            ),
          ),
          _buildTitle("内置模版"),
          _buildListView()
        ],
      ),
    );
  }

  _buildTemplateItem(String title, {IconData? iconData}) {
    return Card(
      elevation: 2,
      child: ListTile(
        leading: iconData != null ? Icon(iconData) : null,
        title: Text(
          title,
          style: currentTheme.textTheme.subtitle1,
        ),
      ),
    );
  }

  _buildTitle(String title) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 0, 10),
        child: Text(
          title,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ),
    );
  }

  _buildListView() {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 0),
      sliver: SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
        OptionsModel model = _localList[index];

        return InkWell(
            onTap: () => Navigator.pushReplacementNamed(
                context, "/options/edit",
                arguments: model),
            child: _buildTemplateItem(model.name ?? ""));
      }, childCount: _localList.length)),
    );
  }

  _loadData() {
    rootBundle.loadString("assets/sources/template.json").then((value) {
      List jsonList = jsonDecode(value);
      setState(() {
        _localList = jsonList.map((e) => OptionsModel.withLocalMap(e)).toList();
      });
    });
  }
}
