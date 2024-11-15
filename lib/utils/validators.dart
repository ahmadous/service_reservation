// lib/utils/validators.dart

class Validators {
  /// Valide un email selon un format standard.
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer un email';
    }
    final emailRegExp = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegExp.hasMatch(value)) {
      return 'Veuillez entrer un email valide';
    }
    return null;
  }

  /// Valide un mot de passe avec une longueur minimum.
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer un mot de passe';
    } else if (value.length < 6) {
      return 'Le mot de passe doit contenir au moins 6 caractères';
    }
    return null;
  }

  /// Valide un nom pour s'assurer qu'il n'est pas vide.
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer un nom';
    }
    return null;
  }
}
