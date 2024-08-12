import 'package:cloud_firestore/cloud_firestore.dart';

class Category
{
  late String _id;
  late String _name;
  late String _image;
  Category(this._id, this._name, this._image);

  String get id => _id;
  set id(String value)
  {
    _id = value;
  }

  String get name => _name;
  set name( String value)
  {
    _name = value;
  }

  String get image => _image;
  set image( String value)
  {
    _image = value;
  }
}


