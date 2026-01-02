import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../services/profile_service.dart';
import '../widgets/friends_section.dart';
import '../widgets/global_section.dart';
import 'profile_registration_screen.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDarkMode;
    
    return Consumer<ProfileService>(
      builder: (context, profileService, child) {
        if (!profileService.isRegistered) {
          return const ProfileRegistrationScreen();
        }

        return Container(
          color: isDark ? AppTheme.backgroundColor : AppTheme.lightBackground,
          child: SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 10),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: AppTheme.primaryGradient,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.people_rounded, color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Community', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: isDark ? AppTheme.textPrimary : AppTheme.lightTextPrimary)),
                          Text('Connect globally via LinkedIn', style: TextStyle(color: isDark ? AppTheme.textMuted : AppTheme.lightTextSecondary, fontSize: 11)),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Tab bar - simple, no animations
                Container(
                  margin: const EdgeInsets.fromLTRB(20, 4, 20, 8),
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: isDark ? AppTheme.surfaceColor : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelColor: Colors.white,
                    unselectedLabelColor: isDark ? AppTheme.textMuted : AppTheme.lightTextSecondary,
                    labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                    dividerColor: Colors.transparent,
                    splashFactory: NoSplash.splashFactory,
                    tabs: const [
                      Tab(height: 36, child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.group, size: 16), SizedBox(width: 6), Text('Friends')])),
                      Tab(height: 36, child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.public, size: 16), SizedBox(width: 6), Text('Global')])),
                    ],
                  ),
                ),
                
                // Tab content
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    physics: const ClampingScrollPhysics(),
                    children: const [
                      FriendsSection(),
                      GlobalSection(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
