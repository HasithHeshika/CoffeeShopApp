import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'models/menu.dart';
import 'models/menu_item.dart';
import 'models/order.dart';
import 'screens/customization_screen.dart';
import 'screens/payment_screen.dart';
import 'screens/login_screen.dart';
import 'services/auth_service.dart';
import 'services/database_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyC1xpNLXMvnXuv0-5eRG4NLLKQUtJUGY_w',
      appId: '1:566874315355:web:c88cdf54c7f798f845fd7e',
      messagingSenderId: '566874315355',
      projectId: 'coffee-shop-app-d8513',
      storageBucket: 'coffee-shop-app-d8513.firebasestorage.app',
    ),
  );
  runApp(const RestaurantOrderApp());
}

class RestaurantOrderApp extends StatelessWidget {
  const RestaurantOrderApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coffee Shop App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.brown,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const CoffeeShopHomePage(),
    );
  }
}

class CoffeeShopHomePage extends StatefulWidget {
  const CoffeeShopHomePage({Key? key}) : super(key: key);

  @override
  State<CoffeeShopHomePage> createState() => _CoffeeShopHomePageState();
}

class _CoffeeShopHomePageState extends State<CoffeeShopHomePage> {
  late Menu menu;
  late Order currentOrder;
  List<Order> orders = [];
  int orderIdCounter = 1;
  String searchQuery = '';
  Set<int> favoriteItemIds = {};
  String selectedCategory = 'All';
  bool hasUnreadNotifications = true;

  final AuthService _authService = AuthService();
  final DatabaseService _databaseService = DatabaseService();

  @override
  void initState() {
    super.initState();
    _initializeMenu();
    _createNewOrder();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    if (_authService.isLoggedIn()) {
      final favorites = await _databaseService.loadFavorites();
      setState(() {
        favoriteItemIds = favorites;
      });
    }
  }

  void _initializeMenu() {
    menu = Menu(menuId: 1);

    // Common add-ons
    const milkOptions = [
      AddOn(name: 'Whole Milk', price: 0.0, category: 'Milk'),
      AddOn(name: 'Oat Milk', price: 0.75, category: 'Milk'),
      AddOn(name: 'Almond Milk', price: 0.75, category: 'Milk'),
      AddOn(name: 'Soy Milk', price: 0.50, category: 'Milk'),
    ];

    const extras = [
      AddOn(name: 'Extra Shot', price: 1.0, category: 'Extra Shot'),
      AddOn(name: 'Whipped Cream', price: 0.75, category: 'Topping'),
      AddOn(name: 'Caramel Drizzle', price: 0.50, category: 'Topping'),
      AddOn(name: 'Chocolate Syrup', price: 0.50, category: 'Topping'),
      AddOn(name: 'Vanilla Syrup', price: 0.50, category: 'Sweetener'),
      AddOn(name: 'Hazelnut Syrup', price: 0.50, category: 'Sweetener'),
    ];

    // Coffee drinks
    menu.addMenuItem(MenuItem(
      itemId: 1,
      itemName: 'Espresso',
      price: 3.50,
      description: 'Rich and bold espresso shot',
      category: 'Coffee',
      availableSizes: ['Single', 'Double'],
      sizeUpcharges: {'Double': 1.50},
      availableAddOns: [...extras],
      imageUrl:
          'https://images.unsplash.com/photo-1510591509098-f4fdc6d0ff04?w=400',
    ));

    menu.addMenuItem(MenuItem(
      itemId: 2,
      itemName: 'Cappuccino',
      price: 4.50,
      description: 'Espresso with steamed milk and foam',
      category: 'Coffee',
      availableAddOns: [...milkOptions, ...extras],
      imageUrl:
          'https://images.unsplash.com/photo-1572442388796-11668a67e53d?w=400',
    ));

    menu.addMenuItem(MenuItem(
      itemId: 3,
      itemName: 'Latte',
      price: 4.99,
      description: 'Smooth espresso with steamed milk',
      category: 'Coffee',
      availableAddOns: [...milkOptions, ...extras],
      imageUrl:
          'https://images.unsplash.com/photo-1561882468-9110e03e0f78?w=400',
    ));

    menu.addMenuItem(MenuItem(
      itemId: 4,
      itemName: 'Americano',
      price: 3.99,
      description: 'Espresso with hot water',
      category: 'Coffee',
      availableAddOns: [...milkOptions, ...extras],
      imageUrl:
          'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?w=400',
    ));

    menu.addMenuItem(MenuItem(
      itemId: 5,
      itemName: 'Mocha',
      price: 5.49,
      description: 'Espresso, chocolate, and steamed milk',
      category: 'Coffee',
      availableAddOns: [...milkOptions, ...extras],
      imageUrl:
          'https://images.unsplash.com/photo-1511920170033-f8396924c348?w=400',
    ));

    menu.addMenuItem(MenuItem(
      itemId: 6,
      itemName: 'Caramel Macchiato',
      price: 5.99,
      description: 'Espresso with vanilla, milk, and caramel',
      category: 'Coffee',
      availableAddOns: [...milkOptions, ...extras],
      imageUrl:
          'https://images.unsplash.com/photo-1599639957043-f3aa5c986398?w=400',
    ));

    // Cold drinks
    menu.addMenuItem(MenuItem(
      itemId: 7,
      itemName: 'Iced Coffee',
      price: 4.25,
      description: 'Cold brewed coffee over ice',
      category: 'Cold Drinks',
      availableAddOns: [...milkOptions, ...extras],
      imageUrl:
          'https://images.unsplash.com/photo-1517487881594-2787fef5ebf7?w=400',
    ));

    menu.addMenuItem(MenuItem(
      itemId: 8,
      itemName: 'Frappuccino',
      price: 5.99,
      description: 'Blended ice coffee drink',
      category: 'Cold Drinks',
      availableAddOns: [...extras],
      imageUrl:
          'https://images.unsplash.com/photo-1662047102608-a6f2e492411f?w=400',
    ));

    // Tea
    menu.addMenuItem(MenuItem(
      itemId: 9,
      itemName: 'Green Tea',
      price: 3.50,
      description: 'Fresh brewed green tea',
      category: 'Tea',
      availableAddOns: [
        const AddOn(name: 'Honey', price: 0.50, category: 'Sweetener'),
        const AddOn(name: 'Lemon', price: 0.25, category: 'Extra'),
      ],
      imageUrl:
          'https://images.unsplash.com/photo-1556679343-c7306c1976bc?w=400',
    ));

    menu.addMenuItem(MenuItem(
      itemId: 10,
      itemName: 'Chai Latte',
      price: 4.75,
      description: 'Spiced tea with steamed milk',
      category: 'Tea',
      availableAddOns: [...milkOptions],
      imageUrl:
          'https://images.unsplash.com/photo-1564890369478-c89ca6d9cde9?w=400',
    ));

    // Pastries
    menu.addMenuItem(MenuItem(
      itemId: 11,
      itemName: 'Croissant',
      price: 3.50,
      description: 'Buttery, flaky French pastry',
      category: 'Pastry',
      availableSizes: ['Regular'],
      sizeUpcharges: {},
      availableAddOns: [],
      imageUrl:
          'https://images.unsplash.com/photo-1555507036-ab1f4038808a?w=400',
    ));

    menu.addMenuItem(MenuItem(
      itemId: 12,
      itemName: 'Blueberry Muffin',
      price: 3.99,
      description: 'Fresh baked muffin with blueberries',
      category: 'Pastry',
      availableSizes: ['Regular'],
      sizeUpcharges: {},
      availableAddOns: [],
      imageUrl:
          'https://images.unsplash.com/photo-1607958996333-41aef7caefaa?w=400',
    ));

    menu.addMenuItem(MenuItem(
      itemId: 13,
      itemName: 'Chocolate Chip Cookie',
      price: 2.50,
      description: 'Classic chocolate chip cookie',
      category: 'Pastry',
      availableSizes: ['Regular'],
      sizeUpcharges: {},
      availableAddOns: [],
      imageUrl:
          'https://images.unsplash.com/photo-1499636136210-6f4ee915583e?w=400',
    ));

    // Sandwiches
    menu.addMenuItem(MenuItem(
      itemId: 14,
      itemName: 'Turkey Panini',
      price: 7.99,
      description: 'Grilled turkey sandwich with cheese',
      category: 'Food',
      availableSizes: ['Regular'],
      sizeUpcharges: {},
      availableAddOns: [],
      imageUrl:
          'https://images.unsplash.com/photo-1528735602780-2552fd46c7af?w=400',
    ));

    menu.addMenuItem(MenuItem(
      itemId: 15,
      itemName: 'Veggie Wrap',
      price: 6.99,
      description: 'Fresh vegetables in a soft tortilla',
      category: 'Food',
      availableSizes: ['Regular'],
      sizeUpcharges: {},
      availableAddOns: [],
      imageUrl:
          'https://images.unsplash.com/photo-1626700051175-6818013e1d4f?w=400',
    ));
  }

  void _createNewOrder() {
    currentOrder = Order(orderId: orderIdCounter++);
  }

  void _addItemToOrder(MenuItem item) async {
    final customizedItem = await Navigator.push<CustomizedMenuItem>(
      context,
      MaterialPageRoute(
        builder: (context) => CustomizationScreen(menuItem: item),
      ),
    );

    if (customizedItem != null) {
      setState(() {
        currentOrder.addItem(customizedItem);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${item.itemName} added to order'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _completeOrder() async {
    if (!_authService.isLoggedIn()) {
      // Show login screen if not authenticated
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );

      // Reload user data after login
      if (_authService.isLoggedIn()) {
        await _loadUserData();
      } else {
        return; // User didn't log in, cancel order
      }
    }

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
    final paymentSuccess = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentScreen(order: currentOrder),
      ),
    );

    if (paymentSuccess == true && mounted) {
      setState(() {
        currentOrder.updateStatus('Preparing');
        orders.add(currentOrder);
      });

      // Save order to database
      await _databaseService.saveOrder(currentOrder);

      setState(() {
        _createNewOrder();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Order placed successfully! ☕'),
          backgroundColor: Colors.green,
        ),
      );

      // Simulate notification after delay
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('🔔 Your order is being prepared'),
              duration: Duration(seconds: 3),
            ),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.brown[800]!, Colors.brown[600]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                '☕',
                style: TextStyle(fontSize: 24),
              ),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Coffee Shop',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Fresh & Delicious',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined, size: 28),
                color: Colors.white,
                onPressed: () {
                  setState(() {
                    hasUnreadNotifications = false;
                  });
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      title: Row(
                        children: [
                          Icon(Icons.notifications, color: Colors.brown[700]),
                          const SizedBox(width: 8),
                          const Text('Notifications'),
                        ],
                      ),
                      content: Container(
                        decoration: BoxDecoration(
                          color: Colors.brown[50]!.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildNotificationItem(
                              '☕ Welcome!',
                              'Get 10% off your first order today!',
                            ),
                            const Divider(),
                            _buildNotificationItem(
                              '🎉 New Item',
                              'Try our new Caramel Macchiato!',
                            ),
                            const Divider(),
                            _buildNotificationItem(
                              '⏰ Limited Time',
                              'Happy Hour: Buy 1 Get 1 Free from 2-4 PM',
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            'Close',
                            style: TextStyle(color: Colors.brown[700]),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              if (hasUnreadNotifications)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: const Text(
                      '3',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 8), // User profile / Sign in button
          IconButton(
            icon: Icon(
              _authService.isLoggedIn() ? Icons.person : Icons.login,
              size: 28,
              color: Colors.white,
            ),
            onPressed: () async {
              if (_authService.isLoggedIn()) {
                // Show profile menu
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    title: Row(
                      children: [
                        Icon(Icons.person, color: Colors.brown[700]),
                        const SizedBox(width: 8),
                        const Text('Profile'),
                      ],
                    ),
                    content: Container(
                      decoration: BoxDecoration(
                        color: Colors.brown[50]!.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome, ${_authService.getUserName()}!',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text('Email: ${_authService.currentUser?.email}'),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () async {
                          await _authService.signOut();
                          setState(() {
                            favoriteItemIds.clear();
                          });
                          if (mounted) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Signed out successfully'),
                              ),
                            );
                          }
                        },
                        child: Text(
                          'Sign Out',
                          style: TextStyle(color: Colors.red[700]),
                        ),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Close',
                          style: TextStyle(color: Colors.brown[700]),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                // Navigate to login screen
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
                // Reload data after login
                if (_authService.isLoggedIn()) {
                  await _loadUserData();
                  setState(() {});
                }
              }
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Current Order Section
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.brown[50]!.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.brown[200]!),
              boxShadow: [
                BoxShadow(
                  color: Colors.brown.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
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
                  ...currentOrder.items.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              '${item.quantity}x ${item.menuItem.itemName} (${item.selectedSize})',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                          Text(
                            '\$${item.getTotalPrice().toStringAsFixed(2)}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline,
                                size: 20),
                            onPressed: () {
                              setState(() {
                                currentOrder.removeItemAt(index);
                              });
                            },
                          ),
                        ],
                      ),
                    );
                  }).toList(),
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
                        backgroundColor: Colors.brown[700],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Complete Order'),
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
                  // Search Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search coffee, pastries...',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  setState(() {
                                    searchQuery = '';
                                  });
                                },
                              )
                            : null,
                        filled: true,
                        fillColor: Colors.grey[50],
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.grey[300]!,
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.brown[700]!,
                            width: 1.5,
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                      },
                    ),
                  ),

                  // Category Filter Chips
                  SizedBox(
                    height: 50,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildCategoryChip('All'),
                        _buildCategoryChip('Coffee'),
                        _buildCategoryChip('Cold Drinks'),
                        _buildCategoryChip('Tea'),
                        _buildCategoryChip('Pastry'),
                        _buildCategoryChip('Food'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),
                  const Text(
                    'Menu',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,
                        childAspectRatio: 1.0,
                        crossAxisSpacing: 6,
                        mainAxisSpacing: 6,
                      ),
                      itemCount: _filteredMenuItems.length,
                      itemBuilder: (context, index) {
                        final item = _filteredMenuItems[index];
                        final isFavorite = favoriteItemIds.contains(index);

                        return Card(
                          elevation: 4,
                          shadowColor: Colors.brown.withOpacity(0.2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: InkWell(
                            onTap: () => _addItemToOrder(item),
                            borderRadius: BorderRadius.circular(12),
                            splashColor: Colors.brown.withOpacity(0.1),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Image with favorite button
                                Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(12),
                                      ),
                                      child: Image.network(
                                        item.imageUrl,
                                        height: 70,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Container(
                                            height: 70,
                                            color: Colors.grey[300],
                                            child: const Icon(
                                              Icons.coffee,
                                              size: 25,
                                              color: Colors.grey,
                                            ),
                                          );
                                        },
                                        loadingBuilder:
                                            (context, child, loadingProgress) {
                                          if (loadingProgress == null)
                                            return child;
                                          return Container(
                                            height: 70,
                                            color: Colors.grey[200],
                                            child: Center(
                                              child: CircularProgressIndicator(
                                                value: loadingProgress
                                                            .expectedTotalBytes !=
                                                        null
                                                    ? loadingProgress
                                                            .cumulativeBytesLoaded /
                                                        loadingProgress
                                                            .expectedTotalBytes!
                                                    : null,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    Positioned(
                                      top: 4,
                                      right: 4,
                                      child: CircleAvatar(
                                        backgroundColor: Colors.white,
                                        radius: 15,
                                        child: IconButton(
                                          icon: Icon(
                                            isFavorite
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            color: isFavorite
                                                ? Colors.red
                                                : Colors.grey,
                                            size: 16,
                                          ),
                                          padding: EdgeInsets.zero,
                                          onPressed: () async {
                                            if (!_authService.isLoggedIn()) {
                                              // Prompt user to login
                                              await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const LoginScreen(),
                                                ),
                                              );
                                              if (_authService.isLoggedIn()) {
                                                await _loadUserData();
                                                setState(() {});
                                              }
                                              return;
                                            }

                                            setState(() {
                                              if (isFavorite) {
                                                favoriteItemIds.remove(index);
                                              } else {
                                                favoriteItemIds.add(index);
                                              }
                                            });

                                            // Save favorites to database
                                            await _databaseService
                                                .saveFavorites(favoriteItemIds);
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                // Item details
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.itemName,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        '\$${item.price.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          color: Colors.brown,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
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
        backgroundColor: Colors.brown[700],
        foregroundColor: Colors.white,
        elevation: 4,
        child: const Icon(Icons.history),
      ),
    );
  }

  // Helper method to get filtered menu items based on search and category
  List<MenuItem> get _filteredMenuItems {
    List<MenuItem> filtered = menu.items;

    // Apply category filter
    if (selectedCategory != 'All') {
      filtered =
          filtered.where((item) => item.category == selectedCategory).toList();
    }

    // Apply search filter
    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((item) {
        return item.itemName
                .toLowerCase()
                .contains(searchQuery.toLowerCase()) ||
            item.description
                .toLowerCase()
                .contains(searchQuery.toLowerCase()) ||
            item.category.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
    }

    return filtered;
  }

  // Helper method to build category filter chips
  Widget _buildCategoryChip(String category) {
    final isSelected = selectedCategory == category;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(category),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            selectedCategory = category;
          });
        },
        backgroundColor: Colors.grey[50],
        selectedColor: Colors.brown[700],
        elevation: isSelected ? 2 : 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black87,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildNotificationItem(String title, String message) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            message,
            style: const TextStyle(fontSize: 14),
          ),
        ],
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
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.brown[800]!, Colors.brown[600]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text('Order History'),
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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  color: Colors.brown[50]!.withOpacity(0.2),
                  elevation: 2,
                  shadowColor: Colors.brown.withOpacity(0.2),
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
                              child: Text(
                                  '• ${item.menuItem.itemName} (${item.selectedSize})'),
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
