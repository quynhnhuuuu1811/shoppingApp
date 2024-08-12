import 'package:flutter/material.dart';
import 'package:qlthuvien/models/Product.dart';
import 'package:qlthuvien/firebase/product_firestore.dart';

import '../../firebase/OrderDetail_firebase.dart';
import '../../models/Order.dart';
import '../../models/OrderDetail.dart';

class OrderDetailPage extends StatefulWidget {
  final Order order;

  const OrderDetailPage({Key? key, required this.order}) : super(key: key);

  @override
  _OrderDetailPageState createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  List<OrderDetail> orderdetails = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    List<OrderDetail> orderdetail = await OrderDetailFireStore().getByOrderId(widget.order.id);
    setState(() {
      orderdetails = orderdetail;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFffdee3),
        toolbarHeight: 80,
        title: const Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text(
            'Chi tiết đơn hàng đã đặt',
            style: TextStyle(fontSize: 23, fontWeight: FontWeight.w500),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.location_on),
                  SizedBox(width: 10),
                  Text(
                    'Địa chỉ giao hàng',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(width: 65),
                  Text(
                    '${widget.order.address}',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
              Divider(),
              SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true, // This allows the ListView to take only the space it needs.
                physics: NeverScrollableScrollPhysics(), // Disable scrolling for the ListView.
                itemCount: orderdetails.length,
                itemBuilder: (context, index) {
                  OrderDetail orderdetailItem = orderdetails[index];
                  return OrderDetailItemWidget(orderdetail: orderdetailItem);
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  children: [
                    Icon(Icons.note_outlined),
                    SizedBox(width: 10),
                    Text(
                      'Ghi chú:',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(width: 150),
                    Text(
                      '${widget.order.note}',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(),
              SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    'Tổng tiền',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(width: 100),
                  Text(
                    '${widget.order.totalAmount} VND',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
