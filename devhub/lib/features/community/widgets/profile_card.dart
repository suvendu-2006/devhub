import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_theme.dart';
import '../models/user_profile.dart';

class ProfileCard extends StatelessWidget {
  final UserProfile profile;
  final bool isCurrentUser;
  final bool showAddButton;
  final bool showRemoveButton;
  final bool showMatchReason;
  final String? matchReason;
  final VoidCallback? onAdd;
  final VoidCallback? onRemove;

  const ProfileCard({
    super.key,
    required this.profile,
    this.isCurrentUser = false,
    this.showAddButton = false,
    this.showRemoveButton = false,
    this.showMatchReason = false,
    this.matchReason,
    this.onAdd,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: isCurrentUser
            ? LinearGradient(
                colors: [
                  AppTheme.primaryColor.withOpacity(0.2),
                  AppTheme.surfaceColor,
                ],
              )
            : null,
        color: isCurrentUser ? null : AppTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCurrentUser
              ? AppTheme.primaryColor.withOpacity(0.3)
              : Colors.transparent,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Avatar
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: AppTheme.primaryGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    profile.name.isNotEmpty ? profile.name[0].toUpperCase() : '?',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              profile.name,
                              style: TextStyle(
                                color: AppTheme.textPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isCurrentUser) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryColor,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'YOU',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      GestureDetector(
                        onTap: () => _openLinkedIn(),
                        child: Row(
                          children: [
                            Icon(
                              Icons.link,
                              color: AppTheme.secondaryColor,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '@${profile.linkedInId}',
                              style: TextStyle(
                                color: AppTheme.secondaryColor,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (showAddButton)
                  _buildActionButton(
                    icon: Icons.person_add,
                    color: AppTheme.successColor,
                    onTap: onAdd,
                  ),
                if (showRemoveButton)
                  _buildActionButton(
                    icon: Icons.person_remove,
                    color: AppTheme.errorColor,
                    onTap: onRemove,
                  ),
              ],
            ),
            
            if (profile.bio != null && profile.bio!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                profile.bio!,
                style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 13,
                  height: 1.4,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            
            if (profile.skills.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: profile.skills.take(4).map((skill) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      skill,
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],

            if (showMatchReason && matchReason != null) ...[
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(
                    Icons.auto_awesome,
                    color: AppTheme.warningColor,
                    size: 14,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    matchReason!,
                    style: TextStyle(
                      color: AppTheme.warningColor,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: color,
          size: 20,
        ),
      ),
    );
  }

  Future<void> _openLinkedIn() async {
    final url = Uri.parse('https://linkedin.com/in/${profile.linkedInId}');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }
}
