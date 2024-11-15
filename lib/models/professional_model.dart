class ProfessionalModel {
  final String id;
  final String name; // Nom du professionnel
  final String category; // Catégorie (ex., Développeur, Plombier)
  final String jobTitle; // Titre de poste (ex., Développeur Mobile)
  final String description; // Description des compétences et services
  final String phoneNumber; // Numéro de téléphone du professionnel
  final double price; // Prix du service

  ProfessionalModel({
    required this.id,
    required this.name,
    required this.category,
    required this.jobTitle,
    required this.description,
    required this.phoneNumber,
    required this.price,
  });

  // Convertit un document Firestore en instance de ProfessionalModel
  factory ProfessionalModel.fromFirestore(
      Map<String, dynamic> data, String documentId) {
    return ProfessionalModel(
      id: documentId,
      name: data['name'] ?? '',
      category: data['category'] ?? '',
      jobTitle: data['jobTitle'] ?? '',
      description: data['description'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
    );
  }

  // Convertit une instance de ProfessionalModel en map pour Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'category': category,
      'jobTitle': jobTitle,
      'description': description,
      'phoneNumber': phoneNumber,
      'price': price,
    };
  }
}
