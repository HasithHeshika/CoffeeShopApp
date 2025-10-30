import 'menu_item.dart';

/// Represents a customer order
class Order {
  final int orderId;
  double totalPrice = 0.0;
  String status = 'Pending';
  final List<MenuItem> _items = [];
  final DateTime orderTime;

  Order({required this.orderId}) : orderTime = DateTime.now();

  /// Add an item to the order
  void addItem(MenuItem item) {
    _items.add(item);
    _recalculateTotal();
  }

  /// Remove an item from the order
  bool removeItem(int itemId) {
    final initialLength = _items.length;
    _items.removeWhere((item) => item.itemId == itemId);
    final removed = _items.length < initialLength;
    if (removed) _recalculateTotal();
    return removed;
  }

  /// Calculate the total price of the order
  double calculateTotal() {
    return _items.fold(0.0, (sum, item) => sum + item.price);
  }

  /// Recalculate total when items change
  void _recalculateTotal() {
    totalPrice = calculateTotal();
  }

  /// Update the status of the order
  void updateStatus(String newStatus) {
    final validStatuses = [
      'Pending',
      'Confirmed',
      'Preparing',
      'Ready',
      'Delivered',
      'Cancelled',
    ];
    if (validStatuses.contains(newStatus)) {
      status = newStatus;
      print('Order #$orderId status updated to: $status');
    } else {
      print('Invalid status. Valid statuses are: ${validStatuses.join(', ')}');
    }
  }

  /// Get order details
  String getOrderDetails() {
    final buffer = StringBuffer();
    buffer.writeln('\n===== ORDER DETAILS =====');
    buffer.writeln('Order ID: $orderId');
    buffer.writeln('Status: $status');
    buffer.writeln('Order Time: ${orderTime.toString()}');
    buffer.writeln('Items:');

    if (_items.isEmpty) {
      buffer.writeln('  No items in order');
    } else {
      for (var item in _items) {
        buffer.writeln(
          '  - ${item.itemName}: \$${item.price.toStringAsFixed(2)}',
        );
      }
    }

    buffer.writeln('Total: \$${totalPrice.toStringAsFixed(2)}');
    buffer.writeln('========================');
    return buffer.toString();
  }

  /// Get list of ordered items
  List<MenuItem> get items => List.unmodifiable(_items);
}
