import 'package:flutter/material.dart';
import '../models/order.dart';
import '../models/payment.dart';
import '../models/card_payment.dart';
import '../models/cash_payment.dart';
import '../models/mobile_payment.dart';

class PaymentScreen extends StatefulWidget {
  final Order order;

  const PaymentScreen({Key? key, required this.order}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String selectedPaymentMethod = 'Card';
  bool isProcessing = false;

  // Card payment fields
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController cardHolderController = TextEditingController();
  final TextEditingController expiryController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();

  // Mobile payment fields
  String selectedMobileProvider = 'Apple Pay';

  @override
  void dispose() {
    cardNumberController.dispose();
    cardHolderController.dispose();
    expiryController.dispose();
    cvvController.dispose();
    super.dispose();
  }

  Future<void> _processPayment() async {
    setState(() {
      isProcessing = true;
    });

    // Simulate payment processing
    await Future.delayed(const Duration(seconds: 2));

    Payment? payment;
    bool success = false;

    switch (selectedPaymentMethod) {
      case 'Card':
        // Parse expiry date
        DateTime? expiry;
        try {
          final parts = expiryController.text.split('/');
          if (parts.length == 2) {
            final month = int.parse(parts[0]);
            final year = 2000 + int.parse(parts[1]);
            expiry = DateTime(year, month);
          }
        } catch (e) {
          expiry = DateTime.now().add(const Duration(days: 365));
        }

        payment = CardPayment(
          paymentId: DateTime.now().millisecondsSinceEpoch,
          amount: widget.order.totalPrice,
          cardNumber: cardNumberController.text,
          expiryDate: expiry ?? DateTime.now().add(const Duration(days: 365)),
        );
        success = payment.processPayment();
        break;

      case 'Cash':
        payment = CashPayment(
          paymentId: DateTime.now().millisecondsSinceEpoch,
          amount: widget.order.totalPrice,
        );
        success = payment.processPayment();
        break;

      case 'Mobile':
        payment = MobilePayment(
          paymentId: DateTime.now().millisecondsSinceEpoch,
          amount: widget.order.totalPrice,
          walletId: selectedMobileProvider,
        );
        success = payment.processPayment();
        break;
    }

    setState(() {
      isProcessing = false;
    });

    if (success && mounted) {
      widget.order.updateStatus('Confirmed');
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
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
                              // Order summary
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.brown[50]?.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Order Summary',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text('Order #${widget.order.orderId}'),
                                    Text('Items: ${widget.order.items.length}'),
                                    const Divider(),
                                    Text(
                                      'Total: \$${widget.order.totalPrice.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 24),

                              // Payment method selection
                              const Text(
                                'Select Payment Method',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),

                              _buildPaymentMethodOption('Card', Icons.credit_card),
                              _buildPaymentMethodOption('Mobile', Icons.phone_android),
                              _buildPaymentMethodOption('Cash', Icons.money),

                              const SizedBox(height: 24),

                              // Payment details based on selected method
                              if (selectedPaymentMethod == 'Card')
                                ..._buildCardPaymentForm(),
                              if (selectedPaymentMethod == 'Mobile')
                                ..._buildMobilePaymentForm(),
                              if (selectedPaymentMethod == 'Cash')
                                ..._buildCashPaymentInfo(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Pay button
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
                    onPressed: isProcessing ? null : _processPayment,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown[700],
                      disabledBackgroundColor: Colors.grey[400],
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: isProcessing
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(
                            'Pay \$${widget.order.totalPrice.toStringAsFixed(2)}',
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
      ),
    );
  }

  Widget _buildPaymentMethodOption(String method, IconData icon) {
    final isSelected = selectedPaymentMethod == method;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPaymentMethod = method;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.brown[50] : Colors.white,
          border: Border.all(
            color: isSelected ? Colors.brown[700]! : Colors.grey[300]!,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.brown[700] : Colors.grey[600],
            ),
            const SizedBox(width: 16),
            Text(
              method,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.brown[700] : Colors.black,
              ),
            ),
            const Spacer(),
            if (isSelected) Icon(Icons.check_circle, color: Colors.brown[700]),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildCardPaymentForm() {
    return [
      const Text(
        'Card Details',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 12),
      TextField(
        controller: cardNumberController,
        decoration: InputDecoration(
          labelText: 'Card Number',
          labelStyle: const TextStyle(fontSize: 16),
          hintText: '1234 5678 9012 3456',
          prefixIcon: const Icon(Icons.credit_card),
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
        keyboardType: TextInputType.number,
      ),
      const SizedBox(height: 12),
      TextField(
        controller: cardHolderController,
        decoration: InputDecoration(
          labelText: 'Card Holder Name',
          labelStyle: const TextStyle(fontSize: 16),
          prefixIcon: const Icon(Icons.person_outlined),
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
      ),
      const SizedBox(height: 12),
      Row(
        children: [
          Expanded(
            child: TextField(
              controller: expiryController,
              decoration: InputDecoration(
                labelText: 'Expiry',
                labelStyle: const TextStyle(fontSize: 16),
                hintText: 'MM/YY',
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
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: cvvController,
              decoration: InputDecoration(
                labelText: 'CVV',
                labelStyle: const TextStyle(fontSize: 16),
                hintText: '123',
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
              keyboardType: TextInputType.number,
              obscureText: true,
            ),
          ),
        ],
      ),
    ];
  }

  List<Widget> _buildMobilePaymentForm() {
    return [
      const Text(
        'Select Provider',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 12),
      DropdownButtonFormField<String>(
        value: selectedMobileProvider,
        decoration: InputDecoration(
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
        items: ['Apple Pay', 'Google Pay', 'Samsung Pay', 'PayPal']
            .map((provider) => DropdownMenuItem(
                  value: provider,
                  child: Text(provider),
                ))
            .toList(),
        onChanged: (value) {
          if (value != null) {
            setState(() {
              selectedMobileProvider = value;
            });
          }
        },
      ),
      const SizedBox(height: 16),
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.blue[50],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(Icons.info_outline, color: Colors.blue[700]),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'You will be redirected to complete the payment',
                style: TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> _buildCashPaymentInfo() {
    return [
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.green[50],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(Icons.payments, size: 48, color: Colors.green[700]),
            const SizedBox(height: 12),
            const Text(
              'Pay with Cash',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Amount to pay: \$${widget.order.totalPrice.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            const Text(
              'Please have exact change ready for pickup',
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ];
  }
}
