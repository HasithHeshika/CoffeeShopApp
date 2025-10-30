import 'package:restaurant_order_system/restaurant_order_system.dart';
import 'package:test/test.dart';

void main() {
  group('MenuItem Tests', () {
    test('should create a menu item with correct properties', () {
      final item = MenuItem(
        itemId: 1,
        itemName: 'Test Pizza',
        price: 15.99,
        description: 'A delicious test pizza',
      );

      expect(item.itemId, equals(1));
      expect(item.itemName, equals('Test Pizza'));
      expect(item.price, equals(15.99));
      expect(item.description, equals('A delicious test pizza'));
    });

    test('should return correct string representation', () {
      final item = MenuItem(
        itemId: 1,
        itemName: 'Test Pizza',
        price: 15.99,
        description: 'A delicious test pizza',
      );

      expect(item.toString(), equals('Test Pizza - \$15.99'));
    });
  });

  group('Menu Tests', () {
    late Menu menu;

    setUp(() {
      menu = Menu(menuId: 1);
    });

    test('should create a menu with correct ID', () {
      expect(menu.menuId, equals(1));
      expect(menu.items, isEmpty);
    });

    test('should add items to menu', () {
      final item = MenuItem(
        itemId: 1,
        itemName: 'Test Pizza',
        price: 15.99,
        description: 'A delicious test pizza',
      );

      menu.addMenuItem(item);
      expect(menu.items.length, equals(1));
      expect(menu.items.first, equals(item));
    });

    test('should remove items from menu', () {
      final item = MenuItem(
        itemId: 1,
        itemName: 'Test Pizza',
        price: 15.99,
        description: 'A delicious test pizza',
      );

      menu.addMenuItem(item);
      expect(menu.items.length, equals(1));

      final removed = menu.removeMenuItem(1);
      expect(removed, isTrue);
      expect(menu.items.length, equals(0));
    });

    test('should return false when removing non-existent item', () {
      final removed = menu.removeMenuItem(999);
      expect(removed, isFalse);
    });

    test('should search items by name', () {
      final pizza = MenuItem(
        itemId: 1,
        itemName: 'Margherita Pizza',
        price: 12.99,
        description: 'Classic pizza',
      );
      final burger = MenuItem(
        itemId: 2,
        itemName: 'Beef Burger',
        price: 8.99,
        description: 'Juicy burger',
      );

      menu.addMenuItem(pizza);
      menu.addMenuItem(burger);

      final found = menu.searchItemByName('pizza');
      expect(found, isNotNull);
      expect(found!.itemName, equals('Margherita Pizza'));

      final notFound = menu.searchItemByName('taco');
      expect(notFound, isNull);
    });

    test('should search items by ID', () {
      final item = MenuItem(
        itemId: 1,
        itemName: 'Test Pizza',
        price: 15.99,
        description: 'A delicious test pizza',
      );

      menu.addMenuItem(item);

      final found = menu.searchItemById(1);
      expect(found, isNotNull);
      expect(found!.itemId, equals(1));

      final notFound = menu.searchItemById(999);
      expect(notFound, isNull);
    });
  });

  group('Order Tests', () {
    late Order order;
    late MenuItem pizza;
    late MenuItem burger;

    setUp(() {
      order = Order(orderId: 1);
      pizza = MenuItem(
        itemId: 1,
        itemName: 'Pizza',
        price: 12.99,
        description: 'Delicious pizza',
      );
      burger = MenuItem(
        itemId: 2,
        itemName: 'Burger',
        price: 8.99,
        description: 'Tasty burger',
      );
    });

    test('should create an order with correct properties', () {
      expect(order.orderId, equals(1));
      expect(order.totalPrice, equals(0.0));
      expect(order.status, equals('Pending'));
      expect(order.items, isEmpty);
    });

    test('should add items to order and calculate total', () {
      order.addItem(pizza);
      order.addItem(burger);

      expect(order.items.length, equals(2));
      expect(order.totalPrice, equals(21.98));
    });

    test('should remove items from order and recalculate total', () {
      order.addItem(pizza);
      order.addItem(burger);
      expect(order.totalPrice, equals(21.98));

      final removed = order.removeItem(1);
      expect(removed, isTrue);
      expect(order.items.length, equals(1));
      expect(order.totalPrice, equals(8.99));
    });

    test('should return false when removing non-existent item', () {
      order.addItem(pizza);

      final removed = order.removeItem(999);
      expect(removed, isFalse);
      expect(order.items.length, equals(1));
    });

    test('should update order status with valid statuses', () {
      order.updateStatus('Confirmed');
      expect(order.status, equals('Confirmed'));

      order.updateStatus('Preparing');
      expect(order.status, equals('Preparing'));

      order.updateStatus('Ready');
      expect(order.status, equals('Ready'));
    });

    test('should not update status with invalid status', () {
      final originalStatus = order.status;
      order.updateStatus('InvalidStatus');
      expect(order.status, equals(originalStatus));
    });

    test('should calculate total correctly', () {
      order.addItem(pizza);
      order.addItem(burger);

      final total = order.calculateTotal();
      expect(total, equals(21.98));
      expect(total, equals(order.totalPrice));
    });
  });

  group('Customer Tests', () {
    late Customer customer;
    late Menu menu;
    late MenuItem pizza;

    setUp(() {
      customer = Customer(
        name: 'John Doe',
        email: 'john@example.com',
        phone: '+1234567890',
      );
      menu = Menu(menuId: 1);
      pizza = MenuItem(
        itemId: 1,
        itemName: 'Pizza',
        price: 12.99,
        description: 'Delicious pizza',
      );
      menu.addMenuItem(pizza);
    });

    test('should create a customer with correct properties', () {
      expect(customer.name, equals('John Doe'));
      expect(customer.email, equals('john@example.com'));
      expect(customer.phone, equals('+1234567890'));
    });

    test('should place an order successfully', () {
      final order = Order(orderId: 1);
      order.addItem(pizza);

      customer.placeOrder(order: order);
      expect(order.status, equals('Confirmed'));
    });
  });

  group('Payment Tests', () {
    test('CardPayment should process payment successfully', () {
      final payment = CardPayment(
        paymentId: 1,
        amount: 25.99,
        cardNumber: '4532 1234 5678 9012',
        expiryDate: DateTime(2025, 12, 31),
      );

      final result = payment.processPayment();
      expect(result, isTrue);
      expect(payment.status, equals('Completed'));
    });

    test('CardPayment should fail with expired card', () {
      final payment = CardPayment(
        paymentId: 1,
        amount: 25.99,
        cardNumber: '4532 1234 5678 9012',
        expiryDate: DateTime(2020, 12, 31), // Expired
      );

      final result = payment.processPayment();
      expect(result, isFalse);
      expect(payment.status, equals('Failed'));
    });

    test('CashPayment should process payment successfully', () {
      final payment = CashPayment(
        paymentId: 1,
        amount: 15.50,
      );

      final result = payment.processPayment();
      expect(result, isTrue);
      expect(payment.status, equals('Completed'));
    });

    test('MobilePayment should process payment successfully', () {
      final payment = MobilePayment(
        paymentId: 1,
        amount: 20.00,
        walletId: 'WALLET123',
      );

      final result = payment.processPayment();
      expect(result, isTrue);
      expect(payment.status, equals('Completed'));
    });
  });

  group('Notification Tests', () {
    test('should create a notification with correct properties', () {
      final notification = Notification(
        notificationId: 1,
        message: 'Test message',
      );

      expect(notification.notificationId, equals(1));
      expect(notification.message, equals('Test message'));
    });
  });
}
