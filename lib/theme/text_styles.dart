import 'package:flutter/material.dart';

class AppTextStyles {
  // Heure prochain train
  static const huge = TextStyle(fontSize: 56.0, fontWeight: FontWeight.bold);

  // Voie
  static const large = TextStyle(fontSize: 28.0, fontWeight: FontWeight.w500);

  // État (À l'heure, +5 min, etc.)
  static const medium = TextStyle(fontSize: 24.0, fontWeight: FontWeight.normal);

  // Horaires suivants
  static const small = TextStyle(fontSize: 18.0, fontWeight: FontWeight.normal);

  // Textes secondaires
  static const tiny = TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal);
}
