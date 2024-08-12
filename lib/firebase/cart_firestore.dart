import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/Cart.dart';
import '../models/Product.dart';

class CartFireStore {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'Cart';
  double totalAmount = 0.0;

  Future<void> delete(String id) async {
    try {
      await _firestore.collection(_collection).doc(id).delete();
    } catch (e) {
      print("Error deleting cart: $e");
      // Handle the error gracefully here
    }
  }

  Future<List<Cart>> getSelectedCartsByCustomerId(String customerId) async {
    try {
      DocumentReference customerRef = _firestore.collection('Customer').doc(customerId);
      QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection(_collection)
          .where('customerId', isEqualTo: customerRef)
          .where('selected', isEqualTo: true)
          .get();

      List<Cart> selectedCarts = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        return Cart(
            doc.id,
            data['customerId'],
            data['productId'],
            data['quantity'],
            data['selectedSize'],
            data['selected']
        );
      }).toList();
      return selectedCarts;
    } catch (e) {
      print("Error getting selected carts by customer ID: $e");
      rethrow;
    }
  }

  Future<void> deleteCarts(List<Cart> carts) async {
    WriteBatch batch = _firestore.batch();
    try {
      for (Cart cart in carts) {
        DocumentReference cartRef = _firestore.collection(_collection).doc(cart.id);
        batch.delete(cartRef);
      }
      await batch.commit();
    } catch (e) {
      print("Error deleting carts: $e");
      rethrow;
    }
  }


  Future<List<Cart>> getByCustomerId(String customerId) async {
    try {
      DocumentReference customerRef =
      _firestore.collection('Customer').doc(customerId);
      QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection(_collection)
          .where('customerId', isEqualTo: customerRef)
          .get();

      // Convert each DocumentSnapshot to a Cart object
      List<Cart> carts = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        return Cart(
          doc.id,
          data['customerId'],
          data['productId'],
          data['quantity'],
          data['selectedSize'],
          data['selected']
        );
      }).toList();
      return carts;
    } catch (e) {
      print("Error getting carts by customer ID: $e");
      rethrow;
    }
  }

  Future<void> updateCartSelected(String cartId, bool selected) async {
    final CollectionReference _cartCollection = FirebaseFirestore.instance.collection('Cart');
    try {
      await _cartCollection.doc(cartId).update({'selected': selected});
    } catch (e) {
      print('Error updating cart selected: $e');
      throw e;
    }
  }


  Future<Product> getProductById(DocumentReference productRef) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> doc =
      await productRef.get() as DocumentSnapshot<Map<String, dynamic>>;
      return Product.fromFirestore(doc);
    } catch (e) {
      print("Error getting product by ID: $e");
      rethrow;
    }
  }

  Future<void> updateCartQuantity(String cartId, int quantity) async {
    final CollectionReference _cartCollection = FirebaseFirestore.instance.collection('Cart');
    try {
      await _cartCollection.doc(cartId).update({'quantity': quantity});
    } catch (e) {
      print('Error updating cart quantity: $e');
      throw e;
    }
  }

  Future<void> insert(Cart data)async{
    try{
        await _firestore.collection(_collection).add({
          'customerId':data.customerId,
          'productId':data.productId,
          'selectedSize':data.selectedSize,
          'quantity':data.quantity,
          'selected': data.selected,
        });
    }
    catch(e){
    }
  }



}
