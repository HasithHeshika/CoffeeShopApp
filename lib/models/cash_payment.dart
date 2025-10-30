import 'payment.dart';

/// Handles cash payment processing
class CashPayment extends Payment {
  double? changeAmount;

  CashPayment({required int paymentId, required double amount})
    : super(paymentId: paymentId, amount: amount);

  @override
  bool processPayment() {
    print('\n💵 Processing Cash Payment...');
    print('Amount Due: \$${amount.toStringAsFixed(2)}');

    // Simulate receiving cash
    print('Please provide cash to the cashier...');

    // For simulation, assume cash is always received successfully
    double cashReceived = amount + 5.00; // Simulate customer giving extra
    changeAmount = cashReceived - amount;

    print('Cash Received: \$${cashReceived.toStringAsFixed(2)}');
    if (changeAmount! > 0) {
      print('Change: \$${changeAmount!.toStringAsFixed(2)}');
    }

    status = 'Completed';
    print('✅ Payment successful!');
    return true;
  }
}
