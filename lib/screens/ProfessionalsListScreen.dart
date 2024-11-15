// import 'package:flutter/material.dart';
// import '../services/professional_service.dart';
// import '../models/professional_model.dart';
// import 'professional_profile_screen.dart';

// class ProfessionalsListScreen extends StatefulWidget {
//   final String categoryName;

//   ProfessionalsListScreen({required this.categoryName});

//   @override
//   _ProfessionalsListScreenState createState() =>
//       _ProfessionalsListScreenState();
// }

// class _ProfessionalsListScreenState extends State<ProfessionalsListScreen> {
//   final ProfessionalService _professionalService = ProfessionalService();
//   List<ProfessionalModel> _professionals = [];

//   @override
//   void initState() {
//     super.initState();
//     _loadProfessionals();
//   }

//   Future<void> _loadProfessionals() async {
//     List<ProfessionalModel> professionals = await _professionalService
//         .getProfessionalsByCategory(widget.categoryName);
//     setState(() {
//       _professionals = professionals;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(widget.categoryName)),
//       body: ListView.builder(
//         padding: EdgeInsets.all(16.0),
//         itemCount: _professionals.length,
//         itemBuilder: (context, index) {
//           final professional = _professionals[index];
//           return Card(
//             margin: EdgeInsets.symmetric(vertical: 8),
//             child: ListTile(
//               leading: CircleAvatar(
//                 backgroundImage: NetworkImage(professional.profileImageUrl),
//                 radius: 30,
//               ),
//               title: Text(professional.name),
//               subtitle: Row(
//                 children: [
//                   // Text("\$${professional.rate}/Hour", style: TextStyle(fontWeight: FontWeight.bold)),
//                   // Spacer(),
//                   // Text("${professional.distance} km away", style: TextStyle(fontSize: 12, color: Colors.grey)),
//                 ],
//               ),
//               trailing: Icon(Icons.arrow_forward_ios, size: 16),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) =>
//                         ProfessionalProfileScreen(professional: professional),
//                   ),
//                 );
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
