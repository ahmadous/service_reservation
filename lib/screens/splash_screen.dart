import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _startSplashScreenTimer();
  }

  void _startSplashScreenTimer() async {
    var _duration = Duration(seconds: 3);
    Timer(_duration, _navigateToNextScreen);
  }

  void _navigateToNextScreen() async {
    User? user = _authService.currentUser;

    if (user != null) {
      // L'utilisateur est connecté, navigue vers HomeScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      // L'utilisateur n'est pas connecté, navigue vers LoginScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Palette de couleurs
    final Color blueColor = Color(0xFF0055A4);
    final Color whiteColor = Colors.white;
    final Color redColor = Color(0xFFEF4135);

    return Scaffold(
      backgroundColor: whiteColor,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [blueColor, whiteColor, redColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo ou icône de l'application
              Icon(
                Icons.work_outline,
                size: 100,
                color: whiteColor,
              ),
              SizedBox(height: 20),
              Text(
                "Bienvenue dans notre application",
                style: TextStyle(
                  color: whiteColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              // Indicateur de progression (animation)
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(whiteColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
