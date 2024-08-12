import 'package:flutter/material.dart';
import 'package:qlthuvien/firebase/order_firestore.dart';
import 'package:qlthuvien/models/Order.dart';
import 'package:qlthuvien/models/Customer.dart';
import 'package:qlthuvien/pages/OrderDetail/orderDetailHistory.dart';

class OrderHistoryPage extends StatefulWidget {
  final Customer customer;

  OrderHistoryPage({Key? key, required this.customer}) : super(key: key);

  @override
  _OrderHistoryPageState createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  List<Order> orders = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    try {
      List<Order> fetchedOrders = await OrderFireStore().getByCustomerId(widget.customer.id);
      setState(() {
        orders = fetchedOrders;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching data: $e");
      setState(() {
        isLoading = false;
      });
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
            'Lịch sử đơn hàng',
            style: TextStyle(fontSize: 23, fontWeight: FontWeight.w500),
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 30, 0, 30),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.7,
                child: ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    Order order = orders[index];
                    return OrderItemWidget(order: order);
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class OrderItemWidget extends StatefulWidget {
  final Order order;

  const OrderItemWidget({super.key, required this.order});

  @override
  State<OrderItemWidget> createState() => _OrderItemWidgetState();
}

class _OrderItemWidgetState extends State<OrderItemWidget> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Mã đơn hàng: ${widget.order.id}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              OrderInformation(widget: widget, title: 'Địa chỉ', content: widget.order.address, num: 200),
              OrderInformation(widget: widget, title: 'Ghi chú', content: widget.order.note, num: 195),
              Divider(),
              OrderInformation(widget: widget, title: 'Thành tiền', content: '${widget.order.totalAmount} VND', num: 170),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                    onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => OrderDetailPage(order: widget.order)),
                      );
                    },
                    child: const Text('Xem chi tiết >>',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ))
                ),
              )
            ],
          ),
        ),

      ),
    );
  }
}

class OrderInformation extends StatelessWidget {
  const OrderInformation({
    super.key,
    required this.widget,
    required this. title,
    required this. content,
    required this.num ,


  });

  final OrderItemWidget widget;
  final String title;
  final String content;
  final double num;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children:[
        Text(title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500
        )
        ),
        SizedBox(width: num ),
        Expanded(
          child: Text(content,
          style: const TextStyle(
            fontSize: 19
          ),
            overflow: TextOverflow.visible
          ),
        )
      ]
    );
  }
}
