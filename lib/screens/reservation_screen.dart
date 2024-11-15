import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/reservation_service.dart';
import '../models/reservation_model.dart';

class ReservationScreen extends StatelessWidget {
  final String serviceId;
  final DateTime reservationDateTime;

  ReservationScreen({
    required this.serviceId,
    required this.reservationDateTime,
  });

  final ReservationService _reservationService = ReservationService();

  // Fonction pour confirmer et envoyer la réservation
  Future<void> _sendReservation(BuildContext context) async {
    try {
      // Créer la réservation et l'ajouter dans Firestore
      await _reservationService.createReservation(
        serviceId: serviceId,
        userId: _reservationService.getCurrentUserId(),
        dateTime: reservationDateTime,
      );

      // Afficher une notification pour confirmer la réservation
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Réservation envoyée au prestataire.")),
      );

      // Retourner à la page précédente
      Navigator.pop(context);
    } catch (e) {
      // En cas d'erreur, afficher un message d'erreur
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors de la réservation : $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color blueColor = Color(0xFF0055A4);
    final Color redColor = Color(0xFFEF4135);

    return Scaffold(
      appBar: AppBar(
        title: Text("Confirmation de la Réservation"),
        backgroundColor: blueColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Date et heure de réservation :",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "${DateFormat('dd/MM/yyyy').format(reservationDateTime)} à ${DateFormat('HH:mm').format(reservationDateTime)}",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              "Service ID : $serviceId",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () => _sendReservation(context),
                child: Text("Confirmer la Réservation"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: redColor,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  textStyle:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
