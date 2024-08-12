import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qlthuvien/models/Order.dart' as MyOrder;

import '../models/OrderDetail.dart';

class OrderFireStore {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'Order';

  Future<List<MyOrder.Order>> getAllDocuments() async {
    List<MyOrder.Order> orders = [];
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore.collection(_collection).get();
      List<QueryDocumentSnapshot<Map<String, dynamic>>> documents = querySnapshot.docs;
      for (var doc in documents) {
        orders.add(MyOrder.Order.fromFirestore(doc) );
      }
    } catch (e) {
      print('Error getting documents: $e');
      rethrow; // Rethrow to allow other parts of the app to handle this error if necessary
    }
    return orders;
  }

  Future<List<MyOrder.Order>> getByCustomerId(String customerId) async {
    try {
      DocumentReference customerRef = _firestore.collection('Customer').doc(customerId);
      QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection(_collection)
          .where('customerId', isEqualTo: customerRef)
          .get();

      // Convert each DocumentSnapshot to an Order object
      List<MyOrder.Order> orders = snapshot.docs.map((doc) => MyOrder.Order.fromFirestore(doc)).toList();
      return orders;
    } catch (e) {
      print("Error getting orders by customer ID: $e");
      rethrow;
    }
  }

  Future<DocumentReference> insert(MyOrder.Order data )async{
    return  await _firestore.collection(_collection).add({
        'customerId' : data.customerId,
        'orderDate': data.orderDate,
        'totalAmount': data.totalAmount,
        'address': data.address,
        'note': data.note
      });
    }

  }



