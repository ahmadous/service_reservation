import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/category_model.dart';

class CategoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Ajoute une catégorie dans Firestore
  Future<void> addCategory(CategoryModel category) async {
    await _firestore.collection('categories').add(category.toFirestore());
  }

  // Récupère toutes les catégories
  Future<List<CategoryModel>> getCategories() async {
    QuerySnapshot snapshot = await _firestore.collection('categories').get();
    return snapshot.docs.map((doc) {
      return CategoryModel.fromFirestore(
          doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  }

  Future<void> deleteCategory(String categoryId) async {
    await _firestore.collection('categories').doc(categoryId).delete();
  }

  Future<void> updateCategory(
      String categoryId, Map<String, dynamic> data) async {
    await _firestore.collection('categories').doc(categoryId).update(data);
  }
}
