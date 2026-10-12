import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masroof_app/core/constants/app_colors.dart';
import 'package:masroof_app/features/transactions/presentation/cubit/transaction_cubit.dart';

class AnalysisBarChart extends StatelessWidget {
  final double income;
  final double expense;

  const AnalysisBarChart({
    super.key,
    required this.income,
    required this.expense,
  });

  @override
  Widget build(BuildContext context) {
    //final maxValue = income > expense ? income : expense;
    final maxValue = income > expense ? income : expense;

    final maxY =
        maxValue == 0 ? 2000.0 : ((maxValue / 2000).ceil() * 2000).toDouble();
    return Container(
      height: 280,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppLightColors.wightColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'الدخل VS المصروفات',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          Expanded(
            child: BarChart(
              BarChartData(
                maxY: maxY,
                gridData: FlGridData(show: false),
                  alignment: BarChartAlignment.spaceAround,

                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        String title;

                        switch (value.toInt()) {
                          case 0:
                            title = 'الدخل';
                            break;
                          case 1:
                            title = 'المصروفات';
                            break;
                          default:
                            title = '';
                        }

                        return Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(
                            title,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 2000,
                      getTitlesWidget: (value, meta) {
                        final number = value.toInt();
                        String title;
                        if (number >= 1000) {
                          title = '${(number / 1000).toStringAsFixed(0)}K';
                        } else {
                          title = number.toString();
                        }
                        return Text(
                          title,
                          style: const TextStyle(fontSize: 14),
                        );
                      },
                    ),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                barGroups: [
                  BarChartGroupData(
                    x: 0,
                    barRods: [
                      BarChartRodData(
                        color: Colors.green,
                        toY: income,
                        width: 35,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  ),
                  BarChartGroupData(
                    x: 1,
                    barRods: [
                      BarChartRodData(
                        color: Colors.red,
                        toY: expense,
                        width: 35,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// BarChart(BarChartData(
//       alignment: BarChartAlignment.spaceAround,
//       maxY: (income > expense ? income : expense) + 1000,
//       barTouchData: BarTouchData(enabled: false),
//       titlesData: FlTitlesData(
//         show: true,
//         bottomTitles: AxisTitles(
//           sideTitles: SideTitles(
//             showTitles: true,
//             getTitlesWidget: (double value, TitleMeta meta) {
//               switch (value.toInt()) {
//                 case 0:
//                   return const Text('Income');
//                 case 1:
//                   return const Text('Expense');
//                 default:
//                   return const Text('');
//               }
//             },
//           ),
//         ),
//         leftTitles: AxisTitles(
//           sideTitles: SideTitles(showTitles: false),
//         ),
//         topTitles: AxisTitles(
//           sideTitles: SideTitles(showTitles: false),
//         ),
//         rightTitles: AxisTitles(
//           sideTitles: SideTitles(showTitles: false),
//         ),
//       ),
//       borderData: FlBorderData(
//         show: false,
//       ),
//       barGroups: [
//         BarChartGroupData(x: 0, barRods: [
//           BarChartRodData(
//             toY: income,
//             color: Colors.green,
//             width: 20,
//             borderRadius: BorderRadius.circular(4),
//           )
//         ]),
//         BarChartGroupData(x: 1, barRods: [
//           BarChartRodData(
//             toY: expense,
//             color: Colors.red,
//             width: 20,
//             borderRadius: BorderRadius.circular(4),
//           )
//         ]),
//       ],
//     ));
