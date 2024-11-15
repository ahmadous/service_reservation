import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // Contrôleurs de texte
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Palette de couleurs
  final Color blueColor = Color(0xFF0055A4);
  final Color whiteColor = Colors.white;
  final Color redColor = Color(0xFFEF4135);

  // Fonction de connexion
  void _signIn() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        User? user = await _authService.signIn(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );
        if (user != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        }
      } on FirebaseAuthException catch (e) {
        String errorMessage = '';
        switch (e.code) {
          case 'user-not-found':
            errorMessage = "Utilisateur non trouvé.";
            break;
          case 'wrong-password':
            errorMessage = "Mot de passe incorrect.";
            break;
          case 'invalid-email':
            errorMessage = "Email invalide.";
            break;
          default:
            errorMessage = "Une erreur s'est produite.";
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur lors de la connexion : $e")),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Fonction pour naviguer vers l'écran d'inscription
  void _goToSignUp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignupScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              SizedBox(height: 60),
              Text(
                "Connexion",
                style: TextStyle(
                  color: blueColor,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 40),
              // Formulaire de connexion
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Champ email
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email, color: blueColor),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer votre email';
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}')
                            .hasMatch(value)) {
                          return 'Veuillez entrer un email valide';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    // Champ mot de passe
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Mot de passe',
                        prefixIcon: Icon(Icons.lock, color: blueColor),
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer votre mot de passe';
                        }
                        if (value.length < 6) {
                          return 'Le mot de passe doit contenir au moins 6 caractères';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 30),
                    // Bouton de connexion
                    _isLoading
                        ? CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: _signIn,
                            child: Text(
                              'Se connecter',
                              style: TextStyle(color: whiteColor, fontSize: 18),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: blueColor,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              // Lien vers l'inscription
              GestureDetector(
                onTap: _goToSignUp,
                child: Text(
                  "Pas encore inscrit ? Créer un compte",
                  style: TextStyle(
                    color: redColor,
                    decoration: TextDecoration.underline,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
