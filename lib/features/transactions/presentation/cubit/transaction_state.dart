part of 'transaction_cubit.dart';

enum EnTransactionStatus { initial, loading, success, failure }

enum EnGetTransactionStatus { initial, loading, success, failure }

class TransactionState extends Equatable {
  final EnTransactionStatus status;
  final EnGetTransactionStatus getTransactionStatus;
  final String? message;
  final int? transactionId;
  final DateTime? selectedDate;
  final String? selectedType;
  final DateTime selectedAnalysisMonth;
  final List<TransactionDataModel> transactions;
  final double totalIncome;
  final double totalExpense;
  final double balance;

  const TransactionState({
    this.status = EnTransactionStatus.initial,
    this.getTransactionStatus = EnGetTransactionStatus.initial,
    this.message,
    this.transactionId,
    this.selectedDate,
    this.selectedType,
    this.transactions = const [],
    this.totalIncome = 0,
    this.totalExpense = 0,
    this.balance = 0,
    required this.selectedAnalysisMonth,
  });

  TransactionState copyWith({
    EnTransactionStatus? status,
    EnGetTransactionStatus? getTransactionStatus,
    String? message,
    int? transactionId,
    DateTime? selectedDate,
    String? selectedType,
    DateTime? selectedAnalysisMonth,
    List<TransactionDataModel>? transactions,
    bool clearMessage = false,
    bool clearTransactionId = false,
    bool clearSelectedDate = false,
    bool clearSelectedType = false,
    double? totalIncome,
    double? totalExpense,
    double? balance,
  }) {
    return TransactionState(
      status: status ?? this.status,
      getTransactionStatus: getTransactionStatus ?? this.getTransactionStatus,
      message: clearMessage ? null : message ?? this.message,
      transactionId:
          clearTransactionId ? null : transactionId ?? this.transactionId,
      selectedDate:
          clearSelectedDate ? null : selectedDate ?? this.selectedDate,
      selectedType:
          clearSelectedType ? null : selectedType ?? this.selectedType,
      selectedAnalysisMonth:
          selectedAnalysisMonth ?? this.selectedAnalysisMonth,
      transactions: transactions ?? this.transactions,
      totalExpense: totalExpense ?? this.totalExpense,
      totalIncome: totalIncome ?? this.totalIncome,
      balance: balance ?? this.balance,
    );
  }

  @override
  List<Object?> get props => [
    status,
    message,
    transactionId,
    selectedAnalysisMonth,
    selectedDate,
    selectedType,
    transactions,
    getTransactionStatus,
    totalIncome,
    totalExpense,
    balance,
  ];
}
