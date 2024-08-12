import 'package:cloud_firestore/cloud_firestore.dart';

class OrderDetail {
  late String _id;
  late DocumentReference? _orderId;
  late DocumentReference? _productId;
  late int _orderQuantity;
  late String _selectedSize;

  OrderDetail(
    this._id,
    this._orderId,
    this._productId,
    this._orderQuantity,
      this._selectedSize
  );

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  DocumentReference? get orderId => _orderId;

  set orderId(DocumentReference? value) {
    _orderId = value;
  }

  DocumentReference? get productId => _productId;

  set productId(DocumentReference? value) {
    _productId = value;
  }

  int get orderQuantity => _orderQuantity;

  set orderQuantity(int value) {
    _orderQuantity = orderQuantity ;
  }

  String get selectedSize => _selectedSize;

  set selectedSize(String value) {
    _selectedSize = selectedSize ;
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': _orderId,
      'productId': _productId,
      'orderQuantity': _orderQuantity,
      'selectedSize': selectedSize
    };
  }

  static OrderDetail fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    Map<String, dynamic> data = doc.data()!;
    return OrderDetail(
      doc.id,
      data['orderId'] as DocumentReference?,
      data['productId'] as DocumentReference?,
      data['orderQuantity']as int,
      data['selectedSize'] as String
    );
  }


}