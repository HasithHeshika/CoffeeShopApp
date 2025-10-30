import 'payment.dart';

/// Handles mobile wallet payment processing
class MobilePayment extends Payment {
  final String walletId;

  MobilePayment({
    required int paymentId,
    required double amount,
    required this.walletId,
  }) : super(paymentId: paymentId, amount: amount);

  @override
  bool processPayment() {
    print('\n📱 Processing Mobile Payment...');

    // Validate wallet
    if (!_validateWallet()) {
      print('❌ Wallet validation failed!');
      status = 'Failed';
      return false;
    }

    print('Wallet ID: $walletId');
    print('Amount: \$${amount.toStringAsFixed(2)}');

    // Simulate payment processing
    print('Connecting to mobile wallet...');
    print('Verifying balance...');

    // Update status
    status = 'Completed';
    print('✅ Payment successful!');
    return true;
  }

  /// Validate wallet ID
  bool _validateWallet() {
    // Basic validation - check if wallet ID is not empty
    if (walletId.trim().isEmpty) {
      print('Invalid wallet ID');
      return false;
    }

    // Could add more validation rules here
    return true;
  }
}
