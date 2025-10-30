import 'menu_item.dart';

/// Manages the restaurant menu and its items
class Menu {
  final int menuId;
  final List<MenuItem> _menuItems = [];

  Menu({required this.menuId});

  /// Add a new item to the menu
  void addMenuItem(MenuItem item) {
    _menuItems.add(item);
  }

  /// Remove an item from the menu by ID
  bool removeMenuItem(int itemId) {
    final initialLength = _menuItems.length;
    _menuItems.removeWhere((item) => item.itemId == itemId);
    return _menuItems.length < initialLength;
  }

  /// Display all menu items
  void displayMenu() {
    print('\n========== MENU (ID: $menuId) ==========');
    if (_menuItems.isEmpty) {
      print('No items available in the menu.');
      return;
    }
    for (var item in _menuItems) {
      print(item);
    }
    print('=====================================\n');
  }

  /// Search for an item by name
  MenuItem? searchItemByName(String name) {
    try {
      return _menuItems.firstWhere(
        (item) => item.itemName.toLowerCase().contains(name.toLowerCase()),
      );
    } catch (e) {
      return null;
    }
  }

  /// Search for an item by ID
  MenuItem? searchItemById(int id) {
    try {
      return _menuItems.firstWhere((item) => item.itemId == id);
    } catch (e) {
      return null;
    }
  }

  /// Get all menu items
  List<MenuItem> get items => List.unmodifiable(_menuItems);
}
