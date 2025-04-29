import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highlight/languages/python.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax/iconsax.dart';
import '../constant/appcolors.dart';
import '../constant/apptext.dart';

class CodeEditorScreen extends StatefulWidget {
  final String initialCode;

  const CodeEditorScreen({super.key, required this.initialCode});

  @override
  _CodeEditorScreenState createState() => _CodeEditorScreenState();
}

class _CodeEditorScreenState extends State<CodeEditorScreen> {
  late final CodeController _codeController;
  String executionOutput = '';
  bool isExecuting = false;

  @override
  void initState() {
    super.initState();
    _codeController = CodeController(
      text: widget.initialCode,
      language: python,
    );
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> executeCode() async {
    setState(() {
      isExecuting = true;
      executionOutput = '';
    });

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/api/execute-code'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'code': _codeController.text}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          executionOutput = data['output'];
        });
      } else {
        setState(() {
          executionOutput = 'Error in code execution: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        executionOutput = 'Error: $e';
      });
    } finally {
      setState(() => isExecuting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Code Editor',
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
        actions: [
          IconButton(
            icon: const Icon(Iconsax.play_circle, size: 24),
            onPressed: isExecuting ? null : executeCode,
            tooltip: 'Run Code',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
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
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: CodeTheme(
                    data: CodeThemeData(styles: {
                      'keyword': TextStyle(color: Colors.blue.shade800),
                      'comment': TextStyle(color: Colors.green.shade600),
                      'string': TextStyle(color: Colors.red.shade600),
                      'number': TextStyle(color: Colors.purple.shade600),
                      'class': TextStyle(color: Colors.blue.shade800),
                      'constant': TextStyle(color: Colors.teal),
                    }),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.4,
                        minHeight: 200,
                      ),
                      child: CodeField(
                        controller: _codeController,
                        textStyle: GoogleFonts.robotoMono(fontSize: 14),
                        minLines: 10,
                        maxLines: 20,
                        gutterStyle: GutterStyle(
                          showLineNumbers: true,
                          textStyle: GoogleFonts.robotoMono(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
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
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: 200,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                        child: Text(
                          'Execution Output',
                          style: AppTextStyles.headline2(context),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          margin: const EdgeInsets.all(16),
                          child: SingleChildScrollView(
                            child: Text(
                              executionOutput.isEmpty
                                  ? 'Output will appear here...'
                                  : executionOutput,
                              style: GoogleFonts.robotoMono(fontSize: 14),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: executeCode,
        backgroundColor: AppColors.primary,
        child: isExecuting
            ? const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        )
            : const Icon(Iconsax.play, color: Colors.white),
      ),
    );
  }
}