import 'package:flutter/material.dart';
import 'package:luck_turntable/turntable_paint.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
            painter: TurntablePainter(["螺蛳粉", "麻辣烫", "鸡排饭", "粥", "炸酱面"]),
          ),
        ),
      ),
    );
  }
}
