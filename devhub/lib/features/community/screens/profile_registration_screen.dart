import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../models/user_profile.dart';
import '../services/profile_service.dart';

class ProfileRegistrationScreen extends StatefulWidget {
  const ProfileRegistrationScreen({super.key});

  @override
  State<ProfileRegistrationScreen> createState() => _ProfileRegistrationScreenState();
}

class _ProfileRegistrationScreenState extends State<ProfileRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _linkedInController = TextEditingController();
  final _bioController = TextEditingController();
  
  final List<String> _allSkills = [
    'Python', 'JavaScript', 'Java', 'C++', 'Dart',
    'Machine Learning', 'Deep Learning', 'NLP', 'Computer Vision',
    'React', 'Flutter', 'Node.js', 'TensorFlow', 'PyTorch',
  ];
  
  final Set<String> _selectedSkills = {};
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _linkedInController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);
    
    try {
      final profile = UserProfile(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        linkedInId: _linkedInController.text.trim(),
        skills: _selectedSkills.toList(),
        bio: _bioController.text.trim().isEmpty ? null : _bioController.text.trim(),
      );
      await context.read<ProfileService>().registerProfile(profile);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    
    return Scaffold(
      backgroundColor: isDark ? AppTheme.backgroundColor : const Color(0xFFF5F7FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                
                // Header
                Center(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: AppTheme.primaryGradient,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primaryColor.withOpacity(0.4),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.person_add_rounded,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Join the Community',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Create your profile to connect with fellow learners',
                        style: TextStyle(
                          color: isDark ? AppTheme.textSecondary : Colors.grey.shade600,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // Name field
                _buildLabel('Full Name', true, isDark),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _nameController,
                  style: TextStyle(color: isDark ? AppTheme.textPrimary : Colors.black87),
                  decoration: InputDecoration(
                    hintText: 'Enter your full name',
                    filled: true,
                    fillColor: isDark ? AppTheme.surfaceColor : Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    prefixIcon: Icon(Icons.person_outline, color: isDark ? AppTheme.textMuted : Colors.grey),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 20),
                
                // Email field
                _buildLabel('Email Address', true, isDark),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _emailController,
                  style: TextStyle(color: isDark ? AppTheme.textPrimary : Colors.black87),
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Enter your email',
                    filled: true,
                    fillColor: isDark ? AppTheme.surfaceColor : Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    prefixIcon: Icon(Icons.email_outlined, color: isDark ? AppTheme.textMuted : Colors.grey),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 20),
                
                // LinkedIn field
                _buildLabel('LinkedIn ID', true, isDark),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _linkedInController,
                  style: TextStyle(color: isDark ? AppTheme.textPrimary : Colors.black87),
                  decoration: InputDecoration(
                    hintText: 'Your LinkedIn username',
                    filled: true,
                    fillColor: isDark ? AppTheme.surfaceColor : Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    prefixIcon: Icon(Icons.link, color: isDark ? AppTheme.textMuted : Colors.grey),
                    prefixText: 'linkedin.com/in/',
                    prefixStyle: TextStyle(color: isDark ? AppTheme.textMuted : Colors.grey, fontSize: 14),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your LinkedIn ID';
                    }
                    // LinkedIn IDs can contain letters, numbers, hyphens, and underscores
                    if (!RegExp(r'^[a-zA-Z0-9\-_]{3,100}$').hasMatch(value.trim())) {
                      return 'Invalid LinkedIn ID (use letters, numbers, - or _)';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 20),
                
                // Bio field
                _buildLabel('Bio', false, isDark),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _bioController,
                  style: TextStyle(color: isDark ? AppTheme.textPrimary : Colors.black87),
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Tell us about yourself (optional)',
                    filled: true,
                    fillColor: isDark ? AppTheme.surfaceColor : Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Skills selection
                _buildLabel('Skills & Interests', false, isDark),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _allSkills.map((skill) {
                    final isSelected = _selectedSkills.contains(skill);
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            _selectedSkills.remove(skill);
                          } else {
                            _selectedSkills.add(skill);
                          }
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          gradient: isSelected ? AppTheme.primaryGradient : null,
                          color: isSelected ? null : (isDark ? AppTheme.surfaceColor : Colors.white),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected ? Colors.transparent : (isDark ? AppTheme.cardColor : Colors.grey.shade300),
                          ),
                        ),
                        child: Text(
                          skill,
                          style: TextStyle(
                            color: isSelected ? Colors.white : (isDark ? AppTheme.textSecondary : Colors.grey.shade700),
                            fontSize: 13,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                
                const SizedBox(height: 40),
                
                // Register button
                SizedBox(
                  width: double.infinity,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryColor.withOpacity(0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _register,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation(Colors.white),
                              ),
                            )
                          : const Text(
                              'Join Community',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text, bool required, bool isDark) {
    return Row(
      children: [
        Text(
          text,
          style: TextStyle(
            color: isDark ? AppTheme.textPrimary : Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        if (required) ...[
          const SizedBox(width: 4),
          Text(
            '*',
            style: TextStyle(
              color: AppTheme.errorColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ],
    );
  }
}
