import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masroof_app/features/transactions/presentation/cubit/transaction_cubit.dart';

class AnalysisScreen extends StatelessWidget {
  const AnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تحليل المصروفات')),
      body: BlocBuilder<TransactionCubit, TransactionState>(
        builder: (context, state) {
          final expensesByCategory =
              context.read<TransactionCubit>().getExpensesByCategory();
          if (state.totalExpense == 0) {
            return const Center(child: Text('لا يوجد مصاريف'));
          }

          return ListView(
            children:
                expensesByCategory.entries.map((entry) {
                  final percentage = (entry.value / state.totalExpense) * 100;
                  return ListTile(
                    title: Text(entry.key),
                    subtitle: Text('${percentage.toStringAsFixed(2)}%'),
                    trailing: Text('${entry.value.toStringAsFixed(2)} EGP'),
                  );
                }).toList(),
          );
        },
      ),
    );
  }
}
