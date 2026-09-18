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
import 'package:fl_chart/fl_chart.dart';
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
          final increase = changePercentage > 0;
          final expensesByCategory = cubit.getExpensesByCategory();

          return SingleChildScrollView(
            child: Column(
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
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppLightColors.wightColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppLightColors.primaryColor),

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
                          Text(
                            '${changePercentage.abs().toStringAsFixed(1)}%',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: increase ? Colors.red : Colors.green,
                            ),
                          ),

                          const SizedBox(width: 6),

                          Text(
                            increase
                                ? 'زيادة عن الشهر السابق'
                                : 'انخفاض عن الشهر السابق',
                            style: TextStyle(
                              fontSize: 14,
                              color: increase ? Colors.red : Colors.green,
                            ),
                          ),

                          const SizedBox(width: 4),

                          Icon(
                            increase
                                ? Icons.arrow_upward
                                : Icons.arrow_downward,
                            size: 18,
                            color: increase ? Colors.red : Colors.green,
                          ),
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
                    border: Border.all(color: AppLightColors.primaryColor),
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
                        color: AppLightColors.primaryNumberColor.withValues(
                          alpha: 0.5,
                        ),
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
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                AnalysisBarChart(income: totalIncome, expense: totalExpense),
                const SizedBox(height: 20),
                AnalysisPieChart(
                  expensesByCategory: expensesByCategory),
              ],
            ),
          );
        },
      ),
    );
  }
}
