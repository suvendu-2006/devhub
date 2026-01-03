import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = true;
  
  bool get isDarkMode => _isDarkMode;
  
  ThemeData get theme => _isDarkMode ? darkTheme : lightTheme;
  
  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
  
  // Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: backgroundColor,
      primaryColor: primaryColor,
      canvasColor: surfaceColor,
      dialogBackgroundColor: cardColor,
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: surfaceColor,
        error: errorColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: textPrimary,
        onError: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      cardColor: cardColor,
      cardTheme: const CardTheme(
        color: cardColor,
        surfaceTintColor: Colors.transparent,
      ),
      dividerColor: const Color(0xFF2A2A36),
      textTheme: const TextTheme(
        headlineSmall: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        bodyLarge: TextStyle(color: textPrimary),
        bodyMedium: TextStyle(color: textSecondary),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColor,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        hintStyle: const TextStyle(color: textMuted),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: backgroundColor,
        selectedItemColor: primaryColor,
        unselectedItemColor: textMuted,
      ),
      tabBarTheme: const TabBarTheme(
        indicatorColor: primaryColor,
        labelColor: Colors.white,
        unselectedLabelColor: textMuted,
      ),
      popupMenuTheme: const PopupMenuThemeData(
        color: cardColor,
      ),
      dropdownMenuTheme: const DropdownMenuThemeData(
        menuStyle: MenuStyle(
          backgroundColor: WidgetStatePropertyAll(cardColor),
        ),
      ),
    );
  }
  
  // Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: lightBackground,
      primaryColor: primaryColor,
      canvasColor: Colors.white,
      dialogBackgroundColor: Colors.white,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: lightSecondary,
        surface: Colors.white,
        error: lightError,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: lightTextPrimary,
        onError: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: lightTextPrimary),
        titleTextStyle: TextStyle(color: lightTextPrimary, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      cardColor: Colors.white,
      cardTheme: const CardTheme(
        color: Colors.white,
        surfaceTintColor: Colors.transparent,
      ),
      dividerColor: const Color(0xFFE0E0E0),
      textTheme: const TextTheme(
        headlineSmall: TextStyle(color: lightTextPrimary, fontWeight: FontWeight.bold),
        bodyLarge: TextStyle(color: lightTextPrimary),
        bodyMedium: TextStyle(color: lightTextSecondary),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF0F0F5),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        hintStyle: const TextStyle(color: Color(0xFF9E9E9E)),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: primaryColor,
        unselectedItemColor: Color(0xFF9E9E9E),
      ),
      tabBarTheme: const TabBarTheme(
        indicatorColor: primaryColor,
        labelColor: Colors.white,
        unselectedLabelColor: Color(0xFF6B6B7B),
      ),
      popupMenuTheme: const PopupMenuThemeData(
        color: Colors.white,
      ),
      dropdownMenuTheme: const DropdownMenuThemeData(
        menuStyle: MenuStyle(
          backgroundColor: WidgetStatePropertyAll(Colors.white),
        ),
      ),
    );
  }
  
  // Dark theme colors
  static const Color primaryColor = Color(0xFF6C63FF);
  static const Color secondaryColor = Color(0xFF00D9FF);
  static const Color backgroundColor = Color(0xFF0D0D12);
  static const Color surfaceColor = Color(0xFF1A1A24);
  static const Color cardColor = Color(0xFF1E1E2A);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0B0B0);
  static const Color textMuted = Color(0xFF6B6B7B);
  static const Color successColor = Color(0xFF10B981);
  static const Color errorColor = Color(0xFFFF6B6B);
  static const Color warningColor = Color(0xFFFBBF24);
  
  // Light theme colors
  static const Color lightBackground = Color(0xFFF5F7FA);
  static const Color lightSecondary = Color(0xFF00B4D8);
  static const Color lightTextPrimary = Color(0xFF1A1A24);
  static const Color lightTextSecondary = Color(0xFF4A4A5A); // Darker for better contrast
  static const Color lightTextMuted = Color(0xFF5A5A6A); // New: for badges/chips
  static const Color lightError = Color(0xFFE53935);
}

class AppTheme {
  static const Color primaryColor = Color(0xFF6C63FF);
  static const Color secondaryColor = Color(0xFF00D9FF);
  static const Color backgroundColor = Color(0xFF0D0D12);
  static const Color surfaceColor = Color(0xFF1A1A24);
  static const Color cardColor = Color(0xFF1E1E2A);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0B0B0);
  static const Color textMuted = Color(0xFF6B6B7B);
  static const Color successColor = Color(0xFF10B981);
  static const Color errorColor = Color(0xFFFF6B6B);
  static const Color warningColor = Color(0xFFFBBF24);
  
  // Light theme colors
  static const Color lightBackground = Color(0xFFF5F7FA);
  static const Color lightTextPrimary = Color(0xFF1A1A24);
  static const Color lightTextSecondary = Color(0xFF4A4A5A); // Darker for better contrast
  static const Color lightTextMuted = Color(0xFF5A5A6A); // For badges/chips
  static const Color lightCardColor = Colors.white;
  static const Color lightSurfaceColor = Color(0xFFE8E8EE); // Slightly darker for better badge visibility

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6C63FF), Color(0xFF5A52E0)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static BoxDecoration get gradientCardDecoration => BoxDecoration(
    color: cardColor,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: Colors.white.withOpacity(0.05)),
  );

  static BoxDecoration get glassDecoration => BoxDecoration(
    color: cardColor,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: Colors.white.withOpacity(0.1)),
  );

  static ThemeData get darkTheme => ThemeProvider.darkTheme;
  static ThemeData get lightTheme => ThemeProvider.lightTheme;
}
