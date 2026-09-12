import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:masroof_app/core/constants/app_colors.dart';

class CustomSvgPic extends StatelessWidget {
  const CustomSvgPic({super.key, required this.path, this.withColor = true});
  final String path;
  final bool withColor;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      path,
      colorFilter: withColor? ColorFilter.mode(
        AppLightColors.subTextColor, 
        BlendMode.srcIn,
      ): null
    );
  }
}
