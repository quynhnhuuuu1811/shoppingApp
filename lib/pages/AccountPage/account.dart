import 'package:flutter/material.dart';
import 'package:qlthuvien/pages/AccountPage/OptionAccountPage.dart';
import 'package:qlthuvien/pages/AccountPage/changePassword.dart';
import 'package:qlthuvien/pages/Favorite/favoriteProduct.dart';
import 'package:qlthuvien/pages/Order/orderHistory.dart';
import 'package:qlthuvien/pages/personal_information.dart';
import '../../firebase/customer_firestore.dart';
import '../../models/Customer.dart';

class AccountPage extends StatefulWidget {
  final Customer customer;

  AccountPage({Key? key, required this.customer}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  late Customer customer;

  @override
  void initState() {
    super.initState();
    customer = widget.customer;
    fetchData();
  }

  void fetchData() async {
    try {
      Customer fetchedCustomer = await CustomerFireStore().getById(widget.customer.id);
      setState(() {
        customer = fetchedCustomer;
      });
    } catch (e) {
      // Handle any errors that might occur during the fetch
      print("Failed to fetch customer data: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFFffdee3),
        toolbarHeight: 100,
        title: Padding(
          padding: EdgeInsets.only(top: 35),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(customer.fullname,
                  style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w400
                  )),
              Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>
                            AccountInformationPage(customer: customer),
                        ),
                      );
                    },
                    child: Text('Xem chi tiết >>',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.black
                        )),
                  )
              )
            ],
          ),
        ),
      ),
      body: ListView(
          children: [
            OptionAccountPage(title: 'Danh sách sản phẩm yêu thích', icon: Icons.favorite_rounded, toPage: FavoritePage(customer: customer)),
            OptionAccountPage(title: 'Lịch sử đơn hàng', icon: Icons.history, toPage: OrderHistoryPage(customer: customer)),
            OptionAccountPage(title: 'Đổi mật khẩu', icon: Icons.edit, toPage: ChangePasswordPage(customer: customer)),
          ]
      ),
    );
  }
}

