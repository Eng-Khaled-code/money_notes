import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;

  final double fontSize;

  final Color color;

  final double height;

  CustomText({
    this.text = '',
    this.fontSize = 16,
    this.color = Colors.black,
    this.height = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        height: height,
        fontSize: fontSize,
      ),
    );
  }
}
