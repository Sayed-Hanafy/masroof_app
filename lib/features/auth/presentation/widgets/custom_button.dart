import 'package:flutter/material.dart';
import 'package:masroof_app/core/constants/app_colors.dart';
import 'package:masroof_app/core/constants/app_size.dart';

class CustomButton extends StatelessWidget {
 const CustomButton({
    super.key,
    this.onPressed,
    required this.title,
    this.icon,
    this.color,
    this.textColor,
    this.child,
  });

 final void Function()? onPressed;
 final String title;
 final IconData? icon;
 final Color? color;
 final Color? textColor;
 final Widget? child;
 
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color?? AppLightColors.primaryColor ,
        minimumSize: Size(AppSize.w350, AppSize.h60),
        
      ),
      child: child ?? Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              color: textColor ?? AppLightColors.wightColor,
              fontSize: AppSize.sp16,
            ),
          ),
          SizedBox(width: AppSize.w8),
          Icon(icon, color: textColor ?? AppLightColors.wightColor, size: 18),
        ],
      ),
    );
  }
}
