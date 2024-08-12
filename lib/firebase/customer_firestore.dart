import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qlthuvien/models/Customer.dart';

class CustomerFireStore  {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'Customer';

  Future<List<Customer>> getAllDocuments() async {
    List<Customer> customers = [];
    try {
      QuerySnapshot querySnapshot = await _firestore.collection(_collection).get();
      List<DocumentSnapshot> documents = querySnapshot.docs;
      for (var doc in documents) {
        var data = doc.data() as Map<String, dynamic>; // Ép kiểu sang Map<String, dynamic>

        Customer customer = Customer(
          doc.id,
          data['fullname'],
          data['phoneNumber'],
          data['birthdate'],
          data['password'],
        );
        customers.add(customer);
      }
    } catch (e) {
      print('Error getting documents: $e');
      rethrow; // Rethrow để cho phép các phần khác của ứng dụng xử lý lỗi này nếu cần
    }

    return customers;
  }

  Future<Customer> getById(String id) {
    try {
      return _firestore.collection(_collection).doc(id).get().then((doc) => Customer.fromFirestore(doc));
    } catch (e) {
      print("Error:$e");
      rethrow;
    }
  }


  Future<Customer> getCustomerById(DocumentReference productId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> doc = await _firestore.collection(_collection).doc(productId.id).get();
      return Customer(
          doc.id,
          doc['fullname'],
          doc['phoneNumber'],
          doc['birthdate'],
          doc['password'],
      );
    } catch (e) {
      print("Error: $e");
      rethrow; // Ném ngoại lệ để báo lỗi nếu có
    }
  }

  Future<void> updateInformation(Customer data) async {
    try {
      await _firestore.collection(_collection).doc(data.id).update({
        'fullname':data.fullname,
        'phoneNumber':data.phoneNumber,
        'birthdate':data.birthdate,
        'password': data.password
      });
    } catch (e) {
      print("Error: $e");
      rethrow; // Ném ngoại lệ để báo lỗi nếu có
    }
  }

  Future<Customer?> getByPhone(String phone) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
          .collection(_collection).where('phoneNumber', isEqualTo: phone).get();
      if (querySnapshot.docs.isNotEmpty) {
        return Customer.fromFirestore(querySnapshot.docs.first);
      }
    }
    catch (e) {
      print("Error: $e");
      rethrow;
    }
    return null;
  }
}
