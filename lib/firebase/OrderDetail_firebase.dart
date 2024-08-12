import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qlthuvien/models/OrderDetail.dart';

class OrderDetailFireStore  {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'OrderDetail';

  Future<OrderDetail> getById(String id) {
    try {
      return _firestore.collection(_collection).doc(id).get().then((doc) => OrderDetail.fromFirestore(doc));
    } catch (e) {
      print("Error:$e");
      rethrow;
    }
  }


  Future<void> insert(OrderDetail data) async {
    try {
      if (data.orderId == null || data.productId == null || data.orderQuantity == null || data.selectedSize == null) {
        throw Exception('Missing required fields');
      }

      await _firestore.collection(_collection).add({
        'orderId': data.orderId,
        'productId': data.productId,
        'orderQuantity': data.orderQuantity,
        'selectedSize': data.selectedSize
      });
    } catch (e) {
      print('Error inserting order detail: $e');
      rethrow;
    }
  }

  Future<List<OrderDetail>> getByOrderId(String orderId) async {
    try {

      DocumentReference OrderIdRef = _firestore.collection('Order').doc(orderId); // Sửa thành 'Category'
      print(OrderIdRef);
      QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection(_collection)
          .where('orderId', isEqualTo: OrderIdRef)
          .get();

      List<OrderDetail> orderdetails = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        int orderQuantity = data['orderQuantity'];
        return OrderDetail(
            doc.id,
            OrderIdRef,
            data['productId'],
            orderQuantity,
            data['selectedSize']
        );
      }).toList();


      return orderdetails;
    } catch (e) {
      print("Error: $e");
      rethrow;
    }
  }


  Future<List<OrderDetail>> getOrderDetailsByOrderId(String orderId) async {
    try {
      DocumentReference orderIdRef=await _firestore.collection('Order').doc(orderId);
      var querySnapshot = await _firestore
          .collection(_collection)
          .where('orderId', isEqualTo: orderIdRef)
          .get();

      List<OrderDetail> orderDetails = [];
      querySnapshot.docs.forEach((doc) {
        print("Retrieved document data: ${doc.data()}");
        orderDetails.add(OrderDetail.fromFirestore(doc));
      });

      return orderDetails;
    } catch (e) {
      print("Error getting order details by order ID: $e");
      rethrow;
    }
  }



}