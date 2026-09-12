import 'package:flutter/material.dart';
import 'package:masroof_app/core/constants/app_colors.dart';

class SearchTextbox extends StatelessWidget {
  const SearchTextbox({super.key, this.hintText, this.controller});

  final String? hintText;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,

      style: Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: 16),
      decoration: InputDecoration(
        filled: true,
        fillColor: AppLightColors.wightColor,
        suffixIcon: Icon(Icons.search, color: AppLightColors.primaryColor),

        errorStyle: TextStyle(color: Colors.white),
        hintText: hintText,
        hintTextDirection: TextDirection.rtl,
        alignLabelWithHint: true,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: AppLightColors.strokeColor, width: 0.5),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
