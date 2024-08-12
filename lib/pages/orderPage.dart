import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qlthuvien/firebase/cart_firestore.dart';
import 'package:qlthuvien/firebase/order_firestore.dart';
import 'package:qlthuvien/models/Cart.dart';
import 'package:qlthuvien/models/Order.dart' as MyOrder;
import 'package:qlthuvien/models/OrderDetail.dart';
import 'package:qlthuvien/models/Product.dart';
import 'package:qlthuvien/models/Customer.dart';
import 'package:qlthuvien/pages/trangchu.dart';
import '../firebase/OrderDetail_firebase.dart';
import '../firebase/product_firestore.dart';

class OrderPage extends StatefulWidget {
  final Customer customer;

  OrderPage({Key? key, required this.customer}) : super(key: key);

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  List<Cart> carts = [];
  bool isLoading = true;
  int totalAmount = 0;
  TextEditingController addressController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      List<Cart> allCarts = await CartFireStore().getByCustomerId(widget.customer.id);
      List<Cart> selectedCarts = allCarts.where((cart) => cart.selected).toList();
      int initialTotal = 0;

      for (Cart cart in selectedCarts) {
        Product product = await ProductFireStore().getProductById(cart.productId);
        initialTotal += product.unitPrice * cart.quantity;
      }

      setState(() {
        this.carts = selectedCarts;
        this.totalAmount = initialTotal;
        this.isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error loading cart data: $e');
    }
  }


  void calculate(int newTotal) {
    setState(() {
      totalAmount += newTotal;
    });
  }

  void showMessage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 50),
              Container(
                alignment: Alignment.bottomCenter,
                child: Image.asset(
                  'assets/images/giaohang.gif',
                  height: 400,
                  width: 400,
                ),
              ),
              Text('Đơn hàng sẽ được giao tới bạn trong thời gian sớm nhất! Vui lòng kiểm tra điện thoại để nhận được thông báo giao hàng!',
              style: TextStyle(
                fontSize: 25
              )),
              const SizedBox(height: 10),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(
                      customer: widget.customer,
                    ),
                  ),
                );
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }


  void addToOrderandOrderDetail() async {

    try {
      // Create the order entry first
      MyOrder.Order order = MyOrder.Order(
          '',
          FirebaseFirestore.instance.collection('Customer').doc(widget.customer.id),
          DateTime.now(),
          totalAmount.toDouble(),
          addressController.text,
          noteController.text
      );

      await OrderFireStore().insert(order).then((DocumentReference docRef)async{
        for (Cart cartItem in carts) {
          OrderDetail orderDetailItem = OrderDetail(
            '',
            docRef,
            cartItem.productId,
            cartItem.quantity,
            cartItem.selectedSize,
          );
          await OrderDetailFireStore().insert(orderDetailItem);
        }
      });



      await CartFireStore().deleteCarts(carts);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đặt hàng thành công')),
      );

      // Navigate to another page or clear the cart as needed
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error ordering: $e')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFffdee3),
        toolbarHeight: 60,
        title: const Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text(
            'Xác nhận đơn hàng',
            style: TextStyle(fontSize: 23, fontWeight: FontWeight.w500),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFFffdee3),
        height: 120,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Tổng tiền',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '${totalAmount.toString()} VND',
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 120,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFf57e9a),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                child: const Text(
                  'Đặt hàng',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                  ),
                ),
                onPressed:() {
                  addToOrderandOrderDetail();
                  showMessage();
                }
                ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Align(
          alignment: Alignment.center,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10,20,10,10),
                child: TextFieldOrder(
                  hintText: '',
                  icon: Icons.location_on,
                  labelText: 'Địa chỉ',
                  controller: addressController,
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(10,20,10,10),
                child: TextFieldOrder(
                  hintText: 'Lưu ý cho nhà phân phối',
                  icon: Icons.edit_note_rounded,
                  labelText: 'Ghi chú',
                  controller: noteController,
                ),
              ),
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Padding(
                padding: const EdgeInsets.fromLTRB(0, 30, 0, 30),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.7, // Adjust the height as needed
                  child: ListView.builder(
                    itemCount: carts.length,
                    itemBuilder: (context, index) {
                      Cart cart = carts[index];
                      return OrderItemWidget(cart: cart, onUpdateTotal: calculate);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OrderItemWidget extends StatefulWidget {
  final Cart cart;
  final Function(int) onUpdateTotal;

  const OrderItemWidget({super.key, required this.cart, required this.onUpdateTotal});

  @override
  State<OrderItemWidget> createState() => _OrderItemWidgetState();
}

class _OrderItemWidgetState extends State<OrderItemWidget> {
  Product? product;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      Product product = await ProductFireStore().getProductById(widget.cart.productId);
      setState(() {
        this.product = product;
      });
    } catch (e) {
      print('Error loading product data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 80,
                    height: 100,
                    child: Image.network(
                      product?.imageUrl ??
                          'https://firebasestorage.googleapis.com/v0/b/qlthuvien-ff034.appspot.com/o/hinhanh%2Flogo.png?alt=media&token=8c567db1-9c7b-423d-8e68-d154bcbc7219',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset('assets/images/default_product.png');
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product?.name ?? "Lỗi",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "${product?.unitPrice ?? ""} VND",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.red,
                          ),
                        ),
                        Text(
                          'Size: ${widget.cart.selectedSize}',
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 50, 20, 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'x',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          ' ${widget.cart.quantity}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 17,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TextFieldOrder extends StatelessWidget {
  TextFieldOrder({
    super.key,
    required this.hintText,
    required this.icon,
    required this.labelText,
    required this.controller
  });
  String hintText;
  IconData icon;
  String labelText;
  TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
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
            width: 1,
          ),
          borderRadius: BorderRadius.circular(0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFF545454),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(0),
        ),
      ),
    );
  }
}
