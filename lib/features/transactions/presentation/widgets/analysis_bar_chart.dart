import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:masroof_app/core/constants/app_colors.dart';

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
    final maxValue = income > expense ? income : expense;
    final double maxY = maxValue == 0 ? 1000 : maxValue * 1.2;
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
      child: BarChart(
        BarChartData(

          
          maxY: maxY,
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

                  return Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 45,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: const TextStyle(fontSize: 11),
                  );
                },
              ),
            ),
            topTitles: const AxisTitles(
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
