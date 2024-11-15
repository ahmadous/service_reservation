import 'package:flutter/material.dart';
import 'package:service_reservation/utils/%20string_extensions.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();
  UserModel? userData;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    final user = _authService.currentUser;
    if (user != null) {
      final data = await _authService.getUserProfile(user.uid);
      setState(() {
        userData = data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profil')),
      body: userData == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (userData!.profilePictureUrl != null)
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(userData!.profilePictureUrl!),
                ),
              ),
            SizedBox(height: 16),
            Text('Nom : ${userData!.name}', style: TextStyle(fontSize: 18)),
            Text('Email : ${userData!.email}', style: TextStyle(fontSize: 18)),
            Text('Rôle : ${userData!.role.capitalize()}', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
