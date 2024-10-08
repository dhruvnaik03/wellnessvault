import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart'; // Ensure you have the correct path for this
import 'HomePage.dart';
import 'signup_page.dart';
import 'login_page.dart';
import 'trainer_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Error handling for Firebase initialization
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    // Log the error to the console
    print("Firebase Initialization Error: $e");
    // Optionally, you could navigate to an error screen here
  }

  // Custom error widget to handle runtime errors
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text(
            'Something went wrong!\n${details.exception}',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  };

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WellnessVault',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignUpPage(),
        '/home': (context) => HomePage(),
      },
    );
  }
}
