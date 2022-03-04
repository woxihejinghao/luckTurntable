import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:luck_turntable/common/instances.dart';

const colorList = [
  '99CCCC',
  'FFCC99',
  'FFCCCC',
  'CC9999',
  'CCCC99',
  'CCCCFF',
  '0099CC',
  '99CC99',
  'FF6666',
  'FF9966',
  '339999',
  '66CCCC',
  'CCCCCC',
  '6666CC',
  '999933',
  'FFCC99',
  '663333',
  '3399CC',
  'CC6666',
  '6666CC'
];

class TurntablePainter extends CustomPainter {
  ///标题组
  final List<String> titles;
  final Animation<double> repaint;
  final double target;

  TurntablePainter(this.titles, this.repaint, {this.target = 0})
      : super(repaint: repaint);

  @override
  void paint(Canvas canvas, Size size) {
    _drawBottom(canvas, size);
    canvas.save();
    double offsetAngle = -repaint.value * 2 * pi * (5 + target) - pi * 0.5;

    canvas.translate(size.width / 2, (size.height - 50) / 2);
    canvas.rotate(offsetAngle);
    //绘制分区
    _drawPart(size, canvas);

    canvas.restore();

    ///绘制外圆
    canvas.drawCircle(
        Offset(size.width / 2, (size.height - 50) / 2),
        size.width / 2,
        Paint()
          ..style = PaintingStyle.stroke
          ..color = Color(0xFFF1F1F1)
          ..strokeWidth = 10);

    _drawPoint(canvas, size);
  }

  //绘制分区
  void _drawPart(Size size, Canvas canvas) {
    Paint paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 3
      ..isAntiAlias = true
      ..style = PaintingStyle.fill; //填充、

    int num = titles.length;

    Rect rect = Rect.fromCircle(center: Offset.zero, radius: size.width / 2);

    if (num == 0) {
      canvas.drawCircle(Offset.zero, size.width / 2,
          paint..color = currentColorScheme.primary);
      return;
    }
    for (var i = 0; i < num; i++) {
      Color color =
          Color(int.parse("FF${colorList[i % colorList.length]}", radix: 16));

      //绘制分区

      canvas.drawArc(
          rect,
          2 * pi * i / num,
          2 * pi * 1 / num,
          true,
          Paint()
            ..color = color
            ..style = PaintingStyle.fill);

      //绘制分割线
      if (num > 1) {
        canvas.drawArc(
            rect,
            2 * pi * i / num,
            2 * pi * 1 / num,
            true,
            Paint()
              ..color = Colors.white
              ..style = PaintingStyle.stroke
              ..strokeWidth = 2);
      }
      //绘制文字
      TextPainter textPainter = TextPainter(
          maxLines: 2,
          text: TextSpan(
              text: titles[i],
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(12), color: Colors.white)),
          textAlign: TextAlign.right,
          textDirection: TextDirection.ltr);

      textPainter.layout(maxWidth: size.width / 3 - 20);
      Size textSize = textPainter.size;
      canvas.save(); //保存画布副本
      Offset offset = Offset(
          size.width / 2 - textSize.width - 10 - 10, -textSize.height / 2);
      // canvas.translate(size.width / 2, (size.height - 50) / 2); //画布移动到中心
      double roaAngle = 2 * pi * (i / num + 1 / num / 2);
      canvas.rotate(roaAngle); //画布旋转到水平角度,方便布局
      //绘制文字
      textPainter.paint(canvas, offset);

      canvas.restore(); //恢复
    }
  }

  //绘制指针
  _drawPoint(Canvas canvas, Size size) {
    canvas.save();
    canvas.translate(size.width / 2, (size.height - 50) / 2);

    Path path = Path();

    path.moveTo(0, -50);
    path.lineTo(-20, 10);
    path.lineTo(0, 0);
    path.lineTo(20, 10);

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
        Offset(size.width / 2, (size.height - 50) / 2),
        size.width / 12,
        paint
          ..color = Colors.white
          ..style = PaintingStyle.fill);
    //绘制内圆
    canvas.drawCircle(
        Offset(size.width / 2, (size.height - 50) / 2),
        size.width / 15,
        paint
          ..color = Colors.pink
          ..style = PaintingStyle.fill);
    //绘制文字

    TextPainter textPainter = TextPainter(
        text: const TextSpan(
            text: "吉",
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
        (size.height - 50) / 2 - textSize.height / 2);
    // canvas.translate(size.width / 2, size.height / 2); //画布移动到中心
    //绘制文字
    textPainter.paint(canvas, offset);
  }

  //绘制底部
  _drawBottom(Canvas canvas, Size size) {
    Path path = Path();
    Paint paint = Paint()
      ..strokeJoin = StrokeJoin.round
      ..color = currentColorScheme.primary
      ..style = PaintingStyle.fill;

    canvas.save();
    canvas.translate(size.width / 2, size.height - 100);
    path
      ..relativeMoveTo(0, 0)
      ..relativeLineTo(-size.width / 4, 100)
      // ..relativeLineTo(30, -30)
      // ..relativeLineTo(30, 30)
      ..relativeLineTo(size.width / 2, 0)
      ..close();
    canvas.drawPath(path, paint);
    // var pathOval = Path()..addOval(const Rect.fromLTWH(-50, 0, 100, 40));
    // canvas.drawPath(
    //     Path.combine(PathOperation.difference, path, pathOval), paint);
    // canvas.drawCircle(Offset.zero, 100, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(TurntablePainter oldDelegate) {
    return oldDelegate.repaint.value != repaint.value;
  }

  @override
  bool shouldRebuildSemantics(CustomPainter oldDelegate) => false;
}
