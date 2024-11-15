import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/professional_model.dart';

class ProfessionalService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Ajoute un nouveau professionnel dans Firestore
  Future<void> addProfessional(ProfessionalModel professional) async {
    await _firestore
        .collection('professionals')
        .add(professional.toFirestore());
  }

  // Met à jour un professionnel existant
  Future<void> updateProfessional(ProfessionalModel professional) async {
    await _firestore
        .collection('professionals')
        .doc(professional.id)
        .update(professional.toFirestore());
  }

  // Récupère les professionnels d'une catégorie spécifique
  Future<List<ProfessionalModel>> getProfessionalsByCategory(
      String category) async {
    QuerySnapshot snapshot = await _firestore
        .collection('professionals')
        .where('category', isEqualTo: category)
        .get();

    return snapshot.docs.map((doc) {
      return ProfessionalModel.fromFirestore(
        doc.data() as Map<String, dynamic>,
        doc.id,
      );
    }).toList();
  }

  // Récupère tous les professionnels
  Future<List<ProfessionalModel>> getAllProfessionals() async {
    QuerySnapshot snapshot = await _firestore.collection('professionals').get();

    return snapshot.docs.map((doc) {
      return ProfessionalModel.fromFirestore(
        doc.data() as Map<String, dynamic>,
        doc.id,
      );
    }).toList();
  }

  // Vous pouvez ajouter d'autres méthodes si nécessaire
}
