import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class AIAssistantPanel extends StatelessWidget {
  final String feedback;
  final bool isAnalyzing;

  const AIAssistantPanel({
    super.key,
    required this.feedback,
    required this.isAnalyzing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppTheme.glassDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.primaryColor.withOpacity(0.2),
                  Colors.transparent,
                ],
              ),
              border: Border(
                bottom: BorderSide(
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    gradient: AppTheme.primaryGradient,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'AI Learning Assistant',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.secondaryColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Guided Mode',
                    style: TextStyle(
                      color: AppTheme.secondaryColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: isAnalyzing
                  ? _buildAnalyzingIndicator()
                  : feedback.isEmpty
                      ? _buildEmptyState()
                      : _buildFeedback(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyzingIndicator() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation(AppTheme.primaryColor),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Analyzing your code...',
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'Looking for patterns and opportunities to guide your learning...',
          style: TextStyle(
            color: AppTheme.textMuted,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.primaryColor.withOpacity(0.3),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    color: AppTheme.primaryColor,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Ready to Help You Learn!',
                    style: TextStyle(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Tap "AI Guide" to get personalized feedback on your code. '
                'I\'ll help you understand concepts and guide you toward solutions '
                'without giving away the answers.',
                style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          '💡 Tip: Write some code first, then ask for guidance!',
          style: TextStyle(
            color: AppTheme.textMuted,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildFeedback() {
    // Parse and style the feedback
    final sections = feedback.split('---');
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: sections.map((section) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.cardColor.withOpacity(0.5),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withOpacity(0.05),
            ),
          ),
          child: _formatFeedbackText(section.trim()),
        );
      }).toList(),
    );
  }

  Widget _formatFeedbackText(String text) {
    final lines = text.split('\n');
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: lines.map((line) {
        // Title lines (emoji at start)
        if (line.startsWith('🔍') || 
            line.startsWith('✨') || 
            line.startsWith('🎯') ||
            line.startsWith('📐') ||
            line.startsWith('🖨️') ||
            line.startsWith('📝') ||
            line.startsWith('⚡') ||
            line.startsWith('🔄') ||
            line.startsWith('📦') ||
            line.startsWith('📚') ||
            line.startsWith('🚀') ||
            line.startsWith('↩️') ||
            line.startsWith('🏗️') ||
            line.startsWith('📋')) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              line,
              style: TextStyle(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          );
        }
        
        // Hint lines
        if (line.startsWith('💡')) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.warningColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.warningColor.withOpacity(0.3),
                ),
              ),
              child: Text(
                line,
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
            ),
          );
        }
        
        // Encouragement lines
        if (line.startsWith('🌟')) {
          return Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              line,
              style: TextStyle(
                color: AppTheme.successColor,
                fontSize: 13,
                fontStyle: FontStyle.italic,
              ),
            ),
          );
        }
        
        // Regular lines
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Text(
            line,
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 13,
              height: 1.5,
            ),
          ),
        );
      }).toList(),
    );
  }
}
