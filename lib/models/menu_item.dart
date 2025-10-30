/// Represents an individual item in the menu
class MenuItem {
  final int itemId;
  final String itemName;
  final double price;
  final String description;

  MenuItem({
    required this.itemId,
    required this.itemName,
    required this.price,
    required this.description,
  });

  /// Get detailed information about the menu item
  String getDetails() {
    return '''
    Item ID: $itemId
    Name: $itemName
    Price: \$${price.toStringAsFixed(2)}
    Description: $description
    ''';
  }

  @override
  String toString() {
    return '$itemName - \$${price.toStringAsFixed(2)}';
  }
}
