import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qlthuvien/models/Product.dart';
import 'package:qlthuvien/models/Customer.dart';
import 'package:qlthuvien/pages/Favorite/FavoriteItemWidget.dart';
import '../../firebase/favorite_firestore.dart';
import '../../firebase/product_firestore.dart';
import '../../models/Favorite.dart';

class FavoritePage extends StatefulWidget {
  final Customer customer;

  FavoritePage({Key? key, required this.customer}) : super(key: key);

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  List<Favorite> favorites = [];
  Map<String, Product> productMap = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      List<Favorite> favorites = await FavoriteFireStore().getByCustomerId(widget.customer.id);
      Map<String, Product> fetchedProducts = {};

      for (Favorite favorite in favorites) {
        Product product = await ProductFireStore().getProductById(favorite.productId);
        fetchedProducts[favorite.productId.id] = product;
      }

      setState(() {
        this.favorites = favorites;
        this.productMap = fetchedProducts;
        this.isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error loading favorite data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        title: const Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text(
            'Sản phẩm yêu thích',
            style: TextStyle(fontSize: 23, fontWeight: FontWeight.w500),
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : favorites.isNotEmpty
          ? Padding(
        padding: const EdgeInsets.fromLTRB(0, 30, 0, 30),
        child: ListView.builder(
          itemCount: favorites.length,
          itemBuilder: (context, index) {
            Favorite favorite = favorites[index];
            Product? product = productMap[favorite.productId.id];
            return product != null
                ? FavoriteItemWidget(product: product)
                : Container(); // Handle the case where product is null
          },
        ),
      )
          : const Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.favorite_border, size: 35, color: Colors.grey),
              Text('No products in favorites',
                  style: TextStyle(fontSize: 20, color: Colors.grey))
            ]),
      ),
    );
  }
}

