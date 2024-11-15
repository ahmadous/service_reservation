import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/category_service.dart';
import '../models/category_model.dart';

class CreateCategoryScreen extends StatefulWidget {
  @override
  _CreateCategoryScreenState createState() => _CreateCategoryScreenState();
}

class _CreateCategoryScreenState extends State<CreateCategoryScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final CategoryService _categoryService = CategoryService();
  File? _selectedImage;

  // Méthode pour ouvrir ImagePicker et sélectionner une image (optionnelle)
  Future<void> _pickImage() async {
    // final picker = ImagePicker();
    // final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    // if (pickedFile != null) {
    //   setState(() {
    //     _selectedImage = File(pickedFile.path);
    //   });
    // } else {
    //   print('Aucune image sélectionnée.');
    // }
  }

  // Méthode pour créer la catégorie avec les informations saisies
  void _createCategory() async {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Veuillez entrer un nom pour la catégorie")),
      );
      return;
    }

    if (_descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Veuillez entrer une description")),
      );
      return;
    }

    // Créer le modèle de catégorie
    CategoryModel newCategory = CategoryModel(
      id: '', // Firestore va générer un ID unique
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      imageUrl: _selectedImage != null
          ? _selectedImage!.path
          : '', // Utilise le chemin local si disponible
    );

    // Enregistrer la catégorie dans Firestore
    await _categoryService.addCategory(newCategory);
    Navigator.pop(context); // Retourne à l'écran précédent après création
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Catégorie créée avec succès !")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color blueColor = Color(0xFF0055A4);
    final Color redColor = Color(0xFFEF4135);

    return Scaffold(
      appBar: AppBar(
        title: Text('Créer une Catégorie'),
        backgroundColor: blueColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Nom de la Catégorie *',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description *',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 20),
            // _selectedImage == null
            //     ? Text("Aucune image sélectionnée")
            //     : Image.file(
            //         _selectedImage!,
            //         height: 150,
            //         width: 150,
            //         fit: BoxFit.cover,
            //       ),
            SizedBox(height: 20),
            // Center(
            //   child: ElevatedButton(
            //     onPressed: _pickImage,
            //     child: Text('Choisir une Image'),
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: redColor,
            //     ),
            //   ),
            // ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _createCategory,
                child: Text(
                  'Créer la Catégorie',
                  style: TextStyle(color: Colors.red),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: blueColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
