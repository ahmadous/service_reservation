class ReservationModel {
  final String id;
  final String serviceId;
  final String userId;
  final DateTime reservationDateTime;
  final String status; // "en attente", "confirmée", ou "annulée"

  ReservationModel({
    required this.id,
    required this.serviceId,
    required this.userId,
    required this.reservationDateTime,
    this.status = 'en attente', // Statut par défaut
  });

  // Convertit un document Firestore en instance de ReservationModel
  factory ReservationModel.fromFirestore(
      Map<String, dynamic> data, String documentId) {
    return ReservationModel(
      id: documentId,
      serviceId: data['serviceId'] ?? '',
      userId: data['userId'] ?? '',
      reservationDateTime: DateTime.parse(
          data['reservationDateTime'] ?? DateTime.now().toIso8601String()),
      status: data['status'] ?? 'en attente',
    );
  }

  // Convertit une instance de ReservationModel en map pour Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'serviceId': serviceId,
      'userId': userId,
      'reservationDateTime': reservationDateTime.toIso8601String(),
      'status': status,
    };
  }
}
