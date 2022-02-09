import 'dart:math';

import 'package:flutter/material.dart';

class TurntablePainter extends CustomPainter {
  ///标题组
  final List<String> titles;

  TurntablePainter(this.titles);

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
      paint.color = turntableColors[(i + 1) % 3];
      //绘制分区
      canvas.drawArc(rect, 2 * pi * i / num, 2 * pi * 1 / num, true, paint);
      //绘制文字
      TextPainter textPainter = TextPainter(
          text: TextSpan(
              text: titles[i],
              style: const TextStyle(fontSize: 15, color: Colors.white)),
          textAlign: TextAlign.left,
          textDirection: TextDirection.ltr);

      textPainter.layout();
      Size textSize = textPainter.size;
      canvas.save(); //保存画布副本
      Offset offset = Offset(
          size.width / 2 / 2 - textSize.width / 2 + 10, -textSize.height / 2);
      canvas.translate(size.width / 2, size.height / 2); //画布移动到中心
      double roaAngle = 2 * pi * (i / num + 1 / num / 2);
      canvas.rotate(roaAngle); //画布旋转到水平角度,方便布局
      //绘制文字
      textPainter.paint(canvas, offset);

      canvas.restore(); //恢复
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(CustomPainter oldDelegate) => false;
}
