import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masroof_app/core/constants/app_colors.dart';
import 'package:masroof_app/core/constants/app_size.dart';
import 'package:masroof_app/features/transactions/presentation/cubit/transaction_cubit.dart';

class DatePickerWidget extends StatelessWidget {
  const DatePickerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionCubit, TransactionState>(
      builder: (_, state) {
        return Container(
          padding: EdgeInsetsGeometry.lerp(
            EdgeInsets.zero,
            EdgeInsets.all(AppSize.ph16),
            1,
          ),
          width: MediaQuery.of(context).size.width,
          height: AppSize.h60,
          decoration: BoxDecoration(
            color: AppLightColors.wightColor,
            borderRadius: BorderRadius.circular(AppSize.w10),
            border: Border.all(color: AppLightColors.subTextColor, width: 0.5),
          ),
          //alignment: Alignment(0, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                state.selectedDate == null
                    ? 'حدد التاريخ'
                    : '${state.selectedDate!.day}/${state.selectedDate!.month}/${state.selectedDate!.year}',
              ),
              InkWell(
                child: Icon(Icons.date_range),
                onTap: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: state.selectedDate ?? DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                  );

                  if (pickedDate != null) {
                    context.read<TransactionCubit>().selectDate(pickedDate);
                  }

                  //print(state.selectedDate);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
