import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qlthuvien/pages/TextFieldPassword.dart';
import '../../firebase/customer_firestore.dart';
import '../../models/Customer.dart';

class ChangePasswordPage extends StatefulWidget {
  final Customer customer;

  ChangePasswordPage({Key? key, required this.customer}) : super(key: key);

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  late final TextEditingController _oldPasswordController;
  late final TextEditingController _newPasswordController;
  late final TextEditingController _againnewPasswordController;

  @override
  void initState() {
    super.initState();
    _oldPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _againnewPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _againnewPasswordController.dispose();
    super.dispose();
  }

  void updateInformation() async {
    final oldPassword = _oldPasswordController.text;
    final newPassword = _newPasswordController.text;
    final confirmPassword = _againnewPasswordController.text;

    // Kiểm tra mật khẩu cũ
    if (oldPassword != widget.customer.password) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Mật khẩu cũ không đúng')),
      );
      return;
    }

    // Kiểm tra mật khẩu mới
    if (newPassword.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Mật khẩu mới phải có ít nhất 6 ký tự')),
      );
      return;
    }

    // Kiểm tra nhập lại mật khẩu mới
    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Mật khẩu nhập lại không khớp')),
      );
      return;
    }

    // Cập nhật thông tin mật khẩu mới
    CustomerFireStore customerFireStore = CustomerFireStore();
    Customer updatedCustomer = Customer(
      widget.customer.id,
      widget.customer.fullname,
      widget.customer.phoneNumber,
      widget.customer.birthdate,
      newPassword
    );

    try {
      await customerFireStore.updateInformation(updatedCustomer);
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Có lỗi xảy ra: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFffdee3),
        toolbarHeight: 60,
        title: Text(
          'Đổi mật khẩu',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 40, 20, 10),
        child: Column(
          children: [
            TextFieldEdit(controller: _oldPasswordController, labelText: 'Mật khẩu cũ'),
            TextFieldEdit(controller: _newPasswordController, labelText: 'Mật khẩu mới'),
            TextFieldEdit(controller: _againnewPasswordController, labelText: 'Nhập lại mật khẩu mới'),
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
              onPressed:(){
                updateInformation();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Đổi mật khẩu thành công!')),
                );
              }
            ),
          ],
        ),
      ),
    );
  }
}

