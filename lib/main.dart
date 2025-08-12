import 'package:daily_taskmate/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:daily_taskmate/HomeScreen.dart';
import 'package:daily_taskmate/login_page.dart'; // ✅ Added login page import
import 'package:firebase_auth/firebase_auth.dart'; // ✅ Firebase Auth import

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        // ✅ This listens to login/logout state
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            return HomeScreen(); // ✅ If logged in, go to Home
          }
          return LoginPage(); // ✅ If not logged in, go to Login
        },
      ),
    );
  }
}
