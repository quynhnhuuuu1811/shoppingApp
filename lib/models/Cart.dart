import 'package:cloud_firestore/cloud_firestore.dart';

class Cart {
  String _id;
  DocumentReference _customerId;
  DocumentReference _productId;
  int _quantity;
  String _selectedSize;
  bool _selected;

  Cart(this._id, this._customerId, this._productId, this._quantity, this._selectedSize, this._selected);

  String get id => _id;
  set id(String value) => _id = value;

  DocumentReference get customerId => _customerId;
  set customerId(DocumentReference value) => _customerId = value;

  DocumentReference get productId => _productId;
  set productId(DocumentReference value) => _productId = value;

  int get quantity => _quantity;
  set quantity(int value) => _quantity = value;

  String get selectedSize => _selectedSize;
  set selectedSize(String value) => _selectedSize = value;

  bool get selected=> _selected;

  set selected(bool value) {
    _selected = value;
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'customerId': customerId,
      'quantity': quantity,
      'selectedSize': selectedSize,
      'selected': selected

    };
  }


  static Cart fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    Map<String, dynamic> data = doc.data()!;
    return Cart(
      doc.id,
      data['customerId'] as DocumentReference,
      data['productId']  as DocumentReference,
      data['quantity'],
      data['selectedSize'],
      data['selected']
    );
  }


}
