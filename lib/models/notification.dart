import 'customer.dart';

/// Handles notifications in the system
class Notification {
  final int notificationId;
  final String message;
  final DateTime date;

  Notification({required this.notificationId, required this.message})
    : date = DateTime.now();

  /// Send notification to a customer
  void sendNotification({required Customer customer}) {
    print('\n📧 NOTIFICATION SENT');
    print('To: ${customer.name} (${customer.email})');
    print('Message: $message');
    print('Sent at: $date');

    // Notify the customer
    customer.receiveNotification(message);
  }

  @override
  String toString() {
    return 'Notification #$notificationId: $message (${date.toString()})';
  }
}
