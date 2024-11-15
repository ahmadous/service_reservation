import 'package:flutter/material.dart';
import '../models/review_model.dart';
import '../services/review_service.dart';

class ReviewScreen extends StatefulWidget {
  final String serviceId;
  final String userId;

  ReviewScreen({required this.serviceId, required this.userId});

  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  final ReviewService _reviewService = ReviewService();
  final TextEditingController _commentController = TextEditingController();
  int _rating = 3; // Valeur par défaut

  void _submitReview() async {
    if (_commentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Veuillez écrire un commentaire")),
      );
      return;
    }

    ReviewModel review = ReviewModel(
      id: '',
      serviceId: widget.serviceId,
      userId: widget.userId,
      rating: _rating,
      comment: _commentController.text.trim(),
    );

    await _reviewService.addReview(review);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Avis soumis avec succès !")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Laisser un Avis')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("Note :"),
            Slider(
              value: _rating.toDouble(),
              min: 1,
              max: 5,
              divisions: 4,
              label: _rating.toString(),
              onChanged: (value) {
                setState(() {
                  _rating = value.toInt();
                });
              },
            ),
            TextField(
              controller: _commentController,
              decoration: InputDecoration(labelText: 'Commentaire'),
              maxLines: 3,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitReview,
              child: Text('Soumettre l\'Avis'),
            ),
          ],
        ),
      ),
    );
  }
}
