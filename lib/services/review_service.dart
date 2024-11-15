import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/review_model.dart';

class ReviewService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Ajoute un avis dans Firestore
  Future<void> addReview(ReviewModel review) async {
    await _firestore.collection('reviews').add(review.toFirestore());
  }

  // Récupère tous les avis d'un service spécifique
  Future<List<ReviewModel>> getReviewsByServiceId(String serviceId) async {
    QuerySnapshot snapshot = await _firestore.collection('reviews')
        .where('serviceId', isEqualTo: serviceId)
        .get();

    return snapshot.docs.map((doc) {
      return ReviewModel.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  }
}
