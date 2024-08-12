import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qlthuvien/models/Product.dart';

class ProductFireStore  {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'Product';

  Future<void> delete(String id) async {
    try {
      await _firestore.collection(_collection).doc(id).delete();
    } catch (e) {
      print("Error:$e");
    }
  }

  Future<List<Product>> getAllDocuments() async {
    List<Product> products = [];
    try {
      QuerySnapshot querySnapshot = await _firestore.collection(_collection).get();
      List<DocumentSnapshot> documents = querySnapshot.docs;
      for (var doc in documents) {
        var data = doc.data() as Map<String, dynamic>; // Ép kiểu sang Map<String, dynamic>
        int unitPrice = data['unitPrice'].toInt();
        DocumentReference? categoryIdRef = data['categoryId'];

        Product product = Product(
            doc.id,
            data['name'],
            unitPrice,
            data['image_url'],
            categoryIdRef,
            Map<String, dynamic>.from(data['description']), // Thay đổi ở đây
            List<String>.from(data['size'] ?? []),
        );
        products.add(product);
      }
    } catch (e) {
      print('Error getting documents: $e');
      rethrow; // Rethrow để cho phép các phần khác của ứng dụng xử lý lỗi này nếu cần
    }

    return products;
  }

  Future<Product> getById(String id) {
    try {
      return _firestore.collection(_collection).doc(id).get().then((doc) => Product.fromFirestore(doc));
    } catch (e) {
      print("Error:$e");
      rethrow;
    }
  }

  Future<List<Product>> getByCategoryId(String categoryId) async {
    try {
      DocumentReference categoryRef = _firestore.collection('Category').doc(categoryId); // Sửa thành 'Category'
      QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection(_collection)
          .where('categoryId', isEqualTo: categoryRef)
          .get();
      List<Product> products = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        int unitPrice = data['unitPrice'];
        return Product(
            doc.id,
            data['name'] ?? '',
            unitPrice,
            data['image_url'] ?? '',
            data['categoryId'],
            Map<String, dynamic>.from(data['description'] ?? {}), // Thay đổi ở đây
            List<String>.from(data['size'] ?? []),
        );
      }).toList();
      return products;
    } catch (e) {
      print("Error: $e");
      rethrow;
    }
  }



  Future<Product> getProductById(DocumentReference productId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> doc = await _firestore.collection(_collection).doc(productId.id).get();

      return Product(
          doc.id,
          doc['name'],
          doc['unitPrice'],
          doc['image_url'],
          doc['categoryId'],
          Map<String, dynamic>.from(doc['description']),
          List<String>.from(doc['size'] ?? []),
      );
    } catch (e) {
      print("Error: $e");
      rethrow; // Ném ngoại lệ để báo lỗi nếu có
    }
  }

  Future<Product> getProductByIdforOrderDetail(DocumentReference? productId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> doc = await _firestore.collection(_collection).doc(productId?.id).get();

      return Product(
          doc.id,
          doc['name'],
          doc['unitPrice'],
          doc['image_url'],
          doc['categoryId'],
          Map<String, dynamic>.from(doc['description']),
          List<String>.from(doc['size'] ?? []),
      );
    } catch (e) {
      print("Error: $e");
      rethrow; // Ném ngoại lệ để báo lỗi nếu có
    }
  }
  Future<void> updateFavoriteStatus(String id, bool isFavorite) async {
    try {
      await _firestore.collection(_collection).doc(id).update({'favorite': isFavorite});

    } catch (e) {
      print("Error updating favorite status: $e");
      rethrow;
    }
  }
  Future<List<Product>> getFavoriteProduct() async {
    List<Product> favoriteProducts = [];
    try {
      QuerySnapshot querySnapshot = await _firestore.collection(_collection).where('favorite', isEqualTo: true).get();
      List<DocumentSnapshot> documents = querySnapshot.docs;
      for (var doc in documents) {
        var data = doc.data() as Map<String, dynamic>; // Cast to Map<String, dynamic>
        int unitPrice = data['unitPrice'].toInt(); // Convert unitPrice to int
        DocumentReference? categoryIdRef = data['categoryId'];

        Product product = Product(
          doc.id,
          data['name'],
          unitPrice,
          data['image_url'],
          categoryIdRef,
          Map<String, dynamic>.from(data['description']), // Cast description to Map<String, dynamic>
          List<String>.from(data['size'] ?? []),
        );
        favoriteProducts.add(product);
      }
    } catch (e) {
      print('Error getting favorite products: $e');
      rethrow; // Rethrow to allow other parts of the app to handle this error if needed
    }
    return favoriteProducts; // Return the list of favorite products
  }

  Future<List<Product>> searchProductsByName(String query) async {
    List<Product> products = [];
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection(_collection)
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThanOrEqualTo: query + '\uf8ff')
          .get();
      List<DocumentSnapshot> documents = querySnapshot.docs;
      for (var doc in documents) {
        var data = doc.data() as Map<String, dynamic>; // Cast to Map<String, dynamic>
        int unitPrice = data['unitPrice'].toInt();
        DocumentReference? categoryIdRef = data['categoryId'];

        Product product = Product(
          doc.id,
          data['name'],
          unitPrice,
          data['image_url'],
          categoryIdRef,
          Map<String, dynamic>.from(data['description']),
          List<String>.from(data['size'] ?? []),
        );
        products.add(product);
      }
    } catch (e) {
      print('Error searching products: $e');
      rethrow;
    }
    return products;
  }
}
