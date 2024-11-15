// lib/utils/date_utils.dart

import 'package:intl/intl.dart';

class DateUtils {
  /// Format standard pour afficher les dates
  static String formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(date);
  }

  /// Format complet avec date et heure
  static String formatDateTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat('dd/MM/yyyy HH:mm');
    return formatter.format(dateTime);
  }

  /// Renvoie la différence en jours entre deux dates
  static int daysBetween(DateTime start, DateTime end) {
    return end.difference(start).inDays;
  }

  /// Vérifie si une date est aujourd'hui
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return now.year == date.year && now.month == date.month && now.day == date.day;
  }
}
