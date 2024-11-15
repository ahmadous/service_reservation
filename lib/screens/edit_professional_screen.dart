import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:flutter/services.dart';
import '../models/professional_model.dart';
import '../services/professional_service.dart';

class EditProfessionalScreen extends StatefulWidget {
  final ProfessionalModel professional;

  EditProfessionalScreen({required this.professional});

  @override
  _EditProfessionalScreenState createState() => _EditProfessionalScreenState();
}

class _EditProfessionalScreenState extends State<EditProfessionalScreen> {
  late TextEditingController _nameController;
  late TextEditingController _jobTitleController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  final ProfessionalService _professionalService = ProfessionalService();
  String? _completePhoneNumber; // Variable pour stocker le numéro complet
  String _initialCountryCode = 'FR'; // Code pays par défaut

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.professional.name);
    _jobTitleController =
        TextEditingController(text: widget.professional.jobTitle);
    _descriptionController =
        TextEditingController(text: widget.professional.description);
    _priceController =
        TextEditingController(text: widget.professional.price.toString());
    _completePhoneNumber = widget.professional.phoneNumber;

    // Si le numéro de téléphone est au format international, extraire le code pays
    if (_completePhoneNumber != null && _completePhoneNumber!.startsWith('+')) {
      _initialCountryCode = _extractCountryCode(_completePhoneNumber!);
    }
  }

  // Fonction pour extraire le code pays du numéro de téléphone
  String _extractCountryCode(String phoneNumber) {
    // Implémentation simplifiée, vous pouvez utiliser un package pour une extraction précise
    if (phoneNumber.startsWith('+33')) return 'FR';
    // Ajouter d'autres codes pays si nécessaire
    return 'FR';
  }

  // Fonction pour mettre à jour le professionnel
  Future<void> _updateProfessional() async {
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

    ProfessionalModel updatedProfessional = ProfessionalModel(
      id: widget.professional.id,
      name: _nameController.text.trim(),
      category: widget.professional.category,
      jobTitle: _jobTitleController.text.trim(),
      description: _descriptionController.text.trim(),
      phoneNumber: _completePhoneNumber!.trim(),
      price: double.parse(_priceController.text.trim()),
    );

    try {
      await _professionalService.updateProfessional(updatedProfessional);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Professionnel mis à jour avec succès")),
      );
      Navigator.pop(
          context, updatedProfessional); // Retourne le professionnel mis à jour
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors de la mise à jour : $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Palette de couleurs
    final Color blueColor = Color(0xFF0055A4);
    final Color redColor = Color(0xFFEF4135);

    return Scaffold(
      appBar: AppBar(
        title: Text("Modifier le Professionnel"),
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
              initialCountryCode: _initialCountryCode,
              initialValue: _completePhoneNumber,
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
              onPressed: _updateProfessional,
              child: Text("Enregistrer les modifications"),
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
