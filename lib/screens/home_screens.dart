import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax/iconsax.dart';
import 'package:vtcode/constant/appcolors.dart';
import 'package:vtcode/constant/apptext.dart';
import 'package:vtcode/constant/button.dart';

import 'generate_code.dart';

class RecordVoiceScreen extends StatefulWidget {
  const RecordVoiceScreen({super.key});

  @override
  _RecordVoiceScreenState createState() => _RecordVoiceScreenState();
}

class _RecordVoiceScreenState extends State<RecordVoiceScreen> {
  String transcribedText = '';
  bool isLoading = false;

  void _showRecordingModal() {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Iconsax.microphone, size: 48, color: AppColors.primary),
                SizedBox(height: 16),
                Text('Listening...', style: AppTextStyles.headline2(context)),
                SizedBox(height: 8),
                Text(
                  'Describe the code you want to generate',
                  style: AppTextStyles.bodyMedium(context),
                ),
                SizedBox(height: 24),
                CircularProgressIndicator(),
                SizedBox(height: 24),
                GradientButton(
                  text: 'Stop Recording',
                  onPressed: () {
                    Navigator.pop(context);
                    recordVoice();
                  },
                  icon: Iconsax.stop,
                ),
              ],
            ),
          ),
    );
  }

  Future<void> recordVoice() async {
    _showRecordingModal();
    setState(() => isLoading = true);
    try {
      const voiceInput =
          'write a python code which will indicate the diamond shape of 5';
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/api/voice-to-text'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'voiceInput': voiceInput}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          transcribedText = data['transcribedText'];
        });
        if (mounted) {
          await showDialog(
            context: context,
            builder:
                (context) => AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  title: Text(
                    'Transcription Complete',
                    style: AppTextStyles.headline2(context),
                  ),
                  content: Text(
                    'Transcribed: $transcribedText',
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
          transcribedText = 'Error in voice processing';
        });
      }
    } catch (e) {
      setState(() {
        transcribedText = 'Error: $e';
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
          'Voice to Code',
          style: AppTextStyles.headline2(context).copyWith(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
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
                      'Step 1: Record Your Voice',
                      style: AppTextStyles.headline2(context),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Describe the code you want to generate',
                      style: AppTextStyles.bodyMedium(context),
                    ),
                    const SizedBox(height: 20),
                    GradientButton(
                      text: 'Start Recording',
                      onPressed: _showRecordingModal,
                      isLoading: isLoading,
                      icon: Iconsax.microphone,
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
                      'Transcription Result',
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
                        transcribedText.isEmpty
                            ? 'Your transcribed text will appear here...'
                            : transcribedText,
                        style: AppTextStyles.bodyLarge(context),
                      ),
                    ),
                    const SizedBox(height: 16),
                    GradientButton(
                      text: 'Generate Code',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => GenerateCodeScreen(
                                  transcribedText: transcribedText,
                                ),
                          ),
                        );
                      },
                      isEnabled:
                          transcribedText.isNotEmpty &&
                          !transcribedText.startsWith('Error') &&
                          !isLoading,
                      isLoading: isLoading,
                      icon: Iconsax.code,
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
