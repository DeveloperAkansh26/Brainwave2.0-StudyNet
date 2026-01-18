import 'dart:math';
import 'package:flutter/material.dart';
import 'pages/loading.dart'; // your current splash/loading page
import 'pages/join_screen.dart'; // WebRTC join screen
import 'services/signaling_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await Supabase.initialize(
    url: "https://jtcjadwdyiumrdenwdhi.supabase.co",   // 👈 replace if needed
    anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imp0Y2phZHdkeWl1bXJkZW53ZGhpIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njg1MDA0NjEsImV4cCI6MjA4NDA3NjQ2MX0.mBJcHX_EKK4oWqcTTVArGsQkUqoZd_RjA1mz8c6VZoM",
  );

  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key}); // remove const

  // Signaling server URL for WebRTC
  final String websocketUrl = "ws://192.168.1.25:3000"; 
  final String selfCallerID =
      Random().nextInt(999999).toString().padLeft(6, '0');

  @override
  Widget build(BuildContext context) {
    // Initialize signaling service
    SignallingService.instance.init(
      websocketUrl: websocketUrl,
      selfCallerID: selfCallerID,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My App',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.purple,
          brightness: Brightness.light,
        ),
        fontFamily: 'Poppins',
      ),
      home: SplashPage(),
    );
  }
}
