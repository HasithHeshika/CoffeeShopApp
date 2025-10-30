/// Abstract base class for payment processing
abstract class Payment {
  final int paymentId;
  final double amount;
  String status = 'Pending';

  Payment({required this.paymentId, required this.amount});

  /// Process the payment (to be implemented by subclasses)
  bool processPayment();

  /// Update payment status
  void updateStatus(String newStatus) {
    status = newStatus;
  }
}
