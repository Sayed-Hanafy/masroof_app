import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:masroof_app/core/constants/app_colors.dart';

class AnalysisPieChart extends StatelessWidget {
  final Map<String, double> expensesByCategory;

  const AnalysisPieChart({super.key, required this.expensesByCategory});

  @override
  Widget build(BuildContext context) {
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
      child: PieChart(
        PieChartData(
          sections:
              expensesByCategory.entries.map((entry) {
                return PieChartSectionData(
                  value: entry.value,
                  title: entry.key,
                );
              }).toList(),
        ),
      ),
    );
  }
}
