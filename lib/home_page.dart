import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:luck_turntable/turntable_paint.dart';
import 'dart:ui' as ui;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ui.Image? _icon;
  ui.Image? _point;
  @override
  void initState() {
    super.initState();

    _loadImage().then((value) {
      setState(() {
        List<ui.Image>? _imageList = value;
        _icon = _imageList[0];
        _point = _imageList[1];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("首页"),
      ),
      body: Center(
        child: SizedBox(
          height: MediaQuery.of(context).size.width * 3 / 4,
          width: MediaQuery.of(context).size.width * 3 / 4,
          child: CustomPaint(
            painter: TurntablePainter(
                ["螺蛳粉", "麻辣烫", "鸡排饭", "粥", "炸酱面"], _icon, _point),
          ),
        ),
      ),
    );
  }

  Future<List<ui.Image>> _loadImage() async {
    //   Uri uri = Uri.parse("assets/images/heart.png");
    // Image.asset("assets/images/heart.png").lis
    List<ui.Image> list = [];
    ByteData data = await rootBundle.load("assets/images/heart.png");
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    ui.FrameInfo fi = await codec.getNextFrame();

    list.add(fi.image);

    data = await rootBundle.load("assets/images/point.png");
    codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    fi = await codec.getNextFrame();

    list.add(fi.image);
    return list;
  }
}
