import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/reservation_model.dart';

class ReservationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Crée une nouvelle réservation dans Firestore
  Future<void> createReservation({
    required String serviceId,
    required String userId,
    required DateTime dateTime,
  }) async {
    final reservation = ReservationModel(
      id: '', // L'ID sera généré automatiquement par Firestore
      serviceId: serviceId,
      userId: userId,
      reservationDateTime: dateTime,
      status: 'en attente',
    );

    await _firestore.collection('reservations').add(reservation.toFirestore());
  }

  // Récupère les réservations pour un service spécifique
  Future<List<ReservationModel>> getReservationsByServiceId(
      String serviceId) async {
    final snapshot = await _firestore
        .collection('reservations')
        .where('serviceId', isEqualTo: serviceId)
        .get();

    return snapshot.docs.map((doc) {
      return ReservationModel.fromFirestore(doc.data(), doc.id);
    }).toList();
  }

  // Met à jour le statut de la réservation (par exemple, pour confirmer ou annuler)
  Future<void> updateReservationStatus(
      String reservationId, String status) async {
    await _firestore
        .collection('reservations')
        .doc(reservationId)
        .update({'status': status});
  }

  // Annule une réservation par l'utilisateur si elle est en attente
  Future<void> cancelReservationByUser(String reservationId) async {
    final doc =
        await _firestore.collection('reservations').doc(reservationId).get();
    final reservation = ReservationModel.fromFirestore(
        doc.data() as Map<String, dynamic>, doc.id);

    if (reservation.status == 'en attente') {
      await updateReservationStatus(reservationId, 'annulée');
    }
  }

  Future<List<ReservationModel>> getReservationsByUserId(String userId) async {
    QuerySnapshot snapshot = await _firestore
        .collection('reservations')
        .where('userId', isEqualTo: userId)
        .get();

    return snapshot.docs.map((doc) {
      return ReservationModel.fromFirestore(
        doc.data() as Map<String, dynamic>,
        doc.id,
      );
    }).toList();
  }

  // Récupère l'ID de l'utilisateur actuel
  String getCurrentUserId() {
    return FirebaseAuth.instance.currentUser?.uid ?? '';
  }
}
