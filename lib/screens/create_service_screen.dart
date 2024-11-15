import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/service_model.dart';
import '../services/service_service.dart';

class CreateServiceScreen extends StatefulWidget {
  final String providerId; // ID du prestataire actuel

  CreateServiceScreen({required this.providerId});

  @override
  _CreateServiceScreenState createState() => _CreateServiceScreenState();
}

class _CreateServiceScreenState extends State<CreateServiceScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final ServiceService _serviceService = ServiceService();
  String? _imageUrl; // URL de l'image si une image est uploadée (optionnel)

  void _createService() async {
    // Crée un modèle de service avec les informations fournies
    ServiceModel newService = ServiceModel(
      id: '', // ID sera généré par Firestore
      name: _nameController.text.trim(),
      category: _categoryController.text.trim(),
      providerId: widget.providerId,
      serviceImageUrl: _imageUrl,
    );

    await _serviceService.addService(newService);
    Navigator.pop(context); // Retourne à l'écran précédent après création
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Créer un Service')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nom du Service'),
            ),
            TextField(
              controller: _categoryController,
              decoration: InputDecoration(labelText: 'Catégorie'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _createService,
              child: Text('Créer le Service'),
            ),
          ],
        ),
      ),
    );
  }
}
