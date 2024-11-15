import 'package:flutter/material.dart';

class ProfessionalProfileScreen extends StatelessWidget {
  final professional;

  ProfessionalProfileScreen({required this.professional});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(professional.name),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  backgroundImage: NetworkImage(professional.profileImageUrl),
                  radius: 50,
                ),
              ),
              SizedBox(height: 16),
              Center(child: Text(professional.name, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
              Center(child: Text("\$${professional.rate}/Hour", style: TextStyle(fontSize: 18))),
              Center(child: Text("${professional.distance} km away")),
              SizedBox(height: 16),
              Text("About", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Text(professional.description),
              SizedBox(height: 16),
              Text("Reviews", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              // List of reviews here
              SizedBox(height: 16),
              Text("Portfolio", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Wrap(
                spacing: 8,
                children: professional.portfolioImages.map((url) => Image.network(url, height: 80, width: 80)).toList(),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Book the professional
                },
                child: Text("Book Now"),
                style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
