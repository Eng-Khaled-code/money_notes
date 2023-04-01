import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String? text;
  final String? initial;
  final IconData? icon;
  final String? Function(String? value)? onSave;
  final String? Function(String? value)? validator;

  CustomTextFormField({
    this.initial = "",
    this.text,
    this.icon,
    this.onSave,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(fontSize: 18.0),
      initialValue: initial,
      onSaved: (value) {
        onSave!(value!);
      },
      validator: validator!,
      decoration: InputDecoration(
        labelText: text,
        border: OutlineInputBorder(),
        prefixIcon: Icon(icon),
      ),
    );
  }
}
