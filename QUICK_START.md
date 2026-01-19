# Coffee Shop App - Quick Start Guide

## 🚀 How to Run

```bash
# 1. Install dependencies
flutter pub get

# 2. Run the app
flutter run
```

## 📱 App Walkthrough

### 1. Home Screen
When you launch the app, you'll see:
- **App Bar**: "☕ Coffee Shop" with notification bell icon
- **Current Order Card**: Shows items in your cart
- **Menu Grid**: Browse all available items

### 2. Ordering Process

#### Step 1: Browse Menu
- Scroll through the menu to see available items
- Items are organized by category (Coffee, Tea, Pastries, Food)
- Each card shows the item name, base price, and description

#### Step 2: Customize Your Item
- Tap any menu item to open the customization screen
- **Select Size**: Choose Small, Medium, or Large (price adjusts automatically)
- **Add-ons**: Select milk alternatives, extra shots, syrups, toppings
- **Special Instructions**: Add notes like "Extra hot" or "Light ice"
- **Quantity**: Use +/- buttons to order multiple
- See the total price update in real-time
- Tap "Add to Order" button

#### Step 3: Review Your Cart
- Return to home screen to see your items in "Current Order"
- Each item shows: quantity, name, size, and price
- Remove items by tapping the ❌ icon
- Total price is displayed at the bottom

#### Step 4: Checkout
- Tap "Complete Order" button
- You'll be taken to the Payment Screen

#### Step 5: Payment
- **Order Summary**: Review your order total
- **Select Payment Method**:
  - **Card**: Enter card number, holder name, expiry (MM/YY), CVV
  - **Mobile**: Choose Apple Pay, Google Pay, Samsung Pay, or PayPal
  - **Cash**: Confirm cash payment on pickup
- Tap "Pay $XX.XX" button
- Processing animation shows during payment

#### Step 6: Confirmation
- Success message appears: "Order placed successfully! ☕"
- Notification after 3 seconds: "🔔 Your order is being prepared"
- Order moves to order history

### 3. Notifications
Tap the 🔔 bell icon in the app bar to see:
- Welcome offers (10% off first order)
- New menu items
- Limited time promotions (Happy Hour)

### 4. Order History
Tap "View Order History" to see:
- All completed orders
- Order status (Confirmed, Preparing, Ready, Delivered)
- Items in each order
- Total amount paid

## 🎯 Sample Orders to Try

### Morning Coffee
1. Select "Cappuccino"
2. Choose "Medium" size
3. Add "Oat Milk"
4. Add special instruction: "Extra hot"
5. Quantity: 1
6. Add to order

### Afternoon Treat
1. Select "Caramel Macchiato"
2. Choose "Large" size
3. Add "Extra Shot"
4. Add "Whipped Cream"
5. Add "Caramel Drizzle"
6. Quantity: 1
7. Add to order
8. Select "Chocolate Chip Cookie"
9. Quantity: 2
10. Add to order

### Quick Snack
1. Select "Croissant"
2. Add to order (no customization needed)
3. Select "Americano"
4. Choose "Small"
5. Add to order

## 💡 Tips

- **Sizes**: 
  - Small = Base price
  - Medium = +$1.00
  - Large = +$2.00

- **Popular Add-ons**:
  - Extra Shot = +$1.00
  - Oat/Almond Milk = +$0.75
  - Syrups = +$0.50 each
  - Whipped Cream = +$0.75

- **Special Instructions Examples**:
  - "Extra hot"
  - "Light ice"
  - "No foam"
  - "Extra pump of vanilla"
  - "Leave room for cream"

## 🐛 Troubleshooting

### App won't start?
```bash
flutter clean
flutter pub get
flutter run
```

### Build errors?
Make sure you have:
- Flutter SDK ≥ 2.17.0
- Dart SDK installed
- Android Studio / Xcode configured

### Test the app:
```bash
flutter test
```

## 📞 Need Help?

Check out the full documentation in:
- [README.md](README.md) - Project overview
- [IMPLEMENTATION_SUMMARY.md](IMPLEMENTATION_SUMMARY.md) - Technical details

---

Enjoy your coffee! ☕
