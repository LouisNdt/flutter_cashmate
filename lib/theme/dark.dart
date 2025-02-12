import 'package:flutter/material.dart';

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Color(0xFF6A11CB), // Violet principal
  scaffoldBackgroundColor: Color(0xFF121212), // Fond noir profond
  appBarTheme: AppBarTheme(
    backgroundColor: Color(0xFF6A11CB), // Violet pour l'AppBar
    foregroundColor: Colors.white, // Texte blanc
  ),
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: Colors.white), // Texte principal blanc
    bodyMedium: TextStyle(color: Color(0xFFCCCCCC)), // Texte secondaire gris clair
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
    backgroundColor: Color(0xFF1E1E1E), // Fond sombre pour la BottomNavBar
    selectedItemColor: Color(0xFF6A11CB), // Élément actif en violet
    unselectedItemColor: Color(0xFF888888), // Élément inactif en gris
  ),
);