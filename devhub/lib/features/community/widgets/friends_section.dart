import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/url_helper.dart';
import '../models/user_profile.dart';
import '../services/profile_service.dart';

class FriendsSection extends StatefulWidget {
  const FriendsSection({super.key});

  @override
  State<FriendsSection> createState() => _FriendsSectionState();
}

class _FriendsSectionState extends State<FriendsSection> {
  bool _showAddForm = false;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _linkedInController = TextEditingController();
  bool _isAdding = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _linkedInController.dispose();
    super.dispose();
  }

  void _addFriend() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isAdding = true);
    
    final profile = UserProfile(
      id: 'manual_${DateTime.now().millisecondsSinceEpoch}',
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      linkedInId: _linkedInController.text.trim(),
      skills: [],
    );
    
    await context.read<ProfileService>().addFriend(profile);
    
    setState(() {
      _isAdding = false;
      _showAddForm = false;
      _nameController.clear();
      _emailController.clear();
      _linkedInController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDarkMode;
    
    return Consumer<ProfileService>(
      builder: (context, profileService, child) {
        final myProfile = profileService.currentProfile;
        final friends = profileService.friends;

        return ListView(
          padding: const EdgeInsets.all(20),
          physics: const BouncingScrollPhysics(),
          children: [
            // My Profile
            if (myProfile != null) ...[
              Text('My Profile', style: TextStyle(color: isDark ? AppTheme.textPrimary : AppTheme.lightTextPrimary, fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 10),
              _MyProfileCard(profile: myProfile, isDark: isDark),
              const SizedBox(height: 24),
            ],
            
            // Friends header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text('My Friends', style: TextStyle(color: isDark ? AppTheme.textPrimary : AppTheme.lightTextPrimary, fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: AppTheme.primaryColor.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
                      child: Text('${friends.length}', style: TextStyle(color: AppTheme.primaryColor, fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () => setState(() => _showAddForm = !_showAddForm),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      gradient: _showAddForm ? null : AppTheme.primaryGradient,
                      color: _showAddForm ? (isDark ? AppTheme.cardColor : Colors.grey.shade200) : null,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(_showAddForm ? Icons.close : Icons.person_add, size: 14, color: _showAddForm ? (isDark ? AppTheme.textSecondary : AppTheme.lightTextSecondary) : Colors.white),
                        const SizedBox(width: 4),
                        Text(_showAddForm ? 'Cancel' : 'Add', style: TextStyle(color: _showAddForm ? (isDark ? AppTheme.textSecondary : AppTheme.lightTextSecondary) : Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            
            // Add Form
            if (_showAddForm) ...[
              const SizedBox(height: 14),
              _buildAddForm(isDark),
            ],
            
            const SizedBox(height: 14),
            
            // Friends list or empty state
            if (friends.isEmpty)
              _buildEmptyState(isDark)
            else
              ...friends.map((friend) => _FriendCard(
                key: ValueKey(friend.id),
                profile: friend,
                isDark: isDark,
                onRemove: () => profileService.removeFriend(friend.id),
              )),
          ],
        );
      },
    );
  }

  Widget _buildAddForm(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.cardColor : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primaryColor.withOpacity(0.2)),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.person_add, color: AppTheme.primaryColor, size: 18),
                const SizedBox(width: 8),
                Text('Add New Friend', style: TextStyle(color: isDark ? AppTheme.textPrimary : AppTheme.lightTextPrimary, fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
            const SizedBox(height: 14),
            _buildFormField(_nameController, 'Full Name *', Icons.person_outline, isDark),
            const SizedBox(height: 10),
            _buildFormField(_emailController, 'Email *', Icons.email_outlined, isDark, isEmail: true),
            const SizedBox(height: 10),
            _buildFormField(_linkedInController, 'LinkedIn ID *', Icons.link, isDark),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              height: 42,
              child: ElevatedButton.icon(
                onPressed: _isAdding ? null : _addFriend,
                icon: _isAdding ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Icon(Icons.check, size: 16),
                label: Text(_isAdding ? '' : 'Add Friend'),
                style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryColor, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormField(TextEditingController controller, String label, IconData icon, bool isDark, {bool isEmail = false}) {
    return TextFormField(
      controller: controller,
      style: TextStyle(color: isDark ? AppTheme.textPrimary : AppTheme.lightTextPrimary, fontSize: 13),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: isDark ? AppTheme.textMuted : AppTheme.lightTextSecondary, fontSize: 12),
        filled: true,
        fillColor: isDark ? AppTheme.surfaceColor : AppTheme.lightSurfaceColor,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        prefixIcon: Icon(icon, color: isDark ? AppTheme.textMuted : AppTheme.lightTextSecondary, size: 18),
        isDense: true,
      ),
      validator: (v) {
        if (v?.trim().isEmpty == true) return 'Required';
        if (isEmail && !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v ?? '')) return 'Invalid email';
        return null;
      },
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.surfaceColor : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(Icons.people_outline, color: AppTheme.primaryColor, size: 36),
          const SizedBox(height: 10),
          Text('No friends yet', style: TextStyle(color: isDark ? AppTheme.textPrimary : AppTheme.lightTextPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text('Add friends or discover in Global tab', style: TextStyle(color: isDark ? AppTheme.textMuted : AppTheme.lightTextSecondary, fontSize: 11), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _MyProfileCard extends StatelessWidget {
  final UserProfile profile;
  final bool isDark;

  const _MyProfileCard({required this.profile, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => UrlHelper.openLinkedIn(profile.linkedInId),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            AppTheme.primaryColor.withOpacity(isDark ? 0.15 : 0.1),
            AppTheme.secondaryColor.withOpacity(isDark ? 0.08 : 0.05),
          ]),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.primaryColor.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Container(
              width: 48, height: 48,
              decoration: BoxDecoration(gradient: AppTheme.primaryGradient, borderRadius: BorderRadius.circular(12)),
              alignment: Alignment.center,
              child: Text(profile.name.isNotEmpty ? profile.name[0].toUpperCase() : '?', style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(child: Text(profile.name, style: TextStyle(color: isDark ? AppTheme.textPrimary : AppTheme.lightTextPrimary, fontWeight: FontWeight.bold, fontSize: 14), overflow: TextOverflow.ellipsis)),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                        decoration: BoxDecoration(color: AppTheme.successColor, borderRadius: BorderRadius.circular(3)),
                        child: const Text('YOU', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(profile.email, style: TextStyle(color: isDark ? AppTheme.textSecondary : AppTheme.lightTextSecondary, fontSize: 11)),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      const Icon(Icons.launch, color: Color(0xFF0077B5), size: 11),
                      const SizedBox(width: 3),
                      Text('@${profile.linkedInId}', style: const TextStyle(color: Color(0xFF0077B5), fontSize: 10, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FriendCard extends StatelessWidget {
  final UserProfile profile;
  final bool isDark;
  final VoidCallback onRemove;

  const _FriendCard({super.key, required this.profile, required this.isDark, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => UrlHelper.openLinkedIn(profile.linkedInId),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isDark ? AppTheme.cardColor : Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(isDark ? 0.1 : 0.05), blurRadius: 6)],
        ),
        child: Row(
          children: [
            Container(
              width: 38, height: 38,
              decoration: BoxDecoration(gradient: AppTheme.primaryGradient, borderRadius: BorderRadius.circular(8)),
              alignment: Alignment.center,
              child: Text(profile.name[0].toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(profile.name, style: TextStyle(color: isDark ? AppTheme.textPrimary : AppTheme.lightTextPrimary, fontWeight: FontWeight.w600, fontSize: 13)),
                  Row(
                    children: [
                      const Icon(Icons.launch, color: Color(0xFF0077B5), size: 10),
                      const SizedBox(width: 3),
                      Expanded(child: Text('@${profile.linkedInId}', style: const TextStyle(color: Color(0xFF0077B5), fontSize: 10), overflow: TextOverflow.ellipsis)),
                    ],
                  ),
                ],
              ),
            ),
            // LinkedIn badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(color: const Color(0xFF0077B5), borderRadius: BorderRadius.circular(4)),
              child: const Text('in', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 6),
            GestureDetector(
              onTap: onRemove,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: AppTheme.errorColor.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                child: Icon(Icons.close, color: AppTheme.errorColor, size: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
