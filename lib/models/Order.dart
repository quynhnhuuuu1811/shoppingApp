import 'package:cloud_firestore/cloud_firestore.dart';

class Order {
  late String _id;
  late DocumentReference? _customerId;
  late DateTime _orderDate;
  late double _totalAmount;
  late String _address;
  late String _note;

  Order(
      this._id,
      this._customerId,
      this._orderDate,
      this._totalAmount,
      this._address,
      this._note
      );

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  String get address => _address;

  set address(String value) {
    _address = value;
  }

  DocumentReference? get customerId => _customerId;

  set customerId(DocumentReference? value) {
    _customerId = value;
  }

  DateTime get orderDate => _orderDate;

  set orderDate(DateTime value) {
    _orderDate = value;
  }

  double get totalAmount => _totalAmount;

  set totalAmount(double value) {
    _totalAmount = value;
  }

  String get note => _note;

  set note(String value)
  {
    _note = value;
  }

  Map<String, dynamic> toJson() {
    return {
      'customerId': _customerId,
      'orderDate': _orderDate,
      'totalAmount': _totalAmount,
      'address': _address,
      'note':_note
    };
  }

  static Order fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    Map<String, dynamic> data = doc.data()!;
    return Order(
      doc.id,
      data['customerId'] as DocumentReference?,
      (data['orderDate'] as Timestamp).toDate(),
      (data['totalAmount'] as num).toDouble(),
      data['address'],
      data['note']
    );
  }
}
