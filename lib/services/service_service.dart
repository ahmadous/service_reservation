import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/service_model.dart';

class ServiceService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Ajoute un service dans Firestore
  Future<void> addService(ServiceModel service) async {
    await _firestore.collection('services').add(service.toFirestore());
  }

  // Récupère tous les services d'un prestataire spécifique
  Future<List<ServiceModel>> getServicesByProviderId(String providerId) async {
    QuerySnapshot snapshot = await _firestore.collection('services')
        .where('providerId', isEqualTo: providerId)
        .get();

    return snapshot.docs.map((doc) {
      return ServiceModel.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  }
}
