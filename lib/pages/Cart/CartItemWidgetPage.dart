import 'package:flutter/material.dart';
import 'package:qlthuvien/firebase/cart_firestore.dart';
import 'package:qlthuvien/models/Cart.dart';
import 'package:qlthuvien/models/Product.dart';
import '../../firebase/product_firestore.dart';

class CartItemWidget extends StatefulWidget {
  final Cart cart;
  final Function(int) onUpdateTotal;

  const CartItemWidget({super.key, required this.cart, required this.onUpdateTotal});

  @override
  State<CartItemWidget> createState() => _CartItemWidgetState();
}

class _CartItemWidgetState extends State<CartItemWidget> {
  Product? product;
  bool _isSelected = false;

  @override
  void initState() {
    super.initState();
    _isSelected = widget.cart.selected;
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      Product product = await ProductFireStore().getProductById(widget.cart.productId);
      setState(() {
        this.product = product;
        this._isSelected = widget.cart.selected;
      });
    } catch (e) {
      print('Error loading product data: $e');
    }
  }

  int _calculateTotal() {
    if (product != null) {
      return product!.unitPrice * widget.cart.quantity;
    }
    return 0;
  }

  void _toggleSelected() async {
    setState(() {
      _isSelected = !_isSelected;
    });

    await CartFireStore().updateCartSelected(widget.cart.id, _isSelected);

    int totalChange = _calculateTotal();
    if (!_isSelected) {
      totalChange = -totalChange;
    }
    widget.onUpdateTotal(totalChange);
  }

  void _updateQuantity(int newQuantity) async {
    if (newQuantity < 1) return;

    int oldTotal = _calculateTotal();
    await CartFireStore().updateCartQuantity(widget.cart.id, newQuantity);

    setState(() {
      widget.cart.quantity = newQuantity;
    });

    int newTotal = _calculateTotal();
    widget.onUpdateTotal(newTotal - oldTotal);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
              icon: Icon(
                _isSelected ? Icons.check_box : Icons.crop_din_outlined,
                size: 20,
              ),
              onPressed:() {
                _toggleSelected();
              }),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
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
                    SizedBox(width: 5),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product?.name ?? "Lỗi",
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            "${product?.unitPrice ?? ""} VND",
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.red,
                            ),
                          ),
                          Text(
                            'Size: ${widget.cart.selectedSize}',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Số lượng',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 5),
                          Align(
                            alignment: Alignment.center,
                            child: Row(
                              children: [
                                TextButton(
                                  child: const Text(
                                    '-',
                                    style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                  onPressed: () {
                                    _updateQuantity(widget.cart.quantity - 1);
                                  },
                                ),
                                Container(
                                  color: Colors.grey,
                                  width: 30,
                                  height: 30,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      widget.cart.quantity.toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                                TextButton(
                                  child: const Text(
                                    '+',
                                    style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                  onPressed: () {
                                    _updateQuantity(widget.cart.quantity + 1);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
