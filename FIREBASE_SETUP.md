# Firebase Setup Guide for Coffee Shop App

## Overview
This app now uses Firebase for authentication and database storage. Follow these steps to complete the setup.

## Step 1: Create a Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add project"
3. Enter project name: `coffee-shop-app` (or your preferred name)
4. Follow the setup wizard

## Step 2: Enable Authentication

1. In Firebase Console, go to **Authentication**
2. Click "Get Started"
3. Go to **Sign-in method** tab
4. Enable **Email/Password** provider
5. Click "Save"

## Step 3: Create Firestore Database

1. In Firebase Console, go to **Firestore Database**
2. Click "Create database"
3. Choose **Start in test mode** (for development)
4. Select a Cloud Firestore location
5. Click "Enable"

## Step 4: Get Firebase Configuration for Web

1. In Firebase Console, go to **Project Settings** (gear icon)
2. Scroll down to "Your apps"
3. Click the **Web icon** `</>`
4. Register your app with a nickname (e.g., "Coffee Shop Web")
5. Copy the Firebase configuration object

You'll see something like:
```javascript
const firebaseConfig = {
  apiKey: "AIza...",
  authDomain: "coffee-shop-app.firebaseapp.com",
  projectId: "coffee-shop-app",
  storageBucket: "coffee-shop-app.appspot.com",
  messagingSenderId: "123456789",
  appId: "1:123456789:web:abc123"
};
```

## Step 5: Update Flutter App Configuration

Open `lib/main.dart` and update the Firebase initialization around line 14-20:

```dart
await Firebase.initializeApp(
  options: const FirebaseOptions(
    apiKey: 'YOUR_API_KEY',              // Replace with your apiKey
    appId: 'YOUR_APP_ID',                // Replace with your appId
    messagingSenderId: 'YOUR_SENDER_ID', // Replace with your messagingSenderId
    projectId: 'YOUR_PROJECT_ID',        // Replace with your projectId
    storageBucket: 'YOUR_STORAGE_BUCKET', // Replace with your storageBucket
  ),
);
```

## Step 6: Install Dependencies

Run the following command in your project directory:

```bash
flutter pub get
```

## Step 7: Run the App

```bash
flutter run -d chrome
```

## Database Structure

The app creates the following Firestore structure:

```
users (collection)
  └── {userId} (document)
      ├── name: string
      ├── email: string
      ├── favorites: array of integers
      ├── createdAt: timestamp
      └── orders (subcollection)
          └── {orderId} (document)
              ├── orderId: number
              ├── status: string
              ├── totalPrice: number
              ├── timestamp: timestamp
              └── items: array of objects
```

## Firestore Security Rules (Production)

For production, update your Firestore rules to:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
      
      match /orders/{orderId} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
    }
  }
}
```

## Features Enabled

✅ **User Authentication**
- Sign up with email and password
- Sign in with email and password
- Sign out
- Protected order placement (login required)

✅ **Database Integration**
- Save user favorites to Firestore
- Load user favorites on login
- Save completed orders to Firestore
- User profile storage

✅ **UI Updates**
- Login/Sign-up screens with modern design
- Profile button in app bar
- Authentication requirement for favorites and orders
- Persistent data across sessions

## Troubleshooting

### Issue: Firebase not initialized
**Solution**: Make sure you've replaced the demo Firebase config with your actual config from Firebase Console.

### Issue: Authentication not working
**Solution**: Verify that Email/Password authentication is enabled in Firebase Console.

### Issue: Firestore permission denied
**Solution**: Make sure you're in test mode during development, or update security rules to allow authenticated users.

### Issue: Dependencies error
**Solution**: Run `flutter clean` then `flutter pub get`

## Next Steps (Optional Enhancements)

1. Add password reset functionality
2. Add email verification
3. Add Google Sign-In
4. Add order history page showing all past orders from Firestore
5. Add user profile editing
6. Implement real-time order status updates
7. Add push notifications using Firebase Cloud Messaging

## Support

For more information, visit:
- [Firebase Documentation](https://firebase.google.com/docs)
- [FlutterFire Documentation](https://firebase.flutter.dev/)
