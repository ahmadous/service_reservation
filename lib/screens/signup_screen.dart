import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // Contrôleurs de texte
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  String? _selectedRole;

  // Palette de couleurs
  final Color blueColor = Color(0xFF0055A4);
  final Color whiteColor = Colors.white;
  final Color redColor = Color(0xFFEF4135);

  // Fonction d'inscription
  void _signUp() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedRole == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Veuillez sélectionner un rôle")),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      try {
        User? user = await _authService.signUp(
          _emailController.text.trim(),
          _passwordController.text.trim(),
          _nameController.text.trim(),
          _selectedRole!,
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
          case 'email-already-in-use':
            errorMessage = "Cet email est déjà utilisé.";
            break;
          case 'invalid-email':
            errorMessage = "Email invalide.";
            break;
          case 'weak-password':
            errorMessage = "Le mot de passe est trop faible.";
            break;
          default:
            errorMessage = "Une erreur s'est produite.";
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur lors de l'inscription : $e")),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Fonction pour naviguer vers l'écran de connexion
  void _goToLogin() {
    Navigator.pop(context); // Retourne à l'écran de connexion
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
                "Inscription",
                style: TextStyle(
                  color: blueColor,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 40),
              // Formulaire d'inscription
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Champ nom
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Nom',
                        prefixIcon: Icon(Icons.person, color: blueColor),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer votre nom';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
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
                    SizedBox(height: 20),
                    // Sélection du rôle
                    DropdownButtonFormField<String>(
                      value: _selectedRole,
                      items: ['client', 'prestataire'].map((role) {
                        return DropdownMenuItem(
                          value: role,
                          child: Text(
                            role[0].toUpperCase() + role.substring(1),
                            style: TextStyle(color: blueColor),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedRole = value;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Rôle',
                        prefixIcon: Icon(Icons.people, color: blueColor),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null) {
                          return 'Veuillez sélectionner un rôle';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 30),
                    // Bouton d'inscription
                    _isLoading
                        ? CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: _signUp,
                            child: Text(
                              'S\'inscrire',
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
              // Lien vers la connexion
              GestureDetector(
                onTap: _goToLogin,
                child: Text(
                  "Déjà inscrit ? Se connecter",
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
