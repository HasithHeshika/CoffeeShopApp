# Screens Directory

This directory contains all the UI screens for the Coffee Shop App.

## Payment Screens

### PaymentScreen
The main payment method selection screen that allows users to choose between:
- **Card Payment** - Credit/Debit card payments
- **Mobile Wallet** - Apple Pay, Google Pay, PayPal
- **Cash Payment** - Cash payment at counter

### CardPaymentScreen
Complete card payment form with:
- Card number input with automatic formatting
- Cardholder name
- Expiry date (MM/YY)
- CVV code
- Real-time validation
- Secure payment processing

### MobilePaymentScreen
Mobile wallet payment interface with:
- Wallet provider selection (Apple Pay, Google Pay, PayPal)
- Wallet ID / Phone number input
- Quick payment confirmation

### CashPaymentScreen
Cash payment handler with:
- Total amount display
- Cash received input
- Change calculation
- Quick amount selection buttons
- Payment confirmation

## Integration

All payment screens integrate with the backend payment models:
- `CardPayment` - lib/models/card_payment.dart
- `MobilePayment` - lib/models/mobile_payment.dart
- `CashPayment` - lib/models/cash_payment.dart

## Usage

From the main order screen, clicking "Proceed to Payment" navigates to the PaymentScreen where users select their preferred payment method and complete the transaction.
