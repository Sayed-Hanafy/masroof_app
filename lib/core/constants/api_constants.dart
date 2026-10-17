class ApiConstants {
  static const String baseUrl = 'http://192.168.1.4/masroof_api';
  static const String login = '$baseUrl/auth/login.php';
  static const String register = '$baseUrl/auth/register.php';
  static const String createTransaction = '$baseUrl/transactions/create.php';
  static const String getCategory = '$baseUrl/categories/get_categories.php';
  static const String getTransactions =
      '$baseUrl/transactions/get_transactions.php';
  static const String updateTransaction =
      '$baseUrl/transactions/update_transaction.php';
  static const String deleteTransaction =
      '$baseUrl/transactions/delete_transaction.php';
}
