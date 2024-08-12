import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  late final String _id;
  late final String _name;
  late final int _unitPrice;
  late final String _imageUrl;
  late final Map<String, dynamic> _description;
  late final DocumentReference? _categoryId;
  late final List<String> _size;

  Product(this._id, this._name, this._unitPrice, this._imageUrl, this._categoryId, this._description, this._size);

  String get id => _id;

  set id(String value) {
    _id = value;
  }


  DocumentReference? get categoryId => _categoryId;

  set categoryId(DocumentReference? value) {
    _categoryId = value;
  }

  String get imageUrl => _imageUrl;

  set imageUrl(String value) {
    _imageUrl = value;
  }

  int get unitPrice => _unitPrice;

  set unitPrice(int value) {
    _unitPrice = value;
  }

  Map<String, dynamic> get description => _description;

  set description(Map<String, dynamic> value) {
    _description = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  List<String> get size => _size;

  set size(List<String> value) {
    _size = value;
  }

  Map<String, dynamic> toJson() {
    return {
      'name': _name,
      'unitPrice': _unitPrice,
      'imageUrl': _imageUrl,
      'categoryId': _categoryId,
      'description': _description,
      'size': _size,
    };
  }

  static Product fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    Map<String, dynamic> data = doc.data()!;
    return Product(
        doc.id,
        data['name'],
        data['unitPrice'],
        data['imageUrl'],
        data['categoryId'],
        Map<String, dynamic>.from(data['description']),
        List<String>.from(data['size']),
    );
  }


}