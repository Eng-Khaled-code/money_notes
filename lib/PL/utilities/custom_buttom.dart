import 'package:abukhaledapp/constance.dart';
import 'package:abukhaledapp/PL/utilities/custom_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String? text;

  final Color? color;

  final Function()? onPress;

  final double? width;
  CustomButton(
      {@required this.onPress,
      this.text = 'Write text ',
      this.color = primaryColor,
      this.width});

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      shape: new RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(10.0),
      ),
      padding: EdgeInsets.all(10),
      onPressed: onPress,
      color: primaryColor,
      child: Container(
        width: width,
        child: Center(
          child: CustomText(
            text: text!,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
