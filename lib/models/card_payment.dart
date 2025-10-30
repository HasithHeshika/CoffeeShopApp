import 'payment.dart';

/// Handles card payment processing
class CardPayment extends Payment {
  final String cardNumber;
  final DateTime expiryDate;

  CardPayment({
    required int paymentId,
    required double amount,
    required this.cardNumber,
    required this.expiryDate,
  }) : super(paymentId: paymentId, amount: amount);

  @override
  bool processPayment() {
    print('\n💳 Processing Card Payment...');

    // Validate card
    if (!_validateCard()) {
      print('❌ Card validation failed!');
      status = 'Failed';
      return false;
    }

    // Simulate payment processing
    print('Card Number: ${_maskCardNumber()}');
    print('Amount: \$${amount.toStringAsFixed(2)}');

    // Simulate processing delay
    print('Authorizing payment...');

    // Update status
    status = 'Completed';
    print('✅ Payment successful!');
    return true;
  }

  /// Validate card details
  bool _validateCard() {
    // Check if card is expired
    if (expiryDate.isBefore(DateTime.now())) {
      print('Card has expired');
      return false;
    }

    // Basic card number validation (length check)
    if (cardNumber.replaceAll(' ', '').length < 13 ||
        cardNumber.replaceAll(' ', '').length > 19) {
      print('Invalid card number length');
      return false;
    }

    return true;
  }

  /// Mask card number for security
  String _maskCardNumber() {
    final cleanNumber = cardNumber.replaceAll(' ', '');
    if (cleanNumber.length <= 4) return cardNumber;

    final lastFour = cleanNumber.substring(cleanNumber.length - 4);
    return '**** **** **** $lastFour';
  }
}
