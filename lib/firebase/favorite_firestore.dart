import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/Favorite.dart';
import '../models/Product.dart';

class FavoriteFireStore {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'Favorite';


  Future<List<Favorite>> getSelectedFavoriteByCustomerId(String customerId) async {
    try {
      DocumentReference customerRef = _firestore.collection('Favorite').doc(customerId);
      QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection(_collection)
          .where('customerId', isEqualTo: customerRef)
          .get();

      List<Favorite> selectedFavorite = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        return Favorite(
            doc.id,
            data['customerId'],
            data['productId'],
        );
      }).toList();
      return selectedFavorite;
    } catch (e) {
      print("Error getting selected favorite status by customer ID: $e");
      rethrow;
    }
  }

  Future<void> deleteFavorite(List<Favorite> favorites) async {
    WriteBatch batch = _firestore.batch();
    try {
      for (Favorite favorite in favorites) {
        DocumentReference favoriteRef = _firestore.collection(_collection).doc(favorite.id);
        batch.delete(favoriteRef);
      }
      await batch.commit();
    } catch (e) {
      print("Error deleting carts: $e");
      rethrow;
    }
  }


  Future<List<Favorite>> getByCustomerId(String customerId) async {
    try {
      DocumentReference customerRef =
      _firestore.collection('Customer').doc(customerId);
      QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection(_collection)
          .where('customerId', isEqualTo: customerRef)
          .get();

      // Convert each DocumentSnapshot to a Cart object
      List<Favorite> favorites = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        return Favorite(
            doc.id,
            data['customerId'],
            data['productId'],
        );
      }).toList();
      return favorites;
    } catch (e) {
      print("Error getting carts by customer ID: $e");
      rethrow;
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


  Future<void> addFavorite(Favorite data)async{
    try{
      await _firestore.collection(_collection).add({
        'customerId':data.customerId,
        'productId':data.productId,
      });
    }
    catch(e){
    }
  }

  Future<void> removeFavorite(String customerId, String productId) async {
    try {
      DocumentReference customerRef = _firestore.collection('Customer').doc(customerId);
      DocumentReference productRef = _firestore.collection('Product').doc(productId);
      QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection(_collection)
          .where('customerId', isEqualTo: customerRef)
          .where('productId', isEqualTo: productRef)
          .get();

      WriteBatch batch = _firestore.batch();
      for (var doc in snapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
    } catch (e) {
      print("Error removing favorite: $e");
      rethrow;
    }
  }





}
