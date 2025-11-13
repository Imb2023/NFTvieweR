import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'screens/home_screen.dart';

// flutter config --no-enable-windows-desktop is set to ignore win fluttrdr

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // debug flag
      title: 'My Viewer',
      theme: AppTheme.light(),
      home: const HomeScreen(),
    );
  }
}
