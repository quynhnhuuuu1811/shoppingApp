import 'package:flutter/material.dart';
import 'package:qlthuvien/pages/signup.dart';
import 'package:qlthuvien/pages/trangchu.dart';
import '../User/Storage.dart';
import '../bloc/auth_bloc.dart';
import '../firebase/customer_firestore.dart';
import '../models/Customer.dart';

class MainHomePage extends StatefulWidget {
  MainHomePage({Key? key}) : super(key: key);

  @override
  State<MainHomePage> createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController passController = TextEditingController();

  void onClick() {
    AuthBloc().signIn(phoneController.text, passController.text, onSuccess, onError);
  }

  void onSuccess() async {
    Customer? customer = await CustomerFireStore().getByPhone(phoneController.text);
    if (customer != null) {
      setCurrentId(customer.id);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage(customer: customer)),
      );
    }
  }

  void onError(String error) {
    print(error);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15, 60, 15, 0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Image(image: AssetImage('assets/images/logo.png')),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.account_box,
                    color: Color(0xFFf57e9a),
                    size: 35,
                  ),
                  hintText: 'Nhập số điện thoại',
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xFFf545454),
                      width: 3,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xFF545454),
                      width: 3,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              TextField(
                obscureText: true,
                controller: passController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.key,
                    color: Color(0xFFf57e9a),
                    size: 35,
                  ),
                  hintText: 'Nhập mật khẩu',
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xFFf545454),
                      width: 3,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xFF545454),
                      width: 3,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: onClick,
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(300, 60),
                  backgroundColor: Color(0xFFf57e9a),
                ),
                child: const Text(
                  'Đăng nhập',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:[
                  Text('Chưa có tài khoản?',
                      style: TextStyle(
                        fontSize: 18,
                      )),
                  TextButton(
                      onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => signUpPage()),
                        );
                      },
                      child: Text('Đăng kí ngay',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ))
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
