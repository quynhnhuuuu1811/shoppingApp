import 'package:cloud_firestore/cloud_firestore.dart';

class AuthBloc {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<void> signIn(String phone , String password, Function onSuccess, Function onError ) async {
    try {
      if(phone.isEmpty || password.isEmpty){
        onError('Vui lòng nhập đầy đủ thông tin');
        return;
      }
      final customerSnapshot = await _firestore.collection('Customer').where('phoneNumber',isEqualTo: phone).get();
      if (customerSnapshot.docs.isNotEmpty)
        {
          final customer = customerSnapshot.docs.first.data();

          if (customer['password'] == password )
            {
              onSuccess();
            }
        }
    }
    catch(e){
      onError(e);
    }
  }
}