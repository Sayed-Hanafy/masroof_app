import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomCheckbox extends StatelessWidget {
  CustomCheckbox({super.key, required this.value, this.onChanged});

  void Function(bool?)? onChanged;
  final bool value;

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      activeColor: Color(0xff15B86C),
      value: value,
      onChanged: (bool? value) => onChanged!(value),
    );
  }
}
