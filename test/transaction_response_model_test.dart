import 'package:flutter_test/flutter_test.dart';
import 'package:masroof_app/features/transactions/data/models/transaction_response_model.dart';

void main() {
  test('TransactionResponseModel accepts null transaction_id safely', () {
    final model = TransactionResponseModel.fromJson({
      'status': true,
      'message': 'تم التعديل بنجاح',
      'transaction_id': null,
    });

    expect(model.status, isTrue);
    expect(model.message, 'تم التعديل بنجاح');
    expect(model.transactionId, isNull);
  });
}
