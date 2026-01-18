import 'package:flutter/material.dart';
import 'dart:async';
import 'login2.dart';
import 'teacher_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Poppins'),
      home: const SplashPage(),
    );
  }
}

/// Landing / Splash Page
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    // Automatically go to Role Selection Page after 3 seconds
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const RoleSelectionPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0); // slide from bottom
            const end = Offset.zero;
            final tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: Curves.easeInOut));
            return SlideTransition(position: animation.drive(tween), child: child);
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[100],
      body: Center(
        child: Text(
          "Paathshaala",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 42,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple[800],
          ),
        ),
      ),
    );
  }
}

/// Role Selection Page
class RoleSelectionPage extends StatelessWidget {
  const RoleSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image (full screen)
          Positioned.fill(
            child: Image.asset(
              "asset/fonts/images/loading.png",
              fit: BoxFit.cover,
            ),
          ),

          // Foreground content
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 80), // move content up from bottom
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Select your role",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 50),

                  // Student Button
                  SizedBox(
                    width: 400,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () {
                      Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(role: "Student"),
                  ),
                  );
                    },

                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple[400],
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        "Student",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),

                  // Teacher Button
                  SizedBox(
                    width: 400,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () {
                      Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(role: "Teacher"),
                      ),
                    );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple[600],
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        "Teacher",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
