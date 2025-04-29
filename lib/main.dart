import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:vtcode/screens/home_screens.dart';

void main() {
  runApp(const VoiceToCodeApp());
}

class VoiceToCodeApp extends StatelessWidget {
  const VoiceToCodeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Voice to Code',
      theme: ThemeData(
        primaryColor: const Color(0xFF1E3A8A),
        scaffoldBackgroundColor: const Color(0xFFF3F4F6),
        textTheme: GoogleFonts.robotoTextTheme().copyWith(
          headlineSmall: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1E3A8A),
          ),
          bodyMedium: GoogleFonts.roboto(color: Colors.black87),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            elevation: 4,
          ),
        ),
      ),
      home: const RecordVoiceScreen(),
    );
  }
}
