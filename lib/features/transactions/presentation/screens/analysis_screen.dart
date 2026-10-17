// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:masroof_app/features/transactions/presentation/cubit/transaction_cubit.dart';
// class AnalysisScreen extends StatelessWidget {
//   const AnalysisScreen({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('تحليل المصروفات')),
//       body: BlocBuilder<TransactionCubit, TransactionState>(
//         builder: (context, state) {
//           final expensesByCategory =
//               context.read<TransactionCubit>().getExpensesByCategory();
//           if (state.totalExpense == 0) {
//             return const Center(child: Text('لا يوجد مصاريف'));
//           }
//           return ListView(
//             children:
//                 expensesByCategory.entries.map((entry) {
//                   final percentage = (entry.value / state.totalExpense) * 100;
//                   return ListTile(
//                     title: Text(entry.key),
//                     subtitle: Text('${percentage.toStringAsFixed(2)}%'),
//                     trailing: Text('${entry.value.toStringAsFixed(2)} EGP'),
//                   );
//                 }).toList(),
//           );
//         },
//       ),
//     );
//   }
// }

// import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/fl_chart.dart'
    show
        AxisTitles,
        BarChart,
        BarChartData,
        BarChartGroupData,
        BarChartRodData,
        BarTouchData,
        FlGridData,
        FlTitlesData,
        SideTitles;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masroof_app/core/constants/app_colors.dart';
import 'package:masroof_app/features/transactions/presentation/cubit/transaction_cubit.dart';
import 'package:masroof_app/features/transactions/presentation/widgets/analysis_bar_chart.dart';
import 'package:masroof_app/features/transactions/presentation/widgets/analysis_pie_chart.dart';

class AnalysisScreen extends StatelessWidget {
  const AnalysisScreen({super.key});

  String getMonthName(int month) {
    const months = [
      'يناير',
      'فبراير',
      'مارس',
      'أبريل',
      'مايو',
      'يونيو',
      'يوليو',
      'أغسطس',
      'سبتمبر',
      'أكتوبر',
      'نوفمبر',
      'ديسمبر',
    ];

    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تحليل المصروفات')),
      body: BlocBuilder<TransactionCubit, TransactionState>(
        builder: (context, state) {
          final selectedMonth = state.selectedAnalysisMonth;
          final monthName = getMonthName(selectedMonth.month);

          /// get card month data
          final cubit = context.read<TransactionCubit>();
          final totalExpense = cubit.getTotalExpensesForSelectedMonth();
          final totalIncome = cubit.getTotalIncomeForSelectedMonth();
          final balance = cubit.getBalanceForSelectedMonth();

          /// calculate percentage change from previous month

          final changePercentage = cubit.getExpenseChangePercentage();
          final comparisonMessage = cubit.getExpenseComparisonMessage();

          // final currentExpenses = cubit.getTotalExpensesForSelectedMonth();

          final previousMonth = DateTime(
            selectedMonth.year,
            selectedMonth.month - 1,
          );

          final previousExpenses = cubit.getTotalExpensesForMonth(
            previousMonth,
          );

          final noPreviousExpenses = previousExpenses == 0;
          final increase = !noPreviousExpenses && changePercentage > 0;
          final decrease = !noPreviousExpenses && changePercentage < 0;
          final noChange = !noPreviousExpenses && changePercentage == 0;
          final expensesByCategory = cubit.getExpensesByCategory();

          /// test monthly expense method

          final monthlyExpenses = cubit.getLastSixMonthsExpenses();
          final maxExpense =
              monthlyExpenses.values.isEmpty
                  ? 0
                  : monthlyExpenses.values.reduce((a, b) => a > b ? a : b);
          final maxY = ((maxExpense / 2000).ceil() * 2000).toDouble();
          final months = monthlyExpenses.keys.toList();
          final barGroups =
              monthlyExpenses.entries.toList().asMap().entries.map((item) {
                final index = item.key;
                final entry = item.value;

                return BarChartGroupData(
                  x: index,
                  barRods: [
                    BarChartRodData(
                      toY: entry.value,
                      width: 25,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                );
              }).toList();

          return Column(
            children: [
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(20),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        context
                            .read<TransactionCubit>()
                            .previousAnalysisMonth();
                      },
                      icon: const Icon(Icons.arrow_back_ios),
                    ),
                    Text(
                      '$monthName ${selectedMonth.year}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        context.read<TransactionCubit>().nextAnalysisMonth();
                      },
                      icon: const Icon(Icons.arrow_forward_ios),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppLightColors.wightColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppLightColors.subTextColor,
                          ),
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
                              'إجمالي مصروفات الشهر',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),

                            const SizedBox(height: 10),

                            Text(
                              '${totalExpense.toStringAsFixed(2)} EGP',
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 10),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (!noPreviousExpenses) ...[
                                  Text(
                                    '${changePercentage.abs().toStringAsFixed(1)}%',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          increase
                                              ? Colors.red
                                              : decrease
                                              ? Colors.green
                                              : Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                ],

                                Flexible(
                                  child: Text(
                                    comparisonMessage,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color:
                                          noPreviousExpenses
                                              ? Colors.grey
                                              : increase
                                              ? Colors.red
                                              : decrease
                                              ? Colors.green
                                              : Colors.grey,
                                    ),
                                  ),
                                ),

                                if (!noPreviousExpenses) ...[
                                  const SizedBox(width: 4),
                                  Icon(
                                    increase
                                        ? Icons.arrow_upward
                                        : decrease
                                        ? Icons.arrow_downward
                                        : Icons.remove,
                                    size: 18,
                                    color:
                                        increase
                                            ? Colors.red
                                            : decrease
                                            ? Colors.green
                                            : Colors.grey,
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        decoration: BoxDecoration(
                          color: AppLightColors.wightColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppLightColors.subTextColor,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withValues(alpha: 0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  const Text(
                                    'إجمالي الدخل',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '${totalIncome.toStringAsFixed(2)} EGP',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Container(
                              width: 5,
                              height: 50,
                              color: AppLightColors.primaryNumberColor
                                  .withValues(alpha: 0.5),
                            ),

                            Expanded(
                              child: Column(
                                children: [
                                  const Text(
                                    'الرصيد',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '${balance.toStringAsFixed(2)} EGP',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          balance >= 0
                                              ? AppLightColors
                                                  .secondaryNumberColor
                                              : Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      Container(
                        width: double.infinity,
                        height: 320,
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
                              ' المصروفات خلال آخر 6 شهور',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 20),

                            Expanded(
                              child: BarChart(
                                BarChartData(
                                  maxY: maxY,
                                  gridData: FlGridData(show: false),
                                  barTouchData: BarTouchData(enabled: true),
                                  barGroups: barGroups,
                                  titlesData: FlTitlesData(
                                    topTitles: AxisTitles(
                                      sideTitles: SideTitles(showTitles: false),
                                    ),

                                    bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        getTitlesWidget: (value, meta) {
                                          final index = value.toInt();

                                          if (index < 0 ||
                                              index >= months.length) {
                                            return const SizedBox();
                                          }

                                          final month = months[index];

                                          const monthNames = [
                                            'يناير',
                                            'فبراير',
                                            'مارس',
                                            'أبريل',
                                            'مايو',
                                            'يونيو',
                                            'يوليو',
                                            'أغسطس',
                                            'سبتمبر',
                                            'أكتوبر',
                                            'نوفمبر',
                                            'ديسمبر',
                                          ];

                                          return Text(
                                            monthNames[month.month - 1],
                                            style: const TextStyle(
                                              fontSize: 11,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    leftTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        interval: 2000,
                                        reservedSize: 40,
                                      ),
                                    ),
                                    rightTitles: AxisTitles(
                                      sideTitles: SideTitles(showTitles: false),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      AnalysisBarChart(
                        income: totalIncome,
                        expense: totalExpense,
                      ),
                      const SizedBox(height: 20),
                      AnalysisPieChart(
                        expensesByCategory: expensesByCategory,
                        totalExpenses: totalExpense,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
