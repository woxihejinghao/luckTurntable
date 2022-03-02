import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:luck_turntable/common/instances.dart';
import 'package:luck_turntable/models/options_model.dart';
import 'package:luck_turntable/view/turntable_paint.dart';

class ChoicePage extends StatefulWidget {
  const ChoicePage({Key? key}) : super(key: key);

  @override
  _ChoicePageState createState() => _ChoicePageState();
}

class _ChoicePageState extends State<ChoicePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _angleAnimation;
  String result = "???";

  var model = OptionsModel();

  double target = 0;
  DateTime? lastTime;
  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));
    // _controller.fling(
    //     velocity: 10,
    //     springDescription:
    //         const SpringDescription(mass: 1, stiffness: 500, damping: 3));
    _angleAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine);
    _controller.addListener(() {
      if (lastTime == null) {
        var _type = FeedbackType.light;
        Vibrate.feedback(_type);

        lastTime = DateTime.now();
      } else {
        var now = DateTime.now();
        if (now.difference(lastTime!).inMilliseconds > 200) {
          var _type = FeedbackType.light;
          Vibrate.feedback(_type);
          lastTime = DateTime.now();
        }
      }
    });

    _controller.addStatusListener((status) {
      print("状态:$status");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(model.name ?? "幸运转盘"),
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
                painter: TurntablePainter(
                    model.items.map((e) => e.name ?? "").toList(),
                    _angleAnimation,
                    target: target),
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
            if (model.items.isEmpty) {
              Fluttertoast.showToast(
                  msg: "请选择模版", gravity: ToastGravity.CENTER);
              return;
            }
            setState(() {
              target = Random().nextDouble();

              _controller.reset();
              _controller.forward().then((value) {
                setState(() {
                  var result = (target * model.items.length).toInt();

                  this.result = model.items[result].name ?? "";
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
          onPressed: () => navigatorState.pushNamed("/options").then((value) {
            setState(() {
              if (value != null) {
                model = value as OptionsModel;
                _controller.reset();
              }
            });
          }),
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
      padding: const EdgeInsets.all(8),
      alignment: Alignment.center,
      constraints: BoxConstraints(
          minWidth: 100,
          maxWidth: MediaQuery.of(context).size.width * 0.8,
          minHeight: 40),
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
