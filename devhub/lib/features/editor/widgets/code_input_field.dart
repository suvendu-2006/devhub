import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class CodeInputField extends StatelessWidget {
  final TextEditingController controller;
  final String language;
  final ValueChanged<String>? onChanged;

  const CodeInputField({
    super.key,
    required this.controller,
    required this.language,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Line numbers
        Positioned(
          left: 0,
          top: 0,
          bottom: 0,
          child: Container(
            width: 40,
            decoration: BoxDecoration(
              color: AppTheme.surfaceColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
            ),
            child: ValueListenableBuilder<TextEditingValue>(
              valueListenable: controller,
              builder: (context, value, child) {
                final lines = value.text.split('\n').length;
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  itemCount: lines,
                  itemBuilder: (context, index) {
                    return Container(
                      height: 20,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 8),
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: AppTheme.textMuted.withOpacity(0.5),
                          fontSize: 12,
                          fontFamily: 'monospace',
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
        // Code editor
        Padding(
          padding: const EdgeInsets.only(left: 40),
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            maxLines: null,
            expands: true,
            keyboardType: TextInputType.multiline,
            style: TextStyle(
              color: _getLanguageColor(language),
              fontSize: 14,
              fontFamily: 'monospace',
              height: 1.43,
            ),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(16),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              hintText: 'Start coding here...',
              hintStyle: TextStyle(
                color: AppTheme.textMuted.withOpacity(0.5),
                fontFamily: 'monospace',
              ),
            ),
          ),
        ),
        // Language badge
        Positioned(
          top: 8,
          right: 8,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getLanguageColor(language).withOpacity(0.2),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: _getLanguageColor(language).withOpacity(0.5),
              ),
            ),
            child: Text(
              language,
              style: TextStyle(
                color: _getLanguageColor(language),
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Color _getLanguageColor(String language) {
    switch (language) {
      case 'Python':
        return const Color(0xFF3776AB);
      case 'JavaScript':
        return const Color(0xFFF7DF1E);
      case 'C':
        return const Color(0xFF00599C);
      case 'Java':
        return const Color(0xFFED8B00);
      case 'Dart':
        return const Color(0xFF0175C2);
      default:
        return AppTheme.textPrimary;
    }
  }
}
