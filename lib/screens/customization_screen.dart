import 'package:flutter/material.dart';
import '../models/menu_item.dart';

class CustomizationScreen extends StatefulWidget {
  final MenuItem menuItem;

  const CustomizationScreen({Key? key, required this.menuItem})
      : super(key: key);

  @override
  State<CustomizationScreen> createState() => _CustomizationScreenState();
}

class _CustomizationScreenState extends State<CustomizationScreen> {
  late String selectedSize;
  List<AddOn> selectedAddOns = [];
  TextEditingController specialInstructionsController = TextEditingController();
  int quantity = 1;

  @override
  void initState() {
    super.initState();
    selectedSize = widget.menuItem.availableSizes.first;
  }

  @override
  void dispose() {
    specialInstructionsController.dispose();
    super.dispose();
  }

  double _calculateTotal() {
    double basePrice = widget.menuItem.getPriceForSize(selectedSize);
    double addOnsPrice =
        selectedAddOns.fold(0.0, (sum, addOn) => sum + addOn.price);
    return (basePrice + addOnsPrice) * quantity;
  }

  void _addToOrder() {
    final customizedItem = CustomizedMenuItem(
      menuItem: widget.menuItem,
      selectedSize: selectedSize,
      selectedAddOns: selectedAddOns,
      specialInstructions: specialInstructionsController.text,
      quantity: quantity,
    );
    Navigator.pop(context, customizedItem);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.menuItem.itemName),
        backgroundColor: Colors.brown[700],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.brown[800]!, Colors.brown[600]!],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 450),
                      child: Card(
                        elevation: 12,
                        shadowColor: Colors.brown.withOpacity(0.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(40),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                  // Item description
                  Text(
                    widget.menuItem.itemName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.menuItem.description,
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 24),

                  // Size selection
                  if (widget.menuItem.availableSizes.isNotEmpty &&
                      widget.menuItem.availableSizes.length > 1) ...[
                    const Text(
                      'Size',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: widget.menuItem.availableSizes.map((size) {
                        final isSelected = selectedSize == size;
                        final upcharge =
                            widget.menuItem.sizeUpcharges[size] ?? 0.0;
                        return ChoiceChip(
                          label: Text(
                            upcharge > 0
                                ? '$size (+\$${upcharge.toStringAsFixed(2)})'
                                : size,
                          ),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                selectedSize = size;
                              });
                            }
                          },
                          selectedColor: Colors.brown[300],
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Add-ons
                  if (widget.menuItem.availableAddOns.isNotEmpty) ...[
                    const Text(
                      'Customize',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...widget.menuItem.availableAddOns.map((addOn) {
                      final isSelected = selectedAddOns.contains(addOn);
                      return CheckboxListTile(
                        title: Text(addOn.name),
                        subtitle: Text(
                          addOn.price > 0
                              ? '+\$${addOn.price.toStringAsFixed(2)}'
                              : 'Free',
                        ),
                        value: isSelected,
                        onChanged: (checked) {
                          setState(() {
                            if (checked == true) {
                              selectedAddOns.add(addOn);
                            } else {
                              selectedAddOns.remove(addOn);
                            }
                          });
                        },
                        activeColor: Colors.brown[700],
                      );
                    }).toList(),
                    const SizedBox(height: 24),
                  ],

                  // Special instructions
                  const Text(
                    'Special Instructions',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: specialInstructionsController,
                    decoration: InputDecoration(
                      hintText: 'e.g., Extra hot, Less ice...',
                      filled: true,
                      fillColor: Colors.grey[50],
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 18,
                      ),
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
                    maxLines: 3,
                  ),
                  const SizedBox(height: 24),

                  // Quantity
                  const Text(
                    'Quantity',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: quantity > 1
                            ? () {
                                setState(() {
                                  quantity--;
                                });
                              }
                            : null,
                        iconSize: 32,
                      ),
                      Text(
                        '$quantity',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        onPressed: () {
                          setState(() {
                            quantity++;
                          });
                        },
                        iconSize: 32,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  ),
),
),
          // Add to order button
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _addToOrder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown[700],
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Add to Order - \$${_calculateTotal().toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
      }
