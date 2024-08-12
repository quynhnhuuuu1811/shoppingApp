import 'package:flutter/material.dart';
import 'package:qlthuvien/firebase/category_firestore.dart';
import 'package:qlthuvien/pages/AccountPage/account.dart';
import 'package:qlthuvien/pages/Cart/cartPage.dart';
import 'package:qlthuvien/pages/productDetail.dart';
import 'package:qlthuvien/pages/sanpham.dart';
import '../firebase/product_firestore.dart';
import '../models/Category.dart';
import '../models/Customer.dart';
import '../models/Product.dart';

class HomePage extends StatefulWidget {
  final Customer customer;

  HomePage({Key? key, required this.customer}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Category> listCategory = [];
  List<Product> listProduct = [];
  List<Product> _filteredProducts = [];
  bool isSearching = false;
  bool selectedSearchIcon = false;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void fetchData() async {
    List<Category> fetchedCategories = await CategoryFireStore().getAllDocuments();
    List<Product> fetchedProducts = await ProductFireStore().getAllDocuments();
    setState(() {
      listCategory = fetchedCategories;
      listProduct = fetchedProducts;
    });
  }

  void _onSearchChanged() {
    filterProducts();
  }

  void filterProducts() {
    List<Product> _products = [];
    _products.addAll(listProduct);
    if (_searchController.text.isNotEmpty) {
      _products.retainWhere((product) {
        String searchTerm = _searchController.text.toLowerCase();
        String productName = product.name.toLowerCase();
        return productName.contains(searchTerm);
      });
    }
    setState(() {
      _filteredProducts = _products;
    });
  }

  void toggleSearch() {
    setState(() {
      isSearching = !isSearching;
      if (!isSearching) {
        _searchController.clear();
        _filteredProducts.clear();
      }
    });
  }

  void toggleSearchIcon()
  {
    setState(() {
      selectedSearchIcon = !selectedSearchIcon;
    });

  }

  @override
  Widget build(BuildContext context) {
    return !isSearching
        ? Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFffdee3),
        toolbarHeight: 70,
        leading: Padding(
          padding: const EdgeInsets.only(top: 0.0),
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        title: const Padding(
          padding: EdgeInsets.only(top: 0),
          child: Text(
            'Clothing Store',
            style: TextStyle(
              color: Colors.black,
              fontSize: 19.4,
              fontWeight: FontWeight.bold,
              fontFamily: 'PEARL',
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.shopping_bag_sharp, color: Colors.black),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CartPage(customer: widget.customer),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.person, color: Colors.black),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AccountPage(customer: widget.customer),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.search, color: Colors.black),
                  onPressed: () {
                    setState(() {
                      toggleSearch();
                    });
                  },
                ),
                Builder(
                  builder: (context) => IconButton(
                    icon: Icon(Icons.density_medium_rounded, color: Colors.black),
                    onPressed: () {
                      Scaffold.of(context).openEndDrawer();
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              GestureDetector(
                  onTap: () {
                    toggleSearch();
                  },
                  child: Image(image: AssetImage('assets/images/#FASHIONDAY.jpg'),)),
              SizedBox(height: 10),
              Divider(thickness: 2,
              color: Colors.black),
            ],
          ),
        ),
      ),
      endDrawer: Drawer(
        width: 250,
        child: Column(
          children: [
            Container(
              height: 100,
              decoration: const BoxDecoration(
                color: Color(0xFFf57e9a),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(0),
                  bottomLeft: Radius.circular(0),
                ),
              ),
              child: const Center(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
                  child: Text(
                    'DANH MỤC',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: listCategory
                    .map(
                      (category) => OptionCategory(
                    category: category,
                    listProductPage: listProduct,
                  ),
                )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    )
        : Scaffold(
      appBar: AppBar(
        title: Row(children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              controller: _searchController,
            ),
          )
        ]),
        leading: Padding(
          padding: const EdgeInsets.only(top: 0.0),
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              toggleSearch();
            },
          ),
        ),
        actions:[
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: IconButton(
              onPressed: () { },
              icon: Icon(Icons.search)
            ),
          )
        ]
      ),
      body: _searchController.text.isNotEmpty && _filteredProducts.isNotEmpty
          ? ListView.builder(
                  itemCount: _filteredProducts.length,
                  itemBuilder: (context, index) {
          return ListTile(
            title: Text(_filteredProducts[index].name),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailPage(product: _filteredProducts[index]),
                ),
              );
            },
          );
                  },
                )
          : Center(
        child: Text('No products found'),
      ),
    );
  }
}

class OptionCategory extends StatelessWidget {
  OptionCategory({
    Key? key,
    required this.category,
    required this.listProductPage,
  }) : super(key: key);

  final Category category;
  final List<Product> listProductPage;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        category.name,
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: () async {
        List<Product> products = await ProductFireStore().getByCategoryId(category.id);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductPage(
              category: category,
            ),
          ),
        );
      },
    );
  }
}
