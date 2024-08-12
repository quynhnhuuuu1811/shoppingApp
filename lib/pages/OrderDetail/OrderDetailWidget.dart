import 'package:flutter/material.dart';
import 'package:qlthuvien/models/OrderDetail.dart';
import 'package:qlthuvien/models/Product.dart';
import 'package:qlthuvien/firebase/product_firestore.dart';

class OrderDetailItemWidget extends StatefulWidget {
  final OrderDetail orderdetail;

  const OrderDetailItemWidget({super.key, required this.orderdetail});
  @override
  State<OrderDetailItemWidget> createState() => _OrderDetailItemWidgetState();
}

class _OrderDetailItemWidgetState extends State<OrderDetailItemWidget> {
  Product? product;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      if (widget.orderdetail.productId != null) {
        Product product = await ProductFireStore().getProductByIdforOrderDetail(widget.orderdetail.productId);
        setState(() {
          this.product = product;
        });
      } else {
        print("productId is null");
      }
    } catch (e) {
      print('Error loading product data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisSize: MainAxisSize.min,
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
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.red,
                  ),
                ),
                Text(
                  'Size: ${widget.orderdetail.selectedSize}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Số lượng',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 5),
              Text(
                '${widget.orderdetail.orderQuantity}',
                style: TextStyle(fontSize: 18),
              )
            ],
          ),
        ],
      ),
    );
  }
}
