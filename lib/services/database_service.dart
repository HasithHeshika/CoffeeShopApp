import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/menu_item.dart';
import '../models/order.dart' as app_models;

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get userId => _auth.currentUser?.uid;

  // Save user favorites
  Future<void> saveFavorites(Set<int> favoriteIds) async {
    if (userId == null) return;
    
    await _firestore.collection('users').doc(userId).set({
      'favorites': favoriteIds.toList(),
    }, SetOptions(merge: true));
  }

  // Load user favorites
  Future<Set<int>> loadFavorites() async {
    if (userId == null) return {};
    
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists && doc.data()?['favorites'] != null) {
        final List<dynamic> favorites = doc.data()!['favorites'];
        return favorites.map((e) => e as int).toSet();
      }
    } catch (e) {
      print('Error loading favorites: $e');
    }
    return {};
  }

  // Save order to database
  Future<void> saveOrder(app_models.Order order) async {
    if (userId == null) return;

    try {
      final orderData = {
        'orderId': order.orderId,
        'userId': userId,
        'status': order.status,
        'totalPrice': order.totalPrice,
        'timestamp': FieldValue.serverTimestamp(),
        'items': order.items.map((item) => {
          'itemName': item.menuItem.itemName,
          'selectedSize': item.selectedSize,
          'quantity': item.quantity,
          'totalPrice': item.getTotalPrice(),
          'addOns': item.selectedAddOns.map((addon) => addon.name).toList(),
          'specialInstructions': item.specialInstructions,
        }).toList(),
      };

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('orders')
          .doc(order.orderId.toString())
          .set(orderData);
    } catch (e) {
      print('Error saving order: $e');
    }
  }

  // Load user orders
  Future<List<Map<String, dynamic>>> loadOrders() async {
    if (userId == null) return [];

    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('orders')
          .orderBy('timestamp', descending: true)
          .get();

      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print('Error loading orders: $e');
      return [];
    }
  }

  // Save user profile
  Future<void> saveUserProfile({
    required String name,
    String? phone,
  }) async {
    if (userId == null) return;

    await _firestore.collection('users').doc(userId).set({
      'name': name,
      'phone': phone,
      'email': _auth.currentUser?.email,
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  // Get user profile
  Future<Map<String, dynamic>?> getUserProfile() async {
    if (userId == null) return null;

    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      return doc.data();
    } catch (e) {
      print('Error getting user profile: $e');
      return null;
    }
  }
}
