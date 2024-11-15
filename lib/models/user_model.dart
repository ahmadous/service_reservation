// lib/models/user_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String role; // 'client' ou 'prestataire'
  final String? profilePictureUrl;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.profilePictureUrl,
    required this.createdAt,
  });

  // Méthode pour convertir les données Firestore en UserModel
  factory UserModel.fromFirestore(Map<String, dynamic> data, String documentId) {
    return UserModel(
      id: documentId,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      role: data['role'] ?? '',
      profilePictureUrl: data['profilePictureUrl'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  // Méthode pour convertir UserModel en Map pour Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      'role': role,
      'profilePictureUrl': profilePictureUrl,
      'createdAt': createdAt,
    };
  }
}
