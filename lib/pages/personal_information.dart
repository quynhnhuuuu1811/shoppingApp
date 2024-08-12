import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qlthuvien/pages/AccountPage/editInformation.dart';
import '../firebase/customer_firestore.dart';
import '../models/Customer.dart';

class AccountInformationPage extends StatefulWidget {
  final Customer customer;

  AccountInformationPage({Key? key, required this.customer}) : super(key: key);

  @override
  State<AccountInformationPage> createState() => _AccountInformationPageState();
}

class _AccountInformationPageState extends State<AccountInformationPage> {
  late Customer customer;

  @override
  void initState() {
    super.initState();
    customer = widget.customer;
    fetchData();
  }

  void fetchData() async {
    Customer fetchedCustomer = await CustomerFireStore().getById(widget.customer.id);
    setState(() {
      customer = fetchedCustomer;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFffdee3),
        toolbarHeight: 60,
        title:Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text('Thông tin cá nhân',
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.w500
          )),
        )
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30,40,30,10),
          child: Column(
            children:[
              ListInformation(customer: customer,title :'Họ tên', content: customer.fullname),
              SizedBox(height: 30),
              ListInformation(customer: customer,title :'Ngày sinh', content: customer.birthdate),
              SizedBox(height: 30),
              ListInformation(customer: customer,title :'SDT', content: customer.phoneNumber),
              SizedBox(height: 30),
              PasswordInformation(customer: customer, title: 'Mật khẩu',content: customer.password),
              SizedBox(height: 40),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditInformationPage(customer: customer)),
                    );
                  },
                  style:ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFf57e9a),
                    fixedSize: const Size(400, 60),
                  ),
                  child:Text('Chỉnh sửa thông tin cá nhân',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 23,
                          fontWeight: FontWeight.w700
                      ))
              )
            ]
          ),
        )
      )
    );
}
}

class PasswordInformation extends StatefulWidget {
  final String title;
  final String content;
  late Customer customer;

  PasswordInformation({
    super.key,
    required this.customer,
    required this.title,
    required this.content,
  });

  @override
  _PasswordInformationState createState() => _PasswordInformationState();
}

class _PasswordInformationState extends State<PasswordInformation> {
  bool _obscureText = true;

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          widget.title,
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.w500,
          ),
        ),
        Row(
          children: [
            Container(
              width: 200, // Adjust as needed
              child: TextField(
                controller: TextEditingController(text: widget.content),
                enabled: false,
                obscureText: _obscureText,
                decoration: InputDecoration(
                  border: InputBorder.none,
                ),
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 21,
                ),
              ),
            ),
            IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility_off : Icons.visibility,
              ),
              onPressed: _toggleVisibility,
            ),
          ],
        ),
      ],
    );
  }
}

class ListInformation extends StatelessWidget {
  ListInformation({
    super.key,
    required this.customer,
    required this.title,
    required this.content
  });

  final Customer customer;
  late String title;
  late String content;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:MainAxisAlignment.spaceBetween,
      children:[
        Text(title,
        style: TextStyle(
          fontSize: 23,
          fontWeight: FontWeight.w500,
        )
        ),
        Text('${content}',
        style: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 21
        )
        ),
      ]
    );
  }
}
