  import 'package:cloud_firestore/cloud_firestore.dart';

  import '../models/Category.dart';


  class CategoryFireStore  {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final String _collection = 'Category';


    Future<void> delete(String id) async {
      try {
        await _firestore.collection(_collection).doc(id).delete();
      } catch (e) {
        print("Error: $e");
        rethrow;
      }
    }



    Future<Category> getById(String id) async {
      try {
        DocumentSnapshot<Map<String, dynamic>> doc = await _firestore.collection(_collection).doc(id).get();
        return Category(doc.id,doc['name'], doc['image']);
      } catch (e) {
        print("Error: $e");
        rethrow;
      }
    }


    Future<void> insert(Category data) async {
      try {
        await _firestore.collection(_collection).add({
          'name':data.name,
        });
      } catch (e) {
        print("Error: $e");
        rethrow;
      }
    }


    Future<void> update(Category data) async {
      try {
        await _firestore.collection(_collection).doc(data.id).update({
          'name': data.name
        });
      } catch (e) {
        print("Error: $e");
        rethrow;
      }
    }

    Future<List<Category>> getAllDocuments() async {
      List<Category> category = [];
      try {
        QuerySnapshot querySnapshot = await _firestore.collection(_collection).get();
        List<DocumentSnapshot> documents = querySnapshot.docs;
        print("Document:$documents");
        for (var doc in documents) {
          Category cate = Category(doc.id, doc['name'], doc['image']);

          category.add(cate);
        }
      } catch (e) {
        print('Error getting documents: $e');
      }
      return category;
    }

    Future<String> getName(DocumentReference? categoryId) async {
      DocumentSnapshot documentSnapshot = await categoryId!.get();
      late String name;
      try {
        if (documentSnapshot.exists) {
          dynamic data = documentSnapshot.data();
          name = data['name'];
        } else {
          // Dữ liệu không tồn tại
        }
      } catch (e) {
        print('Error getting documents: $e');
      }
      return name;
    }

    Future<String> getId(DocumentReference? categoryId) async{
      DocumentSnapshot documentSnapshot = await categoryId!.get();
      late String id;
      try {
        if (documentSnapshot.exists) {
          id = documentSnapshot.id;
        } else {

        }
      } catch (e) {
        print('Error getting documents: $e');
      }
      return id;
    }
  }
