import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qlthuvien/pages/AccountPage/TextFieldInformation.dart';
import '../../firebase/customer_firestore.dart';
import '../../models/Customer.dart';

class EditInformationPage extends StatefulWidget {
  final Customer customer;

  EditInformationPage({Key? key, required this.customer}) : super(key: key);

  @override
  State<EditInformationPage> createState() => _EditInformationPageState();
}

class _EditInformationPageState extends State<EditInformationPage> {
  late final TextEditingController _fullnameController;
  late final TextEditingController _birthdateController;
  late final TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _fullnameController = TextEditingController(text: widget.customer.fullname);
    _phoneController = TextEditingController(text: widget.customer.phoneNumber);
    _birthdateController = TextEditingController(text: widget.customer.birthdate);
  }

  @override
  void dispose() {
    _fullnameController.dispose();
    _birthdateController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void updateInformation() {
    CustomerFireStore customerFireStore = CustomerFireStore();
    Customer customer = Customer(
        widget.customer.id,
        _fullnameController.text,
        _phoneController.text,
        _birthdateController.text,
      " ",
    );
    customerFireStore.updateInformation(customer);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFffdee3),
        toolbarHeight: 60,
        title: Text(
          'Chỉnh sửa thông tin cá nhân',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 40, 20, 10),
        child: Column(
          children: [
            TextFieldEdit(controller: _fullnameController, labelText: 'Họ và tên'),
            TextFieldEdit(controller: _phoneController, labelText: 'SDT'),
            TextFieldEdit(controller: _birthdateController, labelText: 'Ngày sinh'),
            SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(300, 60),
                backgroundColor: Color(0xFFf57e9a),
              ),
              child: Text(
                'Hoàn tất chỉnh sửa',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              onPressed: updateInformation,
            ),
          ],
        ),
      ),
    );
  }
}

