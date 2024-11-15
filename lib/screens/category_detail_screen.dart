import 'package:flutter/material.dart';
import '../models/category_model.dart';
import '../models/professional_model.dart';
import '../services/professional_service.dart';
import '../services/auth_service.dart';
import 'professional_detail_screen.dart';
import 'create_professional_screen.dart';

class CategoryDetailScreen extends StatefulWidget {
  final CategoryModel category;

  CategoryDetailScreen({required this.category});

  @override
  _CategoryDetailScreenState createState() => _CategoryDetailScreenState();
}

class _CategoryDetailScreenState extends State<CategoryDetailScreen> {
  final ProfessionalService _professionalService = ProfessionalService();
  final AuthService _authService = AuthService();
  List<ProfessionalModel> _professionals = [];
  List<ProfessionalModel> _filteredProfessionals = [];
  String? _userRole;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfessionals();
    _loadUserRole();

    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  // Charge les professionnels de la catégorie
  Future<void> _loadProfessionals() async {
    List<ProfessionalModel> professionals = await _professionalService
        .getProfessionalsByCategory(widget.category.name);
    setState(() {
      _professionals = professionals;
      _filteredProfessionals = professionals;
    });
  }

  // Charge le rôle de l'utilisateur
  Future<void> _loadUserRole() async {
    final user = _authService.currentUser;
    if (user != null) {
      final userData = await _authService.getUserProfile(user.uid);
      setState(() {
        _userRole = userData?.role;
      });
    }
  }

  // Navigue vers l'écran de création de professionnel
  Future<void> _goToCreateProfessional() async {
    final newProfessional = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            CreateProfessionalScreen(categoryName: widget.category.name),
      ),
    );

    if (newProfessional != null) {
      setState(() {
        _professionals.add(newProfessional);
        _filteredProfessionals.add(newProfessional);
      });
    }
  }

  // Navigue vers les détails du professionnel
  void _goToProfessionalDetail(ProfessionalModel professional) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ProfessionalDetailScreen(professional: professional),
      ),
    );
  }

  // Méthode appelée lorsque le texte de recherche change
  void _onSearchChanged() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredProfessionals = _professionals.where((professional) {
        return professional.jobTitle.toLowerCase().contains(query) ||
            professional.description.toLowerCase().contains(query);
      }).toList();
    });
  }

  // Palette de couleurs
  final Color blueColor = Color(0xFF0055A4);
  final Color whiteColor = Colors.white;
  final Color redColor = Color(0xFFEF4135);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.category.name,
          style: TextStyle(
            color: whiteColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: blueColor,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [blueColor, whiteColor, redColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            if (_userRole == 'prestataire')
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton.icon(
                  onPressed: _goToCreateProfessional,
                  icon: Icon(Icons.add, color: whiteColor),
                  label: Text(
                    "Ajouter un professionnel",
                    style: TextStyle(color: whiteColor),
                  ),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: whiteColor,
                    backgroundColor: redColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  ),
                ),
              ),
            // Barre de recherche
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Rechercher par titre de poste ou description',
                  prefixIcon: Icon(Icons.search, color: blueColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: _filteredProfessionals.isEmpty
                  ? Center(
                      child: Text(
                        "Aucun professionnel trouvé.",
                        style: TextStyle(
                          color: blueColor,
                          fontSize: 18,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _filteredProfessionals.length,
                      itemBuilder: (context, index) {
                        final professional = _filteredProfessionals[index];
                        return GestureDetector(
                          onTap: () => _goToProfessionalDetail(professional),
                          child: Card(
                            margin: EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            elevation: 4.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0),
                                gradient: LinearGradient(
                                  colors: [
                                    whiteColor,
                                    blueColor.withOpacity(0.1)
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: blueColor,
                                  child: Icon(
                                    Icons.person,
                                    color: whiteColor,
                                  ),
                                ),
                                title: Text(
                                  professional.name,
                                  style: TextStyle(
                                    color: blueColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      professional.jobTitle,
                                      style: TextStyle(
                                        color: Colors.black87,
                                      ),
                                    ),
                                    Text(
                                      "Prix : ${professional.price} FCFA",
                                      style: TextStyle(
                                        color: redColor,
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: Icon(
                                  Icons.arrow_forward_ios,
                                  color: blueColor,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
