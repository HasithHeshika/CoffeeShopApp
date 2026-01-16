import 'package:flutter/material.dart';
import 'models/menu.dart';
import 'models/menu_item.dart';
import 'models/order.dart';
import 'models/customer.dart';
import 'screens/payment_screen.dart';

void main() {
  runApp(const RestaurantOrderApp());
}

class RestaurantOrderApp extends StatelessWidget {
  const RestaurantOrderApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurant Order System',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const RestaurantHomePage(),
    );
  }
}

class RestaurantHomePage extends StatefulWidget {
  const RestaurantHomePage({Key? key}) : super(key: key);

  @override
  State<RestaurantHomePage> createState() => _RestaurantHomePageState();
}

class _RestaurantHomePageState extends State<RestaurantHomePage> {
  late Menu menu;
  late Order currentOrder;
  List<Order> orders = [];
  int orderIdCounter = 1;

  @override
  void initState() {
    super.initState();
    _initializeMenu();
    _createNewOrder();
  }

  void _initializeMenu() {
    menu = Menu(menuId: 1);

    // Add sample menu items
    menu.addMenuItem(MenuItem(
      itemId: 1,
      itemName: 'Burger',
      price: 13.99,
      description: 'Juicy beef burger with fresh vegetables',
    ));
    menu.addMenuItem(MenuItem(
      itemId: 2,
      itemName: 'Pizza',
      price: 20.99,
      description: 'Classic margherita pizza with mozzarella',
    ));
    menu.addMenuItem(MenuItem(
      itemId: 3,
      itemName: 'Pasta',
      price: 15.99,
      description: 'Creamy alfredo pasta with chicken',
    ));
    menu.addMenuItem(MenuItem(
      itemId: 4,
      itemName: 'Salad',
      price: 9.99,
      description: 'Fresh garden salad with mixed greens',
    ));
    menu.addMenuItem(MenuItem(
      itemId: 5,
      itemName: 'Coffee',
      price: 4.99,
      description: 'Freshly brewed coffee',
    ));
  }

  void _createNewOrder() {
    currentOrder = Order(orderId: orderIdCounter++);
  }

  void _addItemToOrder(MenuItem item) {
    setState(() {
      currentOrder.addItem(item);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item.itemName} added to order'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _completeOrder() async {
    if (currentOrder.items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cannot complete empty order'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Navigate to payment screen
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentScreen(order: currentOrder),
      ),
    );

    // If payment was successful
    if (result == true && mounted) {
      setState(() {
        currentOrder.updateStatus('Completed');
        orders.add(currentOrder);
        _createNewOrder();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Order completed successfully!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant Order System'),
        backgroundColor: Colors.orange,
      ),
      body: Column(
        children: [
          // Current Order Section
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Current Order #${currentOrder.orderId}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                if (currentOrder.items.isEmpty)
                  const Text('No items in current order')
                else
                  ...currentOrder.items.map((item) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(item.itemName),
                        Text('\$${item.price.toStringAsFixed(2)}'),
                      ],
                    ),
                  )),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total: \$${currentOrder.totalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _completeOrder,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                      ),
                      child: const Text('Proceed to Payment'),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Menu Section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Menu',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                      itemCount: menu.items.length,
                      itemBuilder: (context, index) {
                        final item = menu.items[index];
                        return Card(
                          child: ListTile(
                            title: Text(item.itemName),
                            subtitle: Text(item.description),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '\$${item.price.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            onTap: () => _addItemToOrder(item),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrderHistoryPage(orders: orders),
            ),
          );
        },
        child: const Icon(Icons.history),
      ),
    );
  }
}

class OrderHistoryPage extends StatelessWidget {
  final List<Order> orders;

  const OrderHistoryPage({Key? key, required this.orders}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order History'),
        backgroundColor: Colors.orange,
      ),
      body: orders.isEmpty
          ? const Center(
              child: Text('No completed orders yet'),
            )
          : ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order #${order.orderId}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text('Status: ${order.status}'),
                        Text('Total: \$${order.totalPrice.toStringAsFixed(2)}'),
                        const SizedBox(height: 8),
                        const Text('Items:'),
                        ...order.items.map((item) => Padding(
                          padding: const EdgeInsets.only(left: 16, top: 2),
                          child: Text('• ${item.itemName}'),
                        )),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
