import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Inscription avec email, mot de passe, nom et rôle
  Future<User?> signUp(
      String email, String password, String name, String role) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;

      // Si l'utilisateur est créé, ajoute des informations supplémentaires dans Firestore
      if (user != null) {
        UserModel newUser = UserModel(
          id: user.uid,
          name: name,
          email: email,
          role: role,
          profilePictureUrl: null,
          createdAt: DateTime.now(),
        );

        await _firestore
            .collection('users')
            .doc(user.uid)
            .set(newUser.toFirestore());
      }

      return user;
    } catch (e) {
      print('Erreur lors de l\'inscription: $e');
      return null;
    }
  }

  // Connexion avec email et mot de passe
  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      print('Erreur lors de la connexion: $e');
      return null;
    }
  }

  // Récupère le profil utilisateur depuis Firestore
  Future<UserModel?> getUserProfile(String uid) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromFirestore(
            doc.data() as Map<String, dynamic>, doc.id);
      }
      return null;
    } catch (e) {
      print('Erreur lors de la récupération des données de l\'utilisateur: $e');
      return null;
    }
  }

  // Déconnexion
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Récupère le rôle de l'utilisateur depuis Firestore
  Future<String?> getUserRole(String userId) async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        return userDoc['role']
            as String?; // Assurez-vous que le champ 'role' existe dans le document
      }
      return null;
    } catch (e) {
      print("Erreur lors de la récupération du rôle de l'utilisateur : $e");
      return null;
    }
  }

  // Vérifie si un utilisateur est connecté
  User? get currentUser => _auth.currentUser;
}
