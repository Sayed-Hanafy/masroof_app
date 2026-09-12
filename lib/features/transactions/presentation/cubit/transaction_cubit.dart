import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:masroof_app/features/transactions/data/models/transaction_data_model.dart';
import 'package:masroof_app/features/transactions/data/models/transaction_model.dart';
import 'package:masroof_app/features/transactions/data/repository/transaction_repository.dart';

part 'transaction_state.dart';

class TransactionCubit extends Cubit<TransactionState> {
  final TransactionRepository transactionRepository;

  TransactionCubit(this.transactionRepository)
    : super(TransactionState(selectedAnalysisMonth: DateTime.now()));

  void selectTransactionType(String type) {
    emit(state.copyWith(selectedType: type));
  }

  void selectDate(DateTime date) {
    emit(state.copyWith(selectedDate: date));
  }

  Future<void> createTransaction(TransactionModel transaction) async {
    emit(
      state.copyWith(status: EnTransactionStatus.loading, clearMessage: true),
    );

    try {
      final response = await transactionRepository.createTransaction(
        transaction,
      );

      if (response.status) {
        emit(
          state.copyWith(
            status: EnTransactionStatus.success,
            message: response.message,
            transactionId: response.transactionId,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: EnTransactionStatus.failure,
            message: response.message,
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: EnTransactionStatus.failure,
          message: 'حدث خطأ أثناء إضافة العملية',
        ),
      );
    }
  }

  Future<void> getTransaction(int userId) async {
    emit(
      state.copyWith(
        getTransactionStatus: EnGetTransactionStatus.loading,
        clearMessage: true,
      ),
    );
    try {
      final response = await transactionRepository.getTransactions(userId);
      final totalIncome = response
          .where((transaction) => transaction.type == 'income')
          .fold<double>(0, (sum, transaction) => sum + transaction.amount);
      final totalExpense = response
          .where((transaction) => transaction.type == 'expense')
          .fold<double>(0, (sum, transaction) => sum + transaction.amount);
      final balance = totalIncome - totalExpense;

      emit(
        state.copyWith(
          getTransactionStatus: EnGetTransactionStatus.success,
          transactions: response,
          totalIncome: totalIncome,
          totalExpense: totalExpense,
          balance: balance,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          getTransactionStatus: EnGetTransactionStatus.failure,
          message: 'حدث خطأ أثناء جلب العمليات',
        ),
      );
    }
  }

  Map<String, double> getExpensesByCategory() {
    final selectedMonth = state.selectedAnalysisMonth;
    final expenses = state.transactions.where(
      (transaction) =>
          transaction.type == 'expense' &&
          DateTime.parse(transaction.transactionDate).year ==
              selectedMonth.year &&
          DateTime.parse(transaction.transactionDate).month ==
              selectedMonth.month,
    );

    final Map<String, double> result = {};

    for (var transaction in expenses) {
      result[transaction.categoryName] =
          (result[transaction.categoryName] ?? 0) + transaction.amount;
    }

    return result;
  }

  double getTotalExpensesForSelectedMonth() {
    final selectedMonth = state.selectedAnalysisMonth;
    final expenses = state.transactions.where(
      (transaction) =>
          transaction.type == 'expense' &&
          DateTime.parse(transaction.transactionDate).year ==
              selectedMonth.year &&
          DateTime.parse(transaction.transactionDate).month ==
              selectedMonth.month,
    );

    return expenses.fold<double>(
      0,
      (sum, transaction) => sum + transaction.amount,
    );
  }

  double getTotalIncomeForSelectedMonth() {
    final selectedMonth = state.selectedAnalysisMonth;
    final incomes = state.transactions.where(
      (transaction) =>
          transaction.type == 'income' &&
          DateTime.parse(transaction.transactionDate).year ==
              selectedMonth.year &&
          DateTime.parse(transaction.transactionDate).month ==
              selectedMonth.month,
    );
    return incomes.fold<double>(
      0,
      (sum, transaction) => sum + transaction.amount,
    );
  }

  double getBalanceForSelectedMonth() {
    final totalIncome = getTotalIncomeForSelectedMonth();
    final totalExpense = getTotalExpensesForSelectedMonth();
    return totalIncome - totalExpense;
  }

  void previousAnalysisMonth() {
    final currentMonth = state.selectedAnalysisMonth;
    final previousMonth = DateTime(currentMonth.year, currentMonth.month - 1);
    emit(state.copyWith(selectedAnalysisMonth: previousMonth));
  }
}
