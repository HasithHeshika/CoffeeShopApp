import 'package:restaurant_order_system/models/menu.dart';
import 'package:restaurant_order_system/models/menu_item.dart';
import 'package:restaurant_order_system/models/order.dart';
import 'package:restaurant_order_system/models/customer.dart';
import 'package:restaurant_order_system/models/notification.dart';
import 'package:restaurant_order_system/models/card_payment.dart';
import 'package:restaurant_order_system/models/mobile_payment.dart';
import 'package:restaurant_order_system/models/cash_payment.dart';

/// Main entry point demonstrating the restaurant order system
void main() {
  print('🍽️  RESTAURANT ORDER MANAGEMENT SYSTEM 🍽️\n');

  // Create menu and add items
  final menu = Menu(menuId: 1);

  final pizza = MenuItem(
    itemId: 101,
    itemName: 'Margherita Pizza',
    price: 12.99,
    description: 'Classic pizza with tomato sauce and mozzarella',
  );

  final burger = MenuItem(
    itemId: 102,
    itemName: 'Classic Burger',
    price: 8.99,
    description: 'Beef patty with lettuce, tomato, and cheese',
  );

  final pasta = MenuItem(
    itemId: 103,
    itemName: 'Spaghetti Carbonara',
    price: 10.99,
    description: 'Creamy pasta with bacon and parmesan',
  );

  final salad = MenuItem(
    itemId: 104,
    itemName: 'Caesar Salad',
    price: 6.99,
    description: 'Fresh romaine lettuce with Caesar dressing',
  );

  final drink = MenuItem(
    itemId: 105,
    itemName: 'Soft Drink',
    price: 2.99,
    description: 'Refreshing carbonated beverage',
  );

  // Add items to menu
  menu.addMenuItem(pizza);
  menu.addMenuItem(burger);
  menu.addMenuItem(pasta);
  menu.addMenuItem(salad);
  menu.addMenuItem(drink);

  // Create a customer
  final customer = Customer(
    name: 'John Doe',
    email: 'john.doe@email.com',
    phone: '+1234567890',
  );

  // Customer browses menu
  customer.browseMenu(menu);

  // Create an order
  final order1 = Order(orderId: 1001);

  // Customer customizes order
  customer.customizeOrder(order: order1, items: [pizza, drink, salad]);

  // Display order details
  print(order1.getOrderDetails());

  // Customer places the order
  customer.placeOrder(order: order1);

  // Process payment - Card Payment
  final cardPayment = CardPayment(
    paymentId: 5001,
    amount: order1.totalPrice,
    cardNumber: '4532 1234 5678 9012',
    expiryDate: DateTime(2025, 12, 31),
  );

  if (customer.makePayment(payment: cardPayment)) {
    // Send notification about successful payment
    final paymentNotification = Notification(
      notificationId: 9001,
      message:
          'Payment successful! Your order #${order1.orderId} is being prepared.',
    );
    paymentNotification.sendNotification(customer: customer);

    // Update order status
    order1.updateStatus('Preparing');
  }

  // Simulate order ready
  print('\n⏰ Some time passes...\n');
  order1.updateStatus('Ready');

  // Send ready notification
  final readyNotification = Notification(
    notificationId: 9002,
    message: 'Your order #${order1.orderId} is ready for pickup!',
  );
  readyNotification.sendNotification(customer: customer);

  // Create another order to demonstrate mobile payment
  print('\n--- Creating Second Order ---');
  final order2 = Order(orderId: 1002);
  customer.customizeOrder(order: order2, items: [burger, pasta, drink]);
  customer.placeOrder(order: order2);

  // Process with mobile payment
  final mobilePayment = MobilePayment(
    paymentId: 5002,
    amount: order2.totalPrice,
    walletId: 'WALLET123456',
  );
  customer.makePayment(payment: mobilePayment);

  // Create a cash payment example
  print('\n--- Creating Third Order ---');
  final order3 = Order(orderId: 1003);
  customer.customizeOrder(order: order3, items: [salad, drink]);
  customer.placeOrder(order: order3);

  // Process with cash payment
  final cashPayment = CashPayment(paymentId: 5003, amount: order3.totalPrice);
  customer.makePayment(payment: cashPayment);

  // View customer's order history
  customer.viewOrderHistory();

  // View customer's notifications
  customer.viewNotifications();

  // Demonstrate menu search functionality
  print('\n--- Menu Search Demo ---');
  final searchResult = menu.searchItemByName('pizza');
  if (searchResult != null) {
    print('Found item: ${searchResult.getDetails()}');
  }

  // Display customer details
  print(customer.getCustomerDetails());

  print('\n🎉 System demonstration complete! 🎉');
}
