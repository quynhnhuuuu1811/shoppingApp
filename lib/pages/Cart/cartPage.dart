import 'package:flutter/material.dart';
import 'package:qlthuvien/firebase/cart_firestore.dart';
import 'package:qlthuvien/models/Cart.dart';
import 'package:qlthuvien/models/Product.dart';
import 'package:qlthuvien/models/Customer.dart';
import 'package:qlthuvien/pages/Cart/CartItemWidgetPage.dart';
import '../../firebase/product_firestore.dart';
import '../orderPage.dart';


class CartPage extends StatefulWidget {
  final Customer customer;

  CartPage({Key? key, required this.customer}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Cart> carts = [];
  bool isLoading = true;
  int totalAmount = 0;
  bool _isEditMode = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _toggleEditMode() {
    setState(() {
      _isEditMode = !_isEditMode;
    });
  }

  void _deleteCart() async {
    List<String> selectedCartIds = [];
    for (var cart in carts) {
      if (cart.selected) {
        selectedCartIds.add(cart.id);
      }
    }
    for (var id in selectedCartIds) {
      await CartFireStore().delete(id);
    }
    setState(() async {
      await _loadData();
    });
    _toggleEditMode();
  }

  Future<void> _loadData() async {
    try {
      List<Cart> carts = await CartFireStore().getByCustomerId(widget.customer.id);
      int initialTotal = 0;

      for (Cart cart in carts) {
        if (cart.selected) {
          Product product = await ProductFireStore().getProductById(cart.productId);
          initialTotal += product.unitPrice * cart.quantity;

        }
      }

      setState(() {
        this.carts = carts;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFffdee3),
        toolbarHeight: 60,
        title: const Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text(
            'Giỏ hàng',
            style: TextStyle(fontSize: 23, fontWeight: FontWeight.w500),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: IconButton(
              icon: Icon(Icons.edit, size: 25),
              onPressed: _toggleEditMode,
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFFffdee3),
        height: 120,
        child: _isEditMode
            ? Row(
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
                  'Thanh toán',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => OrderPage(customer: widget.customer)),
                  );
                },
              ),
            ),
          ],
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton(
              onPressed: (){
                _deleteCart();
                },
              child: const Text(
                '[Xóa]',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : carts.isNotEmpty
          ? Padding(
        padding: const EdgeInsets.fromLTRB(0, 30, 0, 30),
        child: ListView.builder(
          itemCount: carts.length,
          itemBuilder: (context, index) {
            Cart cart = carts[index];
            return CartItemWidget(cart: cart, onUpdateTotal: calculate);
          },
        ),
      )
          : const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.production_quantity_limits_rounded, size: 35, color: Colors.grey),
            Text(
              'Không có sản phẩm nào trong giỏ hàng',
              style: TextStyle(fontSize: 20, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
