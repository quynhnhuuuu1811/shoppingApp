import 'package:flutter/material.dart';
import 'signIn.dart';

class signUpPage extends StatelessWidget {
  signUpPage({Key? key}) : super(key: key);
  TextEditingController phoneController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController passController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFFffdee3),
        toolbarHeight: 120,
        title: const Text('Đăng ký',
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
        )),
      ),
      body: SingleChildScrollView(
        child:Padding(
          padding: const EdgeInsets.fromLTRB(15,70,15,20),
          child: Column(
            children:[
              TextFieldSignUp(
                hintText: 'Nhập số điện thoại...',
                labelText: 'Số điện thoại',
                icon: Icons.phone,
                isPassword: false,
                controller: phoneController
              ),
              SizedBox(height: 30),
              TextFieldSignUp(
                  hintText: 'Nhập họ và tên...',
                  labelText: 'Họ và tên',
                  icon: Icons.drive_file_rename_outline_rounded,
                  isPassword: false,
                  controller: nameController
              ),
              SizedBox(height: 30),
              TextFieldSignUp(
                  hintText: 'XX/YY/ZZZZ',
                  labelText: 'Ngày sinh',
                  icon: Icons.date_range,
                  isPassword: false,
                  controller: dateController
              ),
              SizedBox(height: 30),
              TextFieldSignUp(
                  hintText: 'Nhập mật khẩu...',
                  labelText: 'Mật khẩu',
                  icon: Icons.password,
                  isPassword: true ,
                  controller: passController
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                   SnackBar(
                    content: Text('Đã đăng ký thành công!'),
                    duration:Duration(seconds: 1),
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MainHomePage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(300, 60),
                  backgroundColor: Color(0xFFf57e9a),
                ),
                child: const Text(
                  'Đăng ký',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ]
                ),
        ),
      ),
    );
  }}

class TextFieldSignUp extends StatelessWidget {
  TextFieldSignUp({
    super.key,
    required this.hintText,
    required this.icon,
    required this.labelText,
    required this.isPassword,
    required this.controller
  });
  String hintText;
  IconData icon;
  String labelText;
  bool isPassword;
  TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        prefixIcon: Icon(
          icon,
          color: Colors.black,
          size: 35,
        ),
        hintText: hintText,
        labelText: labelText,
        labelStyle: TextStyle(
            color: Colors.black
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFFf545454),
            width: 3,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFF545454),
            width: 3,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}