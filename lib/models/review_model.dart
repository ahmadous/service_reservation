class ReviewModel {
  final String id;
  final String serviceId;
  final String userId;
  final int rating; // Ex : de 1 à 5
  final String comment;

  ReviewModel({
    required this.id,
    required this.serviceId,
    required this.userId,
    required this.rating,
    required this.comment,
  });

  // Convertit un document Firestore en instance de ReviewModel
  factory ReviewModel.fromFirestore(Map<String, dynamic> data, String documentId) {
    return ReviewModel(
      id: documentId,
      serviceId: data['serviceId'] ?? '',
      userId: data['userId'] ?? '',
      rating: data['rating'] ?? 0,
      comment: data['comment'] ?? '',
    );
  }

  // Convertit une instance de ReviewModel en map pour Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'serviceId': serviceId,
      'userId': userId,
      'rating': rating,
      'comment': comment,
    };
  }
}
