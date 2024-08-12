import 'package:cloud_firestore/cloud_firestore.dart';

class Customer{
  late String _id;
  late String _fullname;
  late String _birthdate;
  late String _password;
  late String _phoneNumber;
  Customer(this._id, this._fullname, this._birthdate, this._phoneNumber,this._password);


  String get id => _id;
  set id(String value)
  {
    _id = value;
  }

  String get fullname => _fullname;
  set fullname(String value)
  {
    _fullname = value;
  }

  String get birthdate => _birthdate;
  set birthdate(String value)
  {
    _birthdate = value;
  }

  String get phoneNumber => _phoneNumber;
  set phoneNumber(String value)
  {
    _phoneNumber = value;
  }

  String get password => _password;
  set password(String value)
  {
    _password = value;
  }
  Map<String, dynamic> toJson() {
    return {
      'fullname': _fullname,
      'phoneNumber': _phoneNumber,
      'birthdate': _birthdate,
      'password': _password,
    };
  }

  static Customer fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    Map<String, dynamic> data = doc.data()!;
    return Customer(
      doc.id,
      data['fullname'],
      data['phoneNumber'],
      data['birthdate'],
      data['password'],
    );
  }

}

