import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/theme/app_theme.dart';
import '../services/ai_feedback_service.dart';
import '../services/code_executor_service.dart';

class CodeEditorScreen extends StatefulWidget {
  const CodeEditorScreen({super.key});

  @override
  State<CodeEditorScreen> createState() => _CodeEditorScreenState();
}

class _CodeEditorScreenState extends State<CodeEditorScreen> {
  final TextEditingController _codeController = TextEditingController();
  final AIFeedbackService _aiFeedbackService = AIFeedbackService();
  final CodeExecutorService _syntaxChecker = CodeExecutorService();
  
  String _selectedLanguage = 'Python';
  String _output = '';
  String _aiFeedback = '';
  bool _isChecking = false;
  bool _isAnalyzing = false;
  bool _showOutput = true;

  final List<String> _languages = ['Python', 'JavaScript', 'C', 'Java', 'Dart'];

  @override
  void initState() {
    super.initState();
    _codeController.text = _getStarterCode(_selectedLanguage);
  }

  String _getStarterCode(String language) {
    switch (language) {
      case 'Python':
        return 'print("Hello, World!")';
      case 'JavaScript':
        return 'console.log("Hello, World!");';
      case 'C':
        return '#include <stdio.h>\n\nint main() {\n    printf("Hello, World!");\n    return 0;\n}';
      case 'Java':
        return 'public class Main {\n    public static void main(String[] args) {\n        System.out.println("Hello, World!");\n    }\n}';
      case 'Dart':
        return 'void main() {\n  print("Hello, World!");\n}';
      default:
        return '';
    }
  }

  Future<void> _checkSyntax() async {
    setState(() {
      _isChecking = true;
      _showOutput = true;
      _output = 'Checking syntax...';
    });

    try {
      final result = await _syntaxChecker.execute(
        _codeController.text,
        _selectedLanguage,
      );

      if (mounted) {
        setState(() {
          _output = result;
          _isChecking = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _output = '❌ Error checking syntax: $e\n\nPlease try again.';
          _isChecking = false;
        });
      }
    }
  }

  Future<void> _getAIFeedback() async {
    setState(() {
      _isAnalyzing = true;
      _showOutput = false;
      _aiFeedback = 'Analyzing...';
    });

    try {
      final feedback = await _aiFeedbackService.analyzeCode(
        _codeController.text,
        _selectedLanguage,
      );

      if (mounted) {
        setState(() {
          _aiFeedback = feedback;
          _isAnalyzing = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _aiFeedback = '❌ Error getting AI feedback: $e\n\nPlease try again.';
          _isAnalyzing = false;
        });
      }
    }
  }

  void _shareCode() {
    final code = _codeController.text.trim();
    if (code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('No code to share! Write some code first.'),
          backgroundColor: AppTheme.warningColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    final shareText = '''📝 $_selectedLanguage Code from DevHub

```$_selectedLanguage
$code
```

Shared via DevHub - Learn to Code! 🚀''';

    Share.share(shareText, subject: '$_selectedLanguage Code Snippet');
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDarkMode;
    
    return Container(
      color: isDark ? AppTheme.backgroundColor : AppTheme.lightBackground,
      child: SafeArea(
        child: Column(
          children: [
            // Header with language selector
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.code, size: 18, color: Colors.white),
                  ),
                  const SizedBox(width: 10),
                  Text('Code Editor', style: TextStyle(color: isDark ? AppTheme.textPrimary : AppTheme.lightTextPrimary, fontWeight: FontWeight.bold, fontSize: 16)),
                  const Spacer(),
                  // Language Selector
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: isDark ? AppTheme.surfaceColor : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.primaryColor.withOpacity(0.3)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedLanguage,
                        dropdownColor: isDark ? AppTheme.cardColor : Colors.white,
                        style: TextStyle(color: isDark ? AppTheme.textPrimary : AppTheme.lightTextPrimary, fontSize: 13),
                        icon: Icon(Icons.arrow_drop_down, color: AppTheme.primaryColor, size: 20),
                        isDense: true,
                        items: _languages.map((lang) => DropdownMenuItem(
                          value: lang,
                          child: Text(lang),
                        )).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedLanguage = value;
                              _codeController.text = _getStarterCode(value);
                              _output = '';
                              _aiFeedback = '';
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // VS Code Style Layout: Code Editor (left) + Syntax Panel (right)
            Expanded(
              child: Row(
                children: [
                  // Left: Code Editor
                  Expanded(
                    flex: 3,
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(12, 0, 6, 8),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: isDark ? AppTheme.cardColor : Colors.grey.shade300),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Column(
                          children: [
                            // Editor header
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: isDark ? AppTheme.surfaceColor : Colors.grey.shade100,
                                border: Border(bottom: BorderSide(color: isDark ? AppTheme.cardColor : Colors.grey.shade300)),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.description_outlined, size: 14, color: isDark ? AppTheme.textMuted : Colors.grey),
                                  const SizedBox(width: 6),
                                  Text('main.${_getFileExtension(_selectedLanguage)}', style: TextStyle(color: isDark ? AppTheme.textMuted : AppTheme.lightTextSecondary, fontSize: 12)),
                                ],
                              ),
                            ),
                            // Code input
                            Expanded(
                              child: TextField(
                                controller: _codeController,
                                maxLines: null,
                                expands: true,
                                style: TextStyle(
                                  color: isDark ? const Color(0xFFE0E0E0) : const Color(0xFF1E1E2E),
                                  fontSize: 14,
                                  fontFamily: 'monospace',
                                  height: 1.5,
                                ),
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(16),
                                  border: InputBorder.none,
                                  fillColor: isDark ? const Color(0xFF1E1E2E) : Colors.white,
                                  filled: true,
                                  hintText: 'Write your code here...',
                                  hintStyle: TextStyle(color: isDark ? const Color(0xFF5C5C5C) : Colors.grey.shade400),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  // Right: Syntax Check Panel (Vertical)
                  Expanded(
                    flex: 2,
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(6, 0, 12, 8),
                      decoration: BoxDecoration(
                        color: isDark ? AppTheme.surfaceColor : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: isDark ? AppTheme.cardColor : Colors.grey.shade300),
                      ),
                      child: Column(
                        children: [
                          // Check Syntax Button
                          InkWell(
                            onTap: _isChecking ? null : _checkSyntax,
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                gradient: AppTheme.successGradient,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(12),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (_isChecking)
                                    const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                                  else
                                    const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 20),
                                  const SizedBox(width: 8),
                                  Text(
                                    _isChecking ? 'Running...' : 'Run Code',
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Output Panel
                          Expanded(child: _buildOutputPanel(isDark)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Bottom Action Buttons: AI Tips + Share (Horizontal)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Row(
                children: [
                  Expanded(
                    child: _ActionButton(
                      icon: Icons.auto_awesome,
                      label: _isAnalyzing ? 'Analyzing...' : 'AI Tips',
                      colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
                      isLoading: _isAnalyzing,
                      onPressed: _isAnalyzing ? null : _getAIFeedback,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _ActionButton(
                      icon: Icons.share,
                      label: 'Share Code',
                      colors: [const Color(0xFF3B82F6), const Color(0xFF1D4ED8)],
                      isLoading: false,
                      onPressed: _shareCode,
                    ),
                  ),
                ],
              ),
            ),
            
            // AI Feedback Panel (collapsible)
            if (_aiFeedback.isNotEmpty || _isAnalyzing)
              Container(
                height: 150,
                margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                decoration: BoxDecoration(
                  color: isDark ? AppTheme.surfaceColor : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.primaryColor.withOpacity(0.3)),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: _buildAIPanel(isDark),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _getFileExtension(String language) {
    switch (language) {
      case 'Python': return 'py';
      case 'JavaScript': return 'js';
      case 'C': return 'c';
      case 'Java': return 'java';
      case 'Dart': return 'dart';
      default: return 'txt';
    }
  }

  Widget _buildOutputPanel(bool isDark) {
    final hasError = _output.contains('❌');
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(border: Border(bottom: BorderSide(color: isDark ? AppTheme.cardColor : Colors.grey.shade300))),
          child: Row(
            children: [
              Icon(
                hasError ? Icons.error_outline : Icons.check_circle_outline,
                color: hasError ? AppTheme.errorColor : AppTheme.successColor,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                'Syntax Checker',
                style: TextStyle(color: isDark ? AppTheme.textPrimary : AppTheme.lightTextPrimary, fontWeight: FontWeight.w600, fontSize: 13),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppTheme.warningColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Simulation',
                  style: TextStyle(color: AppTheme.warningColor, fontSize: 10, fontWeight: FontWeight.w600),
                ),
              ),
              if (_isChecking) ...[
                const SizedBox(width: 8),
                SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.successColor)),
              ],
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: SelectableText(
              _output.isEmpty ? 'Click "Check Syntax" to validate your code' : _output,
              style: TextStyle(
                color: hasError ? AppTheme.errorColor : _output.isEmpty ? (isDark ? AppTheme.textMuted : AppTheme.lightTextSecondary) : (isDark ? AppTheme.textPrimary : AppTheme.lightTextPrimary),
                fontFamily: 'monospace',
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAIPanel(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [AppTheme.primaryColor.withOpacity(0.15), Colors.transparent]),
            border: Border(bottom: BorderSide(color: isDark ? AppTheme.cardColor : Colors.grey.shade300)),
          ),
          child: Row(
            children: [
              Icon(Icons.lightbulb_outline, color: AppTheme.primaryColor, size: 16),
              const SizedBox(width: 8),
              Text('AI Learning Tips', style: TextStyle(color: isDark ? AppTheme.textPrimary : AppTheme.lightTextPrimary, fontWeight: FontWeight.w600, fontSize: 13)),
              if (_isAnalyzing) ...[
                const Spacer(),
                SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.primaryColor)),
              ],
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: SelectableText(
              _aiFeedback.isEmpty ? 'Click "AI Tips" to get learning suggestions' : _aiFeedback,
              style: TextStyle(
                color: _aiFeedback.isEmpty ? (isDark ? AppTheme.textMuted : AppTheme.lightTextSecondary) : (isDark ? AppTheme.textSecondary : AppTheme.lightTextPrimary),
                fontSize: 13,
                height: 1.6,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final List<Color> colors;
  final bool isLoading;
  final VoidCallback? onPressed;

  const _ActionButton({required this.icon, required this.label, required this.colors, this.isLoading = false, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(10),
        child: Ink(
          decoration: BoxDecoration(
            gradient: onPressed != null ? LinearGradient(colors: colors) : null,
            color: onPressed == null ? AppTheme.surfaceColor : null,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isLoading)
                  SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                else
                  Icon(icon, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isDark;

  const _TabButton({required this.label, required this.isSelected, required this.onTap, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.primaryColor.withOpacity(0.2) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected 
                  ? AppTheme.primaryColor 
                  : (isDark ? AppTheme.cardColor : Colors.grey.shade400),
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected 
                  ? AppTheme.primaryColor 
                  : (isDark ? AppTheme.textMuted : AppTheme.lightTextSecondary),
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal, 
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}
