import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/auth_service.dart';
import '../services/category_service.dart';
import '../services/professional_service.dart';
import '../services/reservation_service.dart';
import '../models/category_model.dart';
import '../models/professional_model.dart';
import '../models/reservation_model.dart';
import 'category_detail_screen.dart';
import 'professional_detail_screen.dart';
import 'create_category_screen.dart';
import 'reservation_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _authService = AuthService();
  final CategoryService _categoryService = CategoryService();
  final ProfessionalService _professionalService = ProfessionalService();
  final ReservationService _reservationService = ReservationService();
  String? _userRole;
  List<CategoryModel> _categories = [];
  List<CategoryModel> _filteredCategories = [];
  List<ProfessionalModel> _professionals = [];
  List<ProfessionalModel> _filteredProfessionals = [];
  List<ReservationModel> _reservations = [];
  TextEditingController _searchController = TextEditingController();
  bool _isSearchingProfessionals = false;

  @override
  void initState() {
    super.initState();
    _loadUserRole();
    _loadCategories();
    _loadProfessionals();
    _loadUserReservations();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  // Charge le rôle de l'utilisateur actuel
  void _loadUserRole() async {
    final user = _authService.currentUser;
    if (user != null) {
      final userData = await _authService.getUserProfile(user.uid);
      setState(() {
        _userRole = userData?.role;
      });
    }
  }

  // Charge les catégories
  Future<void> _loadCategories() async {
    List<CategoryModel> categories = await _categoryService.getCategories();
    setState(() {
      _categories = categories;
      _filteredCategories = categories;
    });
  }

  // Charge tous les professionnels
  Future<void> _loadProfessionals() async {
    List<ProfessionalModel> professionals =
        await _professionalService.getAllProfessionals();
    setState(() {
      _professionals = professionals;
    });
  }

  // Charge les réservations de l'utilisateur connecté
  Future<void> _loadUserReservations() async {
    final user = _authService.currentUser;
    if (user != null) {
      List<ReservationModel> reservations =
          await _reservationService.getReservationsByUserId(user.uid);
      setState(() {
        _reservations = reservations;
      });
    }
  }

  // Méthode appelée lorsque le texte de recherche change
  void _onSearchChanged() {
    String query = _searchController.text.toLowerCase();
    if (query.isEmpty) {
      setState(() {
        _isSearchingProfessionals = false;
        _filteredCategories = _categories;
      });
    } else {
      setState(() {
        _isSearchingProfessionals = true;
        _filteredProfessionals = _professionals.where((professional) {
          return professional.jobTitle.toLowerCase().contains(query) ||
              professional.description.toLowerCase().contains(query) ||
              professional.name.toLowerCase().contains(query);
        }).toList();
      });
    }
  }

  // Navigue vers les détails de la catégorie
  void _goToCategoryDetail(CategoryModel category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryDetailScreen(category: category),
      ),
    );
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

  // Navigue vers l'écran de création de catégorie et ajoute la catégorie créée à la liste
  Future<void> _goToCreateCategory() async {
    final newCategory = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateCategoryScreen(),
      ),
    );

    if (newCategory != null && newCategory is CategoryModel) {
      setState(() {
        _categories.add(newCategory);
        _filteredCategories = _categories; // Met à jour la liste filtrée
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Palette de couleurs
    final Color blueColor = Color(0xFF0055A4);
    final Color whiteColor = Colors.white;
    final Color redColor = Color(0xFFEF4135);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Service de Réservation de Professionnels",
          style: TextStyle(
            color: whiteColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: blueColor,
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: whiteColor),
            onPressed: () async {
              await _authService.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
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
            // Barre de recherche
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Rechercher un professionnel ou une catégorie",
                  prefixIcon: Icon(Icons.search, color: blueColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),
            // Bouton pour ajouter une catégorie visible pour les prestataires
            if (_userRole == 'prestataire')
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: _goToCreateCategory,
                  child: Text(
                    "Ajouter une catégorie",
                    style: TextStyle(color: whiteColor),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: redColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  ),
                ),
              ),
            // Section des réservations
            if (_reservations.isNotEmpty) _buildReservationSection(),
            // Liste des catégories ou des professionnels en fonction de la recherche
            Expanded(
              child: _isSearchingProfessionals
                  ? _buildProfessionalList()
                  : _buildCategoryList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReservationSection() {
    final Color blueColor = Color(0xFF0055A4);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Mes Réservations",
            style: TextStyle(
              color: blueColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _reservations.length,
            itemBuilder: (context, index) {
              final reservation = _reservations[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  title: Text(
                    "Service : ${reservation.serviceId}",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                      "Date : ${DateFormat('dd/MM/yyyy à HH:mm').format(reservation.reservationDateTime)}"),
                  trailing: Text(
                    reservation.status,
                    style: TextStyle(
                      color: reservation.status == 'confirmée'
                          ? Colors.green
                          : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReservationScreen(
                          serviceId: reservation.serviceId,
                          reservationDateTime: reservation.reservationDateTime,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProfessionalList() {
    final Color blueColor = Color(0xFF0055A4);
    final Color whiteColor = Colors.white;
    final Color redColor = Color(0xFFEF4135);

    if (_filteredProfessionals.isEmpty) {
      return Center(
        child: Text(
          "Aucun professionnel trouvé.",
          style: TextStyle(
            color: blueColor,
            fontSize: 18,
          ),
        ),
      );
    } else {
      return ListView.builder(
        itemCount: _filteredProfessionals.length,
        itemBuilder: (context, index) {
          final professional = _filteredProfessionals[index];
          return GestureDetector(
            onTap: () => _goToProfessionalDetail(professional),
            child: Card(
              margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  gradient: LinearGradient(
                    colors: [whiteColor, blueColor.withOpacity(0.1)],
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
                        "Prix : ${professional.price} €",
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
      );
    }
  }

  Widget _buildCategoryList() {
    final Color blueColor = Color(0xFF0055A4);
    final Color whiteColor = Colors.white;

    if (_filteredCategories.isEmpty) {
      return Center(
        child: Text(
          "Aucune catégorie trouvée.",
          style: TextStyle(
            color: blueColor,
            fontSize: 18,
          ),
        ),
      );
    } else {
      return ListView.builder(
        itemCount: _filteredCategories.length,
        itemBuilder: (context, index) {
          final category = _filteredCategories[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: blueColor,
                child: Icon(
                  Icons.category,
                  color: whiteColor,
                ),
              ),
              title: Text(
                category.name,
                style: TextStyle(
                  color: blueColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: blueColor,
              ),
              onTap: () => _goToCategoryDetail(category),
            ),
          );
        },
      );
    }
  }
}
