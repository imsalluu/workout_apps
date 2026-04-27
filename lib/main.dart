import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/plan_provider.dart';
import 'screens/main_shell.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => PlanProvider(),
      child: const FitnessApp(),
    ),
  );
}

class FitnessApp extends StatelessWidget {
  const FitnessApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '30-Day Fat Loss',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.dark,
          primary: const Color(0xFF00E676), // Vibrant Neon Green
          secondary: const Color(0xFF69F0AE),
          surface: const Color(0xFF121212),
          error: const Color(0xFFFF5252),
        ),
        scaffoldBackgroundColor: const Color(0xFF0A0A0A), // Near Black
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0A0A0A),
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: const Color(0xFF121212),
          indicatorColor: const Color(0xFF00E676).withValues(alpha: 0.15),
          labelTextStyle: WidgetStateProperty.all(
            const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 0.5),
          ),
          iconTheme: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const IconThemeData(color: Color(0xFF00E676));
            }
            return IconThemeData(color: Colors.white.withValues(alpha: 0.6));
          }),
        ),
        cardTheme: CardThemeData(
          color: const Color(0xFF1E1E1E),
          elevation: 4,
          shadowColor: Colors.black.withValues(alpha: 0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
          headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          bodyLarge: TextStyle(fontSize: 16, color: Colors.white),
          bodyMedium: TextStyle(fontSize: 14, color: Colors.white70),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00E676),
            foregroundColor: Colors.black,
            textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 8,
            shadowColor: const Color(0xFF00E676).withValues(alpha: 0.4),
          ),
        ),
        checkboxTheme: CheckboxThemeData(
          fillColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const Color(0xFF00E676);
            }
            return null;
          }),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      ),
      home: const MainShell(),
    );
  }
}
