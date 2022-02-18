import 'dart:math';
import 'package:flutter/material.dart';
import 'package:luck_turntable/common/instances.dart';
import 'package:luck_turntable/turntable_paint.dart';

class ChoicePage extends StatefulWidget {
  const ChoicePage({Key? key}) : super(key: key);

  @override
  _ChoicePageState createState() => _ChoicePageState();
}

class _ChoicePageState extends State<ChoicePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _angleAnimation;
  String result = "";
  final List<String> titles = ["螺蛳粉", "麻辣烫"];

  double target = 0;
  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
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
        title: const Text("幸运转盘"),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildResultContainer(),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.9 + 50,
              width: MediaQuery.of(context).size.width * 0.9,
              child: CustomPaint(
                painter:
                    TurntablePainter(titles, _angleAnimation, target: target),
              ),
            ),
            const SizedBox(
              height: 60,
            ),
            _buildBottomButtons()
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: currentColorScheme.secondary,
              onPrimary: Colors.black,
              minimumSize: const Size(150, 40)),
          onPressed: () {
            setState(() {
              target = Random().nextDouble();

              _controller.reset();
              _controller.forward().then((value) {
                setState(() {
                  var result = (target * titles.length).toInt();

                  this.result = titles[result];
                });
              });
            });
          },
          child: const Text(
            "开始抽选",
            style: TextStyle(fontSize: 20),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: currentColorScheme.secondary,
              onPrimary: Colors.black,
              minimumSize: const Size(150, 40)),
          onPressed: () => navigatorState.pushNamed("/options"),
          child: const Text(
            "切换选项",
            style: TextStyle(fontSize: 20),
          ),
        )
      ],
    );
  }

  Widget _buildResultContainer() {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10),
      alignment: Alignment.center,
      height: 40,
      constraints: const BoxConstraints(minWidth: 100, maxWidth: 200),
      child: Text(
        result,
        style: const TextStyle(fontSize: 20),
      ),
      decoration: BoxDecoration(
          border: Border.all(color: currentColorScheme.secondary, width: 3),
          borderRadius: BorderRadius.circular(20)),
    );
  }
}
