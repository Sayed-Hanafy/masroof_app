import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class AnalysisPieChart extends StatelessWidget {
  final Map<String, double> expensesByCategory;
  final double totalExpenses;

  const AnalysisPieChart({
    super.key,
    required this.expensesByCategory,
    required this.totalExpenses,
  });

  @override
  Widget build(BuildContext context) {
    // final totalExpenses = expensesByCategory.values.fold<double>(
    //   0,
    //   (sum, value) => sum + value,
    // );

    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.red,
      Colors.purple,
      Colors.teal,
      Colors.brown,
      Colors.pink,
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),

        child: Column(
          children: [
            SizedBox(height: 16),

            Text(
              ' توزيع المصروفات ',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 250,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  PieChart(
                    PieChartData(
                      centerSpaceRadius: 60,
                      sections:
                          expensesByCategory.entries
                              .toList()
                              .asMap()
                              .entries
                              .map((item) {
                                final index = item.key;
                                final entry = item.value;

                                final percentage =
                                    totalExpenses == 0
                                        ? 0
                                        : (entry.value / totalExpenses) * 100;

                                return PieChartSectionData(
                                  value: entry.value,
                                  title: '',
                                  radius: 50,
                                  color: colors[index % colors.length],
                                );
                              })
                              .toList(),
                    ),
                  ),

                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'إجمالي',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        totalExpenses.toStringAsFixed(0),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'EGP',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            Column(
              children:
                  expensesByCategory.entries.toList().asMap().entries.map((
                    item,
                  ) {
                    final index = item.key;
                    final entry = item.value;

                    final percentage =
                        totalExpenses == 0
                            ? 0
                            : (entry.value / totalExpenses) * 100;

                    return Card(
                      color: Colors.white,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: colors[index % colors.length],
                              ),
                            ),

                            const SizedBox(width: 8),

                            Expanded(
                              child: Text(
                                entry.key,
                                textAlign: TextAlign.right,
                              ),
                            ),

                            Text(
                              '${entry.value.toStringAsFixed(2)} EGP',
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),

                            const SizedBox(width: 12),
                            Spacer(),
                            Text(
                              '${percentage.toStringAsFixed(1)}%',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
