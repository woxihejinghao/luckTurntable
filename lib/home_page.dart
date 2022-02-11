import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:luck_turntable/turntable_paint.dart';
import 'dart:ui' as ui;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _angleAnimation;
  String result = "";
  final List<String> titles = ["螺蛳粉", "麻辣烫", "鸡排饭", "粥", "炸酱面", "牛排"];

  double target = 0;
  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    // _controller.fling(
    //     velocity: 10,
    //     springDescription:
    //         const SpringDescription(mass: 1, stiffness: 500, damping: 3));
    _angleAnimation = CurvedAnimation(parent: _controller, curve: Curves.ease);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("首页"),
      ),
      body: GestureDetector(
        onDoubleTap: () {
          _controller.stop();
          // _controller.duration = const Duration(seconds: 5);
          // Timer.periodic(const Duration(seconds: 2), (timer) {
          //   _controller.stop();
          //   timer.cancel();
          // });
        },
        onTap: () {
          setState(() {
            target = Random().nextDouble();

            _controller.reset();
            _controller.forward().then((value) {
              setState(() {
                var result = (target * titles.length).toInt();

                this.result = titles[result];
                print("结果:${this.result} - $result");
              });
            });
          });
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                result,
                style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * 3 / 4,
                width: MediaQuery.of(context).size.width * 3 / 4,
                child: CustomPaint(
                  painter:
                      TurntablePainter(titles, _angleAnimation, target: target),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
