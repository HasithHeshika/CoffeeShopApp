/// Represents an individual item in the menu
class MenuItem {
  final int itemId;
  final String itemName;
  final double price;
  final String description;
  final String category; // 'Coffee', 'Tea', 'Pastry', 'Snack'
  final List<String> availableSizes; // ['Small', 'Medium', 'Large']
  final Map<String, double> sizeUpcharges; // {'Medium': 1.0, 'Large': 2.0}
  final List<AddOn> availableAddOns;
  final String imageUrl;

  MenuItem({
    required this.itemId,
    required this.itemName,
    required this.price, // Base price for small/default size
    required this.description,
    this.category = 'Other',
    this.availableSizes = const ['Small', 'Medium', 'Large'],
    this.sizeUpcharges = const {'Medium': 1.0, 'Large': 2.0},
    this.availableAddOns = const [],
    this.imageUrl = '',
  });

  /// Calculate price with size
  double getPriceForSize(String size) {
    return price + (sizeUpcharges[size] ?? 0.0);
  }

  /// Get detailed information about the menu item
  String getDetails() {
    return '''
    Item ID: $itemId
    Name: $itemName
    Category: $category
    Base Price: \$${price.toStringAsFixed(2)}
    Description: $description
    Available Sizes: ${availableSizes.join(', ')}
    ''';
  }

  @override
  String toString() {
    return '$itemName - \$${price.toStringAsFixed(2)}';
  }
}

/// Represents customization options for menu items
class AddOn {
  final String name;
  final double price;
  final String category; // 'Milk', 'Sweetener', 'Topping', 'Extra Shot'

  const AddOn({
    required this.name,
    required this.price,
    this.category = 'Extra',
  });

  @override
  String toString() => '$name (+\$${price.toStringAsFixed(2)})';
}

/// Represents a customized order item
class CustomizedMenuItem {
  final MenuItem menuItem;
  final String selectedSize;
  final List<AddOn> selectedAddOns;
  final String specialInstructions;
  final int quantity;

  CustomizedMenuItem({
    required this.menuItem,
    this.selectedSize = 'Small',
    this.selectedAddOns = const [],
    this.specialInstructions = '',
    this.quantity = 1,
  });

  /// Calculate total price including size and add-ons
  double getTotalPrice() {
    double basePrice = menuItem.getPriceForSize(selectedSize);
    double addOnsPrice =
        selectedAddOns.fold(0.0, (sum, addOn) => sum + addOn.price);
    return (basePrice + addOnsPrice) * quantity;
  }

  String getDescription() {
    StringBuffer desc = StringBuffer();
    desc.write('${menuItem.itemName} ($selectedSize)');
    if (selectedAddOns.isNotEmpty) {
      desc.write('\nAdd-ons: ${selectedAddOns.map((a) => a.name).join(', ')}');
    }
    if (specialInstructions.isNotEmpty) {
      desc.write('\nNote: $specialInstructions');
    }
    return desc.toString();
  }

  @override
  String toString() {
    return '${quantity}x ${menuItem.itemName} ($selectedSize) - \$${getTotalPrice().toStringAsFixed(2)}';
  }
}
