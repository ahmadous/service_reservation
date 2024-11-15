class ServiceModel {
  final String id;
  final String name;
  final String category;
  final String providerId; // ID du prestataire (l'utilisateur qui crée le service)
  final String? serviceImageUrl; // URL de l'image du service (optionnel)

  ServiceModel({
    required this.id,
    required this.name,
    required this.category,
    required this.providerId,
    this.serviceImageUrl,
  });

  // Convertit un document Firestore en instance de ServiceModel
  factory ServiceModel.fromFirestore(Map<String, dynamic> data, String documentId) {
    return ServiceModel(
      id: documentId,
      name: data['name'] ?? '',
      category: data['category'] ?? '',
      providerId: data['providerId'] ?? '',
      serviceImageUrl: data['serviceImageUrl'],
    );
  }

  // Convertit une instance de ServiceModel en map pour Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'category': category,
      'providerId': providerId,
      'serviceImageUrl': serviceImageUrl,
    };
  }
}
