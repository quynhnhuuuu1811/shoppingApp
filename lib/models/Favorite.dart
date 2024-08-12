import 'package:cloud_firestore/cloud_firestore.dart';

class Favorite {
  late String _id;
  late DocumentReference _customerId;
  late DocumentReference _productId;


  Favorite(
      this._id,
      this._customerId,
      this._productId
      );
  DocumentReference get customerId => _customerId;

  set customerId(DocumentReference value) {
    _customerId = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  DocumentReference get productId => _productId;

  set productId(DocumentReference value) {
    _productId = value;
  }

  Map<String, dynamic> toJson() {
    return {
      'customerId': _customerId,
      'productId': _productId
    };
  }

  static Favorite fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    Map<String, dynamic> data = doc.data()!;
    return Favorite(
        doc.id,
      data['customerId'] as DocumentReference,
      data['productId'] as DocumentReference
    );
  }
}
