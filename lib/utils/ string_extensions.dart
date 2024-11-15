// lib/utils/string_extensions.dart

extension StringExtensions on String {
  /// Met la première lettre en majuscule et les autres en minuscule.
  String capitalize() {
    if (this.isEmpty) return this;
    return this[0].toUpperCase() + substring(1).toLowerCase();
  }

  /// Met chaque mot d'une phrase en majuscule.
  String capitalizeEachWord() {
    return this.split(' ').map((word) => word.capitalize()).join(' ');
  }
}
