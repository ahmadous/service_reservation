import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/professional_model.dart';
import '../models/reservation_model.dart';
import '../services/auth_service.dart';
import '../services/reservation_service.dart';

class ProfessionalDetailScreen extends StatefulWidget {
  final ProfessionalModel professional;

  ProfessionalDetailScreen({required this.professional});

  @override
  _ProfessionalDetailScreenState createState() =>
      _ProfessionalDetailScreenState();
}

class _ProfessionalDetailScreenState extends State<ProfessionalDetailScreen> {
  final AuthService _authService = AuthService();
  final ReservationService _reservationService = ReservationService();
  List<ReservationModel> _reservations = [];
  String? _userRole;
  bool _isReservationConfirmed = false;
  String? _confirmedReservationPhoneNumber;

  @override
  void initState() {
    super.initState();
    _loadUserRole();
    _loadReservations();
  }

  // Charge le rôle de l'utilisateur actuel
  Future<void> _loadUserRole() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userRole = await _authService.getUserRole(user.uid);
      setState(() {
        _userRole = userRole;
      });
    }
  }

  // Charge les réservations du professionnel
  Future<void> _loadReservations() async {
    List<ReservationModel> reservations = await _reservationService
        .getReservationsByServiceId(widget.professional.id);
    setState(() {
      _reservations = reservations;
      _checkForConfirmedReservation();
    });
  }

  // Vérifie si l'utilisateur a une réservation confirmée
  void _checkForConfirmedReservation() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final matchingReservations = _reservations.where(
        (reservation) =>
            reservation.userId == currentUser.uid &&
            reservation.status == 'confirmée',
      );

      if (matchingReservations.isNotEmpty) {
        setState(() {
          _isReservationConfirmed = true;
          _confirmedReservationPhoneNumber = widget.professional.phoneNumber;
        });
      } else {
        setState(() {
          _isReservationConfirmed = false;
          _confirmedReservationPhoneNumber = null;
        });
      }
    }
  }

  // Fonction pour confirmer ou annuler la réservation par le professionnel
  Future<void> _updateReservationStatus(
      ReservationModel reservation, String status) async {
    await _reservationService.updateReservationStatus(reservation.id, status);
    _loadReservations();
  }

  // Annuler la réservation par l'utilisateur
  Future<void> _cancelReservationByUser(ReservationModel reservation) async {
    if (reservation.status == 'en attente') {
      await _reservationService.cancelReservationByUser(reservation.id);
      _loadReservations();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text("Vous ne pouvez annuler que les réservations en attente")),
      );
    }
  }

  // Ouvrir le dialogue de réservation
  Future<void> _showReservationDialog() async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xFF0055A4),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (selectedDate != null) {
      TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay(hour: 9, minute: 0),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              timePickerTheme: TimePickerThemeData(
                dialHandColor: Color(0xFF0055A4),
                dialTextColor: Colors.black,
                hourMinuteTextColor: Colors.black,
                dayPeriodTextColor: Colors.black,
                backgroundColor: Colors.white,
              ),
              colorScheme: ColorScheme.light(
                primary: Color(0xFF0055A4),
              ),
            ),
            child: child!,
          );
        },
      );

      if (selectedTime != null) {
        final reservationDateTime = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );

        // Vérifier les conflits de réservation
        bool isConflict = _reservations.any((reservation) =>
            reservation.reservationDateTime == reservationDateTime);

        if (isConflict) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    "Ce créneau est déjà réservé. Veuillez choisir un autre horaire.")),
          );
        } else {
          // Créer la réservation
          await _reservationService.createReservation(
            serviceId: widget.professional.id,
            userId: FirebaseAuth.instance.currentUser!.uid,
            dateTime: reservationDateTime,
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Réservation effectuée avec succès.")),
          );
          _loadReservations();
        }
      }
    }
  }

  // Palette de couleurs
  final Color blueColor = Color(0xFF0055A4);
  final Color whiteColor = Colors.white;
  final Color redColor = Color(0xFFEF4135);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.professional.name,
          style: TextStyle(
            color: whiteColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: blueColor,
        centerTitle: true,
      ),
      floatingActionButton: _userRole == 'client'
          ? FloatingActionButton.extended(
              onPressed: _showReservationDialog,
              icon: Icon(Icons.calendar_today),
              label: Text("Réserver"),
              backgroundColor: redColor,
            )
          : null,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [blueColor, whiteColor, redColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: blueColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Icon(
                  Icons.person,
                  size: 100,
                  color: blueColor,
                ),
              ),
              SizedBox(height: 16),
              Text(
                widget.professional.name,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: blueColor,
                ),
              ),
              SizedBox(height: 8),
              Text(
                widget.professional.jobTitle,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Prix : ${widget.professional.price} FCFA",
                style: TextStyle(fontSize: 22, color: redColor),
              ),
              SizedBox(height: 16),
              Text(
                "Description",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: blueColor),
              ),
              SizedBox(height: 8),
              Text(
                widget.professional.description,
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
              SizedBox(height: 16),
              if (_isReservationConfirmed)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Divider(color: blueColor, thickness: 2),
                    SizedBox(height: 16),
                    Text(
                      "Coordonnées du professionnel",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: blueColor),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Numéro de téléphone : ${_confirmedReservationPhoneNumber}",
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ],
                ),
              Divider(color: blueColor, thickness: 2),
              SizedBox(height: 16),
              Text(
                "Réservations",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: blueColor),
              ),
              SizedBox(height: 8),
              _reservations.isEmpty
                  ? Text(
                      "Aucune réservation pour le moment.",
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: _reservations.length,
                      itemBuilder: (context, index) {
                        final reservation = _reservations[index];
                        final isOwner = reservation.userId ==
                            FirebaseAuth.instance.currentUser?.uid;

                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          elevation: 4.0,
                          child: ListTile(
                            leading: Icon(
                              Icons.calendar_today,
                              color: blueColor,
                            ),
                            title: Text(
                              "Date : ${DateFormat('dd/MM/yyyy à HH:mm').format(reservation.reservationDateTime)}",
                              style: TextStyle(
                                color: blueColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              "Statut : ${reservation.status}",
                              style: TextStyle(
                                color: redColor,
                              ),
                            ),
                            trailing: _userRole == 'prestataire'
                                ? Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.check,
                                            color: Colors.green),
                                        onPressed: () =>
                                            _updateReservationStatus(
                                                reservation, 'confirmée'),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.close,
                                            color: Colors.red),
                                        onPressed: () =>
                                            _updateReservationStatus(
                                                reservation, 'annulée'),
                                      ),
                                    ],
                                  )
                                : (isOwner &&
                                        reservation.status == 'en attente')
                                    ? IconButton(
                                        icon: Icon(Icons.cancel,
                                            color: Colors.red),
                                        onPressed: () =>
                                            _cancelReservationByUser(
                                                reservation),
                                      )
                                    : null,
                          ),
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
