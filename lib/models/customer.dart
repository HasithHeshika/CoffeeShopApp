import 'menu.dart';
import 'menu_item.dart';
import 'order.dart';
import 'payment.dart';

/// Represents a customer in the system
class Customer {
  final String name;
  final String email;
  final String phone;
  final List<Order> _orderHistory = [];
  final List<String> _notifications = [];

  Customer({required this.name, required this.email, required this.phone});

  /// Browse available menu
  void browseMenu(Menu menu) {
    print('\n${name} is browsing the menu...');
    menu.displayMenu();
  }

  /// Customize an order by adding items
  void customizeOrder({required Order order, required List<MenuItem> items}) {
    print('\n${name} is customizing order #${order.orderId}...');
    for (var item in items) {
      order.addItem(item);
      print('Added: ${item.itemName}');
    }
  }

  /// Place an order
  void placeOrder({required Order order}) {
    if (order.items.isEmpty) {
      print('Cannot place an empty order!');
      return;
    }

    _orderHistory.add(order);
    order.updateStatus('Confirmed');
    print('\n✅ Order #${order.orderId} has been placed by ${name}');
    print('Total: \$${order.totalPrice.toStringAsFixed(2)}');
  }

  /// Make a payment for an order
  bool makePayment({required Payment payment}) {
    print('\n${name} is making a payment...');
    return payment.processPayment();
  }

  /// Receive a notification
  void receiveNotification(String message) {
    _notifications.add(message);
    print('📬 ${name} received: "$message"');
  }

  /// View order history
  void viewOrderHistory() {
    print('\n===== ORDER HISTORY FOR ${name.toUpperCase()} =====');
    if (_orderHistory.isEmpty) {
      print('No orders yet.');
    } else {
      for (var order in _orderHistory) {
        print(order.getOrderDetails());
      }
    }
  }

  /// View all notifications
  void viewNotifications() {
    print('\n===== NOTIFICATIONS FOR ${name.toUpperCase()} =====');
    if (_notifications.isEmpty) {
      print('No notifications.');
    } else {
      for (int i = 0; i < _notifications.length; i++) {
        print('${i + 1}. ${_notifications[i]}');
      }
    }
  }

  /// Get customer details
  String getCustomerDetails() {
    return '''
    Customer: $name
    Email: $email
    Phone: $phone
    Orders: ${_orderHistory.length}
    ''';
  }
}
