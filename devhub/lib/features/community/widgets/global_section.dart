import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/url_helper.dart';
import '../models/user_profile.dart';
import '../services/profile_service.dart';

class GlobalSection extends StatefulWidget {
  const GlobalSection({super.key});

  @override
  State<GlobalSection> createState() => _GlobalSectionState();
}

class _GlobalSectionState extends State<GlobalSection> {
  List<UserProfile> _profiles = [];
  bool _isRefreshing = false;
  
  @override
  void initState() {
    super.initState();
    _loadProfiles();
  }
  
  void _loadProfiles() {
    final profileService = context.read<ProfileService>();
    _profiles = profileService.getGlobalProfiles();
  }

  Future<void> _refreshProfiles() async {
    setState(() => _isRefreshing = true);
    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;
    final profileService = context.read<ProfileService>();
    setState(() {
      _profiles = profileService.getGlobalProfiles();
      _isRefreshing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDarkMode;
    final friends = context.watch<ProfileService>().friends;
    
    final filteredProfiles = _profiles.where((p) => !friends.any((f) => f.linkedInId == p.linkedInId)).toList();

    return Column(
      children: [
        // Header with refresh button
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
          child: _buildHeader(isDark),
        ),
        
        // Profile list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            physics: const BouncingScrollPhysics(),
            itemCount: filteredProfiles.length,
            itemBuilder: (context, index) {
              final profile = filteredProfiles[index];
              return _ProfileCard(
                key: ValueKey(profile.linkedInId),
                profile: profile,
                isDark: isDark,
                onAdd: () {
                  context.read<ProfileService>().addFriend(profile);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${profile.name} added to friends!'),
                      backgroundColor: AppTheme.successColor,
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.secondaryColor.withOpacity(isDark ? 0.12 : 0.08),
            AppTheme.primaryColor.withOpacity(isDark ? 0.08 : 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [AppTheme.secondaryColor, AppTheme.primaryColor]),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.public_rounded, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Global Network', style: TextStyle(color: isDark ? AppTheme.textPrimary : AppTheme.lightTextPrimary, fontWeight: FontWeight.bold, fontSize: 15)),
                Text('Tap profile to connect on LinkedIn', style: TextStyle(color: isDark ? AppTheme.textMuted : AppTheme.lightTextSecondary, fontSize: 11)),
              ],
            ),
          ),
          // Refresh button
          GestureDetector(
            onTap: _isRefreshing ? null : _refreshProfiles,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(10),
              ),
              child: _isRefreshing
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.refresh_rounded, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final UserProfile profile;
  final bool isDark;
  final VoidCallback onAdd;

  const _ProfileCard({super.key, required this.profile, required this.isDark, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => UrlHelper.openLinkedIn(profile.linkedInId),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? AppTheme.cardColor : Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(isDark ? 0.12 : 0.06), blurRadius: 10, offset: const Offset(0, 2))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile header
            Row(
              children: [
                Container(
                  width: 48, height: 48,
                  decoration: BoxDecoration(gradient: AppTheme.primaryGradient, borderRadius: BorderRadius.circular(12)),
                  alignment: Alignment.center,
                  child: Text(profile.name[0].toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(profile.name, style: TextStyle(color: isDark ? AppTheme.textPrimary : AppTheme.lightTextPrimary, fontWeight: FontWeight.bold, fontSize: 14)),
                      Row(
                        children: [
                          const Icon(Icons.launch, color: Color(0xFF0077B5), size: 12),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text('linkedin.com/in/${profile.linkedInId}', style: const TextStyle(color: Color(0xFF0077B5), fontSize: 11), overflow: TextOverflow.ellipsis),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // LinkedIn badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: const Color(0xFF0077B5), borderRadius: BorderRadius.circular(6)),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.open_in_new, color: Colors.white, size: 12),
                      SizedBox(width: 4),
                      Text('in', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
            
            // Bio
            if (profile.bio != null) ...[
              const SizedBox(height: 10),
              Text(profile.bio!, style: TextStyle(color: isDark ? AppTheme.textSecondary : AppTheme.lightTextSecondary, fontSize: 12, height: 1.3), maxLines: 2, overflow: TextOverflow.ellipsis),
            ],
            
            // Skills
            const SizedBox(height: 10),
            SizedBox(
              height: 26,
              child: ListView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                children: profile.skills.map((s) => Container(
                  margin: const EdgeInsets.only(right: 6),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: AppTheme.primaryColor.withOpacity(isDark ? 0.2 : 0.1), borderRadius: BorderRadius.circular(12)),
                  child: Text(s, style: TextStyle(color: AppTheme.primaryColor, fontSize: 10, fontWeight: FontWeight.w500)),
                )).toList(),
              ),
            ),
            
            // Add Friend button
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onAdd,
                icon: const Icon(Icons.person_add_rounded, size: 16),
                label: const Text('Add to Friends'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
