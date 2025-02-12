import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Color(0xFF6A11CB), // Violet principal
  scaffoldBackgroundColor: Color(0xFFF5F5F5), // Gris clair en fond
  appBarTheme: AppBarTheme(
    backgroundColor: Color(0xFF6A11CB), // Violet pour la barre d'app
    foregroundColor: Colors.white, // Texte blanc
  ),
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: Color(0xFF212121)), // Texte principal en noir doux
    bodyMedium: TextStyle(color: Color(0xFF333333)), // Texte secondaire en gris foncé
    titleLarge: TextStyle(color: Color(0xFF6A11CB), fontWeight: FontWeight.bold), // Titres en violet
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Color(0xFF6A11CB), // Boutons violets
      foregroundColor: Colors.white, // Texte des boutons en blanc
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.white, // Fond blanc pour un effet moderne
    selectedItemColor: Color(0xFF6A11CB), // Élément actif en violet
    unselectedItemColor: Color(0xFF888888), // Élément inactif en gris
  ),
);