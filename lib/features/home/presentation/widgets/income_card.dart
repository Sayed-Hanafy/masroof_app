import 'package:flutter/material.dart';
import 'package:masroof_app/core/constants/app_colors.dart';
import 'package:masroof_app/core/constants/app_size.dart';

class CustomIncomeCard extends StatelessWidget {
  final double totalIncome;
  const CustomIncomeCard({super.key, required this.totalIncome});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 160,
          height: 105,
          decoration: BoxDecoration(
            color: AppLightColors.wightColor,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(
            children: [
              SizedBox(height: AppSize.h8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("إجمالي الدخل", style: TextStyle(fontSize: 16)),
                  Icon(Icons.arrow_downward),
                ],
              ),
              SizedBox(height: AppSize.h12),
              Text('${totalIncome.toStringAsFixed(2)} EGP  ', style: TextStyle(fontSize: AppSize.sp20)),
            ],
          ),
        ),
        Container(
          width: 8,
          height: 105,
          decoration: BoxDecoration(
            color: AppLightColors.secondaryNumberColor,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
      ],
    );
  }
}
