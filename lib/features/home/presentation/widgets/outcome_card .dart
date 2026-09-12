import 'package:flutter/material.dart';
import 'package:masroof_app/core/constants/app_colors.dart';
import 'package:masroof_app/core/constants/app_size.dart';

class CustomOutcomeCard extends StatelessWidget {
  final double totalExpense;
  const CustomOutcomeCard({super.key, required this.totalExpense});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 167,
          height: 105,
          decoration: BoxDecoration(
            color: AppLightColors.wightColor,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(
            
            children: [
              SizedBox(height: AppSize.h8,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("إجمالي المصروفات", style: TextStyle(fontSize: 16,color: AppLightColors.primaryNumberColor)),
                  Icon(Icons.arrow_upward, color: AppLightColors.primaryNumberColor),
                ],
              ),
              SizedBox(height: AppSize.h12),
              Text('${totalExpense.toStringAsFixed(2)} EGP  ', style: TextStyle(fontSize: AppSize.sp20)),
            ],
          ),
        ),
            Container(
          width: 8,
          height: 105,
          decoration: BoxDecoration(
            color: AppLightColors.primaryNumberColor,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
      ],
    );
  }
}
