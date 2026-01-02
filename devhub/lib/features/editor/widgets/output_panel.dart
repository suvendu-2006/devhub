import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class OutputPanel extends StatelessWidget {
  final String output;
  final bool isRunning;

  const OutputPanel({
    super.key,
    required this.output,
    required this.isRunning,
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
              border: Border(
                bottom: BorderSide(
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.terminal_rounded,
                  color: AppTheme.successColor,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  'Console Output',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                const Spacer(),
                if (isRunning)
                  SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(AppTheme.successColor),
                    ),
                  ),
              ],
            ),
          ),
          // Output content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: isRunning
                  ? _buildRunningIndicator()
                  : output.isEmpty
                      ? _buildEmptyState()
                      : _buildOutput(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRunningIndicator() {
    return Row(
      children: [
        SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation(AppTheme.primaryColor),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          'Executing code...',
          style: TextStyle(
            color: AppTheme.textSecondary,
            fontFamily: 'monospace',
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.info_outline,
              color: AppTheme.textMuted,
              size: 16,
            ),
            const SizedBox(width: 8),
            Text(
              'Run your code to see output here',
              style: TextStyle(
                color: AppTheme.textMuted,
                fontFamily: 'monospace',
                fontSize: 13,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOutput() {
    return SelectableText(
      output,
      style: TextStyle(
        color: output.startsWith('❌')
            ? AppTheme.errorColor
            : AppTheme.textPrimary,
        fontFamily: 'monospace',
        fontSize: 13,
        height: 1.5,
      ),
    );
  }
}
