class CategoryModel {
  final String id;
  final String name;
  final String? description;
  final String? imageUrl;

  CategoryModel({
    required this.id,
    required this.name,
    this.description,
    this.imageUrl,
  });

  // Convertit un document Firestore en instance de CategoryModel
  factory CategoryModel.fromFirestore(Map<String, dynamic> data, String documentId) {
    return CategoryModel(
      id: documentId,
      name: data['name'] ?? '',
      description: data['description'],
      imageUrl: data['imageUrl'],
    );
  }

  // Convertit une instance de CategoryModel en map pour Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
    };
  }
}
