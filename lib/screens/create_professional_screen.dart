import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:flutter/services.dart';
import '../models/professional_model.dart';
import '../services/professional_service.dart';

class CreateProfessionalScreen extends StatefulWidget {
  final String categoryName;

  CreateProfessionalScreen({required this.categoryName});

  @override
  _CreateProfessionalScreenState createState() =>
      _CreateProfessionalScreenState();
}

class _CreateProfessionalScreenState extends State<CreateProfessionalScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _jobTitleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final ProfessionalService _professionalService = ProfessionalService();
  String? _completePhoneNumber; // Variable pour stocker le numéro complet

  // Fonction pour créer un professionnel
  Future<void> _createProfessional() async {
    if (_nameController.text.isEmpty ||
        _jobTitleController.text.isEmpty ||
        _completePhoneNumber == null ||
        _priceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Veuillez remplir tous les champs obligatoires")),
      );
      return;
    }

    ProfessionalModel newProfessional = ProfessionalModel(
      id: '', // L'ID sera généré par Firestore
      name: _nameController.text.trim(),
      category: widget.categoryName,
      jobTitle: _jobTitleController.text.trim(),
      description: _descriptionController.text.trim(),
      phoneNumber: _completePhoneNumber!.trim(),
      price: double.parse(_priceController.text.trim()),
    );

    await _professionalService.addProfessional(newProfessional);
    Navigator.pop(context,
        newProfessional); // Retourne le nouveau professionnel pour mettre à jour la liste
  }

  @override
  Widget build(BuildContext context) {
    // Palette de couleurs
    final Color blueColor = Color(0xFF0055A4);
    final Color redColor = Color(0xFFEF4135);

    return Scaffold(
      appBar: AppBar(
        title: Text("Ajouter un Professionnel"),
        backgroundColor: blueColor, // Couleur bleue
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Champ pour le nom du professionnel
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "Nom du Professionnel *",
                border: OutlineInputBorder(),
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp("[a-zA-ZÀ-ÿ0-9 ]")),
              ],
            ),
            SizedBox(height: 16),
            // Champ pour le titre de poste
            TextField(
              controller: _jobTitleController,
              decoration: InputDecoration(
                labelText: "Titre de poste *",
                border: OutlineInputBorder(),
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp("[a-zA-ZÀ-ÿ0-9 ]")),
              ],
            ),
            SizedBox(height: 16),
            // Champ pour le numéro de téléphone
            IntlPhoneField(
              decoration: InputDecoration(
                labelText: 'Numéro de téléphone *',
                border: OutlineInputBorder(),
              ),
              initialCountryCode: 'FR',
              onChanged: (phone) {
                _completePhoneNumber = phone.completeNumber;
              },
              onCountryChanged: (country) {
                print('Code du pays changé en : ' + country.name);
              },
            ),
            SizedBox(height: 16),
            // Champ pour la description
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: "Description",
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                    RegExp("[a-zA-ZÀ-ÿ0-9 .,!?'-]")),
              ],
            ),
            SizedBox(height: 16),
            // Champ pour le prix
            TextField(
              controller: _priceController,
              decoration: InputDecoration(
                labelText: "Prix (FCFA) *",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _createProfessional,
              child: Text("Créer le Professionnel"),
              style: ElevatedButton.styleFrom(
                backgroundColor: blueColor, // Couleur bleue
              ),
            ),
          ],
        ),
      ),
    );
  }
}
