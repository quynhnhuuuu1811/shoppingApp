import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../User/Storage.dart';
import '../firebase/product_firestore.dart';
import '../firebase/cart_firestore.dart';
import '../firebase/favorite_firestore.dart';
import '../models/Product.dart';
import '../models/Cart.dart';
import '../models/Favorite.dart';

class ProductDetailPage extends StatefulWidget {
  ProductDetailPage({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Product product;

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  late Product product;
  String? selectedSize;
  late bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    product = widget.product;
    checkIfFavorite();
  }

  void selectSize(String size) {
    setState(() {
      selectedSize = size;
    });
  }

  void showSizeGuide() {
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
                  'assets/images/SIZE.png',
                  height: 200,
                  width: 600,
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void addToCart() async {
    if (selectedSize == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a size')),
      );
      return;
    }

    DocumentReference customerRef = FirebaseFirestore.instance.collection('Customer').doc(Uid);
    DocumentReference productRef = FirebaseFirestore.instance.collection('Product').doc(product.id);

    Cart cartItem = Cart(
        '',
        customerRef,
        productRef,
        1,
        selectedSize!,
        false
    );

    try {
      await CartFireStore().insert(cartItem);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Product added to cart')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding to cart: $e')),
      );
    }
  }

  Future<void> checkIfFavorite() async {
    List<Favorite> favorites = await FavoriteFireStore().getByCustomerId(Uid!);
    setState(() {
      isFavorite = favorites.any((fav) => fav.productId.id == product.id);
    });
  }

  Future<void> toggleFavorite() async {
    if (isFavorite) {
      await FavoriteFireStore().removeFavorite(Uid!, product.id);
    } else {
      DocumentReference customerRef = FirebaseFirestore.instance.collection('Customer').doc(Uid);
      DocumentReference productRef = FirebaseFirestore.instance.collection('Product').doc(product.id);

      Favorite favoriteItem = Favorite(
        '',
        customerRef,
        productRef,
      );

      await FavoriteFireStore().addFavorite(favoriteItem);
    }
    checkIfFavorite();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chi tiết sản phẩm',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // Sử dụng icon mũi tên quay về mặc định của Flutter
          onPressed: () {
            Navigator.pop(context,isFavorite);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.network(
                product.imageUrl,
                width: 400,
                height: 470,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product.name,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.black,
                        size: 36,
                      ),
                      onPressed: toggleFavorite,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Size',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Row(
                children: product.size.map((size) {
                  return GestureDetector(
                    onTap: () => selectSize(size),
                    child: OptionSize(
                      size: size,
                      isSelected: selectedSize == size,
                    ),
                  );
                }).toList(),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: showSizeGuide,
                  child: const Text(
                    'Hướng dẫn lựa chọn size',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontSize: 21,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Mô tả sản phẩm',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ShowDescription(product: product, title: 'Color', content: 'Color'),
              const SizedBox(height: 10),
              ShowDescription(product: product, title: 'Design', content: 'Design'),
              const SizedBox(height: 10),
              ShowDescription(product: product, title: 'Fabric', content: 'Fabric'),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: addToCart,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFf57e9a),
                  fixedSize: const Size(300, 60),
                ),
                child: const Text(
                  'Thêm vào giỏ hàng',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
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

class ShowDescription extends StatelessWidget {
  const ShowDescription({
    Key? key,
    required this.product,
    required this.title,
    required this.content,
  }) : super(key: key);

  final Product product;
  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title:',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 23,
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.italic,
            ),
          ),
          Text(
            '${product.description[content]}',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

class OptionSize extends StatelessWidget {
  final String size;
  final bool isSelected;
  OptionSize({
    Key? key,
    required this.size,
    required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
      child: Container(
        alignment: Alignment.center,
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFFffdee3) : Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isSelected ? Colors.red : Colors.transparent, width: 2),
        ),
        child: Text(
          size,
          style: const TextStyle(
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
