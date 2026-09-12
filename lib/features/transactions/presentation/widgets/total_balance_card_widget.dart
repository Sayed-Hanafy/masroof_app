import 'package:flutter/material.dart';
import 'package:masroof_app/core/constants/app_colors.dart';
import 'package:masroof_app/core/constants/app_size.dart';

class TotalBalanceCardWidget extends StatelessWidget {
  const TotalBalanceCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return  Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(AppSize.pw16),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 134,
              decoration: BoxDecoration(
                color: AppDarkColors.wightColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppLightColors.strokeColor, width: 0.5),
              ),
            ),
          ),

          Positioned.fill(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(AppSize.ph16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("المبلغ"),
                    SizedBox(height: AppSize.h16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [
                        Text("0.00",style: TextStyle(
                            fontSize: AppSize.sp40,
                            fontWeight: FontWeight.bold,
                            color: AppLightColors.primaryColor,
                          ),),
                        SizedBox(width: AppSize.pw24),
                        Text(
                          "EGP",
                          style: TextStyle(
                            fontSize: AppSize.sp40,
                            fontWeight: FontWeight.bold,
                            color: AppLightColors.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
  }
}