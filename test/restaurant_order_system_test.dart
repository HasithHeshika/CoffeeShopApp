import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_order_system/restaurant_order_system.dart';

void main() {
  group('MenuItem Tests', () {
    test('should create a menu item with correct properties', () {
      final item = MenuItem(
        itemId: 1,
        itemName: 'Cappuccino',
        price: 4.50,
        description: 'Espresso with steamed milk and foam',
        category: 'Coffee',
      );

      expect(item.itemId, equals(1));
      expect(item.itemName, equals('Cappuccino'));
      expect(item.price, equals(4.50));
      expect(item.description, equals('Espresso with steamed milk and foam'));
      expect(item.category, equals('Coffee'));
    });

    test('should calculate price with size upcharge', () {
      final item = MenuItem(
        itemId: 1,
        itemName: 'Latte',
        price: 4.99,
        description: 'Smooth espresso with steamed milk',
        category: 'Coffee',
        availableSizes: ['Small', 'Medium', 'Large'],
        sizeUpcharges: {'Medium': 1.0, 'Large': 2.0},
      );

      expect(item.getPriceForSize('Small'), equals(4.99));
      expect(item.getPriceForSize('Medium'), equals(5.99));
      expect(item.getPriceForSize('Large'), equals(6.99));
    });

    test('should return correct string representation', () {
      final item = MenuItem(
        itemId: 1,
        itemName: 'Espresso',
        price: 3.50,
        description: 'Rich and bold espresso shot',
        category: 'Coffee',
      );

      expect(item.toString(), equals('Espresso - \$3.50'));
    });
  });

  group('CustomizedMenuItem Tests', () {
    test('should calculate total price with add-ons', () {
      final menuItem = MenuItem(
        itemId: 1,
        itemName: 'Latte',
        price: 4.99,
        description: 'Smooth espresso with steamed milk',
        category: 'Coffee',
        availableAddOns: [
          const AddOn(name: 'Extra Shot', price: 1.0, category: 'Extra Shot'),
          const AddOn(name: 'Oat Milk', price: 0.75, category: 'Milk'),
        ],
      );

      final customizedItem = CustomizedMenuItem(
        menuItem: menuItem,
        selectedSize: 'Medium',
        selectedAddOns: [
          const AddOn(name: 'Extra Shot', price: 1.0, category: 'Extra Shot'),
          const AddOn(name: 'Oat Milk', price: 0.75, category: 'Milk'),
        ],
        quantity: 2,
      );

      // Base: 4.99 + Medium upcharge: 1.0 + Extra Shot: 1.0 + Oat Milk: 0.75 = 7.74
      // Times 2: 15.48
      expect(customizedItem.getTotalPrice(), equals(15.48));
    });

    test('should generate correct description', () {
      final menuItem = MenuItem(
        itemId: 1,
        itemName: 'Cappuccino',
        price: 4.50,
        description: 'Espresso with steamed milk and foam',
        category: 'Coffee',
      );

      final customizedItem = CustomizedMenuItem(
        menuItem: menuItem,
        selectedSize: 'Large',
        selectedAddOns: [
          const AddOn(
              name: 'Vanilla Syrup', price: 0.50, category: 'Sweetener'),
        ],
        specialInstructions: 'Extra hot',
        quantity: 1,
      );

      final description = customizedItem.getDescription();
      expect(description, contains('Cappuccino (Large)'));
      expect(description, contains('Vanilla Syrup'));
      expect(description, contains('Extra hot'));
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
    late CustomizedMenuItem customCappuccino;
    late CustomizedMenuItem customLatte;

    setUp(() {
      order = Order(orderId: 1);

      final cappuccino = MenuItem(
        itemId: 1,
        itemName: 'Cappuccino',
        price: 4.50,
        description: 'Espresso with steamed milk and foam',
        category: 'Coffee',
      );

      final latte = MenuItem(
        itemId: 2,
        itemName: 'Latte',
        price: 4.99,
        description: 'Smooth espresso with steamed milk',
        category: 'Coffee',
      );

      customCappuccino = CustomizedMenuItem(
        menuItem: cappuccino,
        selectedSize: 'Medium',
        quantity: 1,
      );

      customLatte = CustomizedMenuItem(
        menuItem: latte,
        selectedSize: 'Large',
        selectedAddOns: [
          const AddOn(name: 'Extra Shot', price: 1.0, category: 'Extra Shot'),
        ],
        quantity: 2,
      );
    });

    test('should create an order with correct properties', () {
      expect(order.orderId, equals(1));
      expect(order.totalPrice, equals(0.0));
      expect(order.status, equals('Pending'));
      expect(order.items, isEmpty);
    });

    test('should add items to order and calculate total', () {
      order.addItem(customCappuccino);
      order.addItem(customLatte);

      expect(order.items.length, equals(2));
      // Cappuccino Medium: 4.50 + 1.0 = 5.50
      // Latte Large x2: (4.99 + 2.0 + 1.0) * 2 = 15.98
      // Total: 5.50 + 15.98 = 21.48
      expect(order.totalPrice, equals(21.48));
    });

    test('should remove items from order by index and recalculate total', () {
      order.addItem(customCappuccino);
      order.addItem(customLatte);
      expect(order.totalPrice, equals(21.48));

      final removed = order.removeItemAt(0);
      expect(removed, isTrue);
      expect(order.items.length, equals(1));
      expect(order.totalPrice, equals(15.98));
    });

    test('should return false when removing with invalid index', () {
      order.addItem(customCappuccino);

      final removed = order.removeItemAt(999);
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
      order.addItem(customCappuccino);
      order.addItem(customLatte);

      final total = order.calculateTotal();
      expect(total, equals(21.48));
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
      final customPizza = CustomizedMenuItem(
        menuItem: pizza,
        selectedSize: 'Regular',
        quantity: 1,
      );
      order.addItem(customPizza);

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
