import 'package:flutter/material.dart';
import 'package:masroof_app/core/constants/app_colors.dart';
import 'package:masroof_app/core/constants/app_size.dart';

class DetailsCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const DetailsCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSize.w16),
      decoration: BoxDecoration(
        color: AppLightColors.wightColor,
        borderRadius: BorderRadius.circular(AppSize.w10),
        border: Border.all(color: AppLightColors.strokeColor),
      ),
      child: Row(
        children: [
          Container(
            width: AppSize.w42,
            height: AppSize.h42,
            decoration: BoxDecoration(
              color: AppLightColors.primaryColor.withAlpha(20),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppLightColors.primaryColor),
          ),

          SizedBox(width: AppSize.w12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: AppSize.sp12,
                    color: AppLightColors.mainTextColor,
                  ),
                ),

                SizedBox(height: AppSize.h6),

                child,
              ],
            ),
          ),
        ],
      ),
    );
  }
}