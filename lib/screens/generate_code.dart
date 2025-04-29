import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax/iconsax.dart';
import '../constant/appcolors.dart';
import '../constant/apptext.dart';
import '../constant/button.dart';
import 'code_editor.dart';

class GenerateCodeScreen extends StatefulWidget {
  final String transcribedText;

  const GenerateCodeScreen({super.key, required this.transcribedText});

  @override
  _GenerateCodeScreenState createState() => _GenerateCodeScreenState();
}

class _GenerateCodeScreenState extends State<GenerateCodeScreen> {
  String generatedCode = '';
  bool isLoading = false;

  Future<void> generateCode() async {
    setState(() => isLoading = true);
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/api/text-to-code'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'text': widget.transcribedText}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          setState(() {
            generatedCode = data['code'];
          });
          if (mounted) {
            await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                title: Text(
                  'Code Generated',
                  style: AppTextStyles.headline2(context),
                ),
                content: Text(
                  'Code has been generated successfully!',
                  style: AppTextStyles.bodyMedium(context),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'OK',
                      style: GoogleFonts.poppins(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        } else {
          setState(() {
            generatedCode = 'Error: ${data['error'] ?? 'Unknown error'}';
          });
        }
      } else {
        setState(() {
          generatedCode = 'Server error: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        generatedCode = 'Error: $e';
      });
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Generate Code',
          style: AppTextStyles.headline2(context).copyWith(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(16),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: AppColors.card,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Step 2: Generate Code',
                      style: AppTextStyles.headline2(context),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'From your voice description',
                      style: AppTextStyles.bodyMedium(context),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        widget.transcribedText,
                        style: AppTextStyles.bodyLarge(context),
                      ),
                    ),
                    const SizedBox(height: 20),
                    GradientButton(
                      text: 'Generate Code',
                      onPressed: isLoading ? null : () async => await generateCode(),
                      isLoading: isLoading,
                      icon: Iconsax.code,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: AppColors.card,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Generated Code',
                      style: AppTextStyles.headline2(context),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        generatedCode.isEmpty
                            ? 'Your generated code will appear here...'
                            : generatedCode,
                        style: GoogleFonts.robotoMono(
                          fontSize: 14,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    GradientButton(
                      text: 'Edit & Execute',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CodeEditorScreen(initialCode: generatedCode),
                          ),
                        );
                      },
                      isEnabled: generatedCode.isNotEmpty && !generatedCode.startsWith('Error'),
                      isLoading: isLoading,
                      icon: Iconsax.edit,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}