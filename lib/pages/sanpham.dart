import 'package:flutter/material.dart';
import 'package:qlthuvien/pages/productDetail.dart';
import '../firebase/product_firestore.dart';
import '../models/Category.dart';
import '../models/Product.dart';

class ProductPage extends StatefulWidget {
  ProductPage({
    Key?key,
    required this.category,
  }): super (key:key);
  final Category category;

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  List<Product> listProduct = [];
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    List<Product> products = await ProductFireStore().getByCategoryId(widget.category.id);
    setState(() {
      listProduct = products;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFf57e9a),
        leading: Padding(
          padding: const EdgeInsets.only(top: 0.0), // Adjust the padding as needed
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        title: Text(
          widget.category.name,
          style: TextStyle(
            fontFamily: 'PEARL',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              widget.category.image,
              width: 420,
              height: 220,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 0,
                    mainAxisSpacing: 20,
                  ),
                  itemCount: listProduct.length,
                  itemBuilder: (context, index) {
                    Product product = listProduct[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ProductDetailPage(product: product)),
                        );
                      },
                      child: Container(
                        child: Column(
                          children: [
                            Image.network(
                              product.imageUrl,
                              fit: BoxFit.fitWidth,
                              width: 120,
                              height: 150,
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5.0),
                                child: Text(
                                  product.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                '${product.unitPrice} VND',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
