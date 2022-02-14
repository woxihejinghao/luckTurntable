import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:luck_turntable/common/instances.dart';

class TurntablePainter extends CustomPainter {
  ///标题组
  final List<String> titles;
  final Animation<double> repaint;
  final double? target;

  TurntablePainter(this.titles, this.repaint, {this.target})
      : super(repaint: repaint);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 3
      ..isAntiAlias = true
      ..style = PaintingStyle.fill; //填充、

    int num = titles.length;
    Rect rect = Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: size.width / 2);

    List<Color> turntableColors = [Colors.red, Colors.green, Colors.blue];

    for (var i = 0; i < num; i++) {
      paint.color = (i + 1) % 2 == 0
          ? currentColorScheme.primary
          : currentColorScheme.primary.withOpacity(0.8);
      //绘制分区
      canvas.drawArc(rect, 2 * pi * i / num, 2 * pi * 1 / num, true, paint);
      //绘制文字
      TextPainter textPainter = TextPainter(
          text: TextSpan(
              text: titles[i],
              style: const TextStyle(fontSize: 18, color: Colors.white)),
          textAlign: TextAlign.left,
          textDirection: TextDirection.ltr);

      textPainter.layout();
      Size textSize = textPainter.size;
      canvas.save(); //保存画布副本
      Offset offset = Offset(
          size.width / 2 - textSize.width - 10 - 10, -textSize.height / 2);
      canvas.translate(size.width / 2, size.height / 2); //画布移动到中心
      double roaAngle = 2 * pi * (i / num + 1 / num / 2);
      canvas.rotate(roaAngle); //画布旋转到水平角度,方便布局
      //绘制文字
      textPainter.paint(canvas, offset);

      canvas.restore(); //恢复
    }

    ///绘制外圆
    canvas.drawCircle(
        Offset(size.width / 2, size.height / 2),
        size.width / 2,
        paint
          ..style = PaintingStyle.stroke
          ..color = Colors.orange
          ..strokeWidth = 10);

    _drawPoint(canvas, size);
  }

  //绘制指针
  _drawPoint(Canvas canvas, Size size) {
    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    double num = 5;
    if (target != null) {
      num += target!;
    }
    canvas.rotate(repaint.value * 2 * pi * num + pi * 0.5);
    Path path = Path();

    path.moveTo(0, -50);
    path.lineTo(-20, 10);
    path.lineTo(0, 0);
    path.lineTo(20, 10);
    // path.arcToPoint(const Offset(0, 30),
    //     radius: const Radius.circular(20), largeArc: true);
    // path.close();

    Paint paint = Paint()
      ..strokeCap = StrokeCap.round
      ..color = Colors.pink
      ..strokeWidth = 3
      ..isAntiAlias = true
      ..style = PaintingStyle.fill; //填充、
    canvas.drawPath(path, paint);

    canvas.restore();
    //绘制外圆
    canvas.drawCircle(
        Offset(size.width / 2, size.height / 2),
        size.width / 12,
        paint
          ..color = Colors.white
          ..style = PaintingStyle.fill);
    //绘制内圆
    canvas.drawCircle(
        Offset(size.width / 2, size.height / 2),
        size.width / 15,
        paint
          ..color = Colors.pink
          ..style = PaintingStyle.fill);
    //绘制文字

    TextPainter textPainter = TextPainter(
        text: const TextSpan(
            text: "转",
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            )),
        textAlign: TextAlign.left,
        textDirection: TextDirection.ltr);

    textPainter.layout();
    Size textSize = textPainter.size;
    Offset offset = Offset(size.width / 2 - textSize.width / 2,
        size.height / 2 - textSize.height / 2);
    // canvas.translate(size.width / 2, size.height / 2); //画布移动到中心
    //绘制文字
    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(TurntablePainter oldDelegate) {
    return oldDelegate.repaint.value != repaint.value;
  }

  @override
  bool shouldRebuildSemantics(CustomPainter oldDelegate) => false;
}
