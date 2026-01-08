import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../models/career_goal.dart';
import '../models/skill_gap.dart';
import '../services/progress_service.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  final _formKey = GlobalKey<FormState>();
  final _roleController = TextEditingController();
  final _skillController = TextEditingController();
  int _selectedExperience = 0;
  String? _selectedGoalId;
  bool _showAnalysis = false;

  @override
  void dispose() {
    _roleController.dispose();
    _skillController.dispose();
    super.dispose();
  }

  void _addSkill(String skill) {
    if (skill.trim().isEmpty) return;
    context.read<ProgressService>().addSkill(skill.trim());
    _skillController.clear();
  }

  void _analyzeProgress() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedGoalId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a career goal'), backgroundColor: AppTheme.errorColor),
      );
      return;
    }
    
    final service = context.read<ProgressService>();
    service.setCurrentRole(_roleController.text.trim());
    service.setYearsExperience(_selectedExperience);
    service.setSelectedGoal(_selectedGoalId!);
    service.analyzeProgress();
    
    setState(() => _showAnalysis = true);
  }

  void _resetAnalysis() {
    context.read<ProgressService>().reset();
    _roleController.clear();
    _skillController.clear();
    setState(() {
      _selectedExperience = 0;
      _selectedGoalId = null;
      _showAnalysis = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDarkMode;
    final progressService = context.watch<ProgressService>();

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
                    decoration: BoxDecoration(gradient: AppTheme.primaryGradient, borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.trending_up_rounded, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Career Progress', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: isDark ? AppTheme.textPrimary : AppTheme.lightTextPrimary)),
                        Text(_showAnalysis ? 'Your skill gap analysis' : 'Track your career journey', style: TextStyle(color: isDark ? AppTheme.textMuted : AppTheme.lightTextSecondary, fontSize: 11)),
                      ],
                    ),
                  ),
                  if (_showAnalysis)
                    GestureDetector(
                      onTap: _resetAnalysis,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isDark ? AppTheme.surfaceColor : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.refresh_rounded, color: isDark ? AppTheme.textSecondary : AppTheme.lightTextSecondary, size: 18),
                      ),
                    ),
                ],
              ),
            ),
            
            // Content
            Expanded(
              child: _showAnalysis && progressService.hasAnalysis
                  ? _buildAnalysisView(isDark, progressService)
                  : _buildInputForm(isDark, progressService),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputForm(bool isDark, ProgressService service) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(20),
        physics: const ClampingScrollPhysics(),
        children: [
          // Current Role
          Text('Your Current Role', style: TextStyle(color: isDark ? AppTheme.textPrimary : AppTheme.lightTextPrimary, fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 8),
          TextFormField(
            controller: _roleController,
            style: TextStyle(color: isDark ? AppTheme.textPrimary : AppTheme.lightTextPrimary, fontSize: 14),
            decoration: InputDecoration(
              hintText: 'e.g., Junior Developer, Student, Intern',
              hintStyle: TextStyle(color: isDark ? AppTheme.textMuted : AppTheme.lightTextSecondary),
              filled: true,
              fillColor: isDark ? AppTheme.surfaceColor : Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              prefixIcon: Icon(Icons.work_outline, color: isDark ? AppTheme.textMuted : AppTheme.lightTextSecondary),
            ),
            validator: (v) => v?.trim().isEmpty == true ? 'Please enter your role' : null,
          ),
          
          const SizedBox(height: 20),
          
          // Experience
          Text('Years of Experience', style: TextStyle(color: isDark ? AppTheme.textPrimary : AppTheme.lightTextPrimary, fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isDark ? AppTheme.surfaceColor : Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.timeline, color: isDark ? AppTheme.textMuted : AppTheme.lightTextSecondary),
                const SizedBox(width: 12),
                Expanded(
                  child: Slider(
                    value: _selectedExperience.toDouble(),
                    min: 0,
                    max: 15,
                    divisions: 15,
                    activeColor: AppTheme.primaryColor,
                    inactiveColor: isDark ? AppTheme.cardColor : Colors.grey.shade300,
                    onChanged: (v) => setState(() => _selectedExperience = v.round()),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: AppTheme.primaryGradient,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text('$_selectedExperience yr${_selectedExperience != 1 ? 's' : ''}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Current Skills
          Row(
            children: [
              Text('Your Current Skills', style: TextStyle(color: isDark ? AppTheme.textPrimary : AppTheme.lightTextPrimary, fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: AppTheme.primaryColor.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
                child: Text('${service.currentSkills.length}', style: TextStyle(color: AppTheme.primaryColor, fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _skillController,
                  style: TextStyle(color: isDark ? AppTheme.textPrimary : AppTheme.lightTextPrimary, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Add a skill (e.g., Python)',
                    hintStyle: TextStyle(color: isDark ? AppTheme.textMuted : AppTheme.lightTextSecondary),
                    filled: true,
                    fillColor: isDark ? AppTheme.surfaceColor : Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                  onFieldSubmitted: _addSkill,
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => _addSkill(_skillController.text),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(gradient: AppTheme.primaryGradient, borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.add, color: Colors.white, size: 20),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          
          // Skills chips
          if (service.currentSkills.isNotEmpty)
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: service.currentSkills.map((skill) => Chip(
                label: Text(skill, style: TextStyle(color: isDark ? AppTheme.textPrimary : AppTheme.lightTextPrimary, fontSize: 12)),
                backgroundColor: isDark ? AppTheme.cardColor : Colors.grey.shade100,
                deleteIcon: Icon(Icons.close, size: 16, color: isDark ? AppTheme.textMuted : AppTheme.lightTextSecondary),
                onDeleted: () => service.removeSkill(skill),
                side: BorderSide.none,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              )).toList(),
            ),
          
          // Quick add suggestions
          const SizedBox(height: 8),
          Text('Quick Add:', style: TextStyle(color: isDark ? AppTheme.textMuted : AppTheme.lightTextSecondary, fontSize: 11)),
          const SizedBox(height: 4),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: ['Python', 'JavaScript', 'React', 'SQL', 'Git', 'Docker', 'AWS']
                .where((s) => !service.currentSkills.contains(s))
                .map((skill) => GestureDetector(
                      onTap: () => service.addSkill(skill),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppTheme.primaryColor.withOpacity(0.3)),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text('+ $skill', style: TextStyle(color: AppTheme.primaryColor, fontSize: 11)),
                      ),
                    ))
                .toList(),
          ),
          
          const SizedBox(height: 24),
          
          // Career Goal
          Text('Your Career Goal', style: TextStyle(color: isDark ? AppTheme.textPrimary : AppTheme.lightTextPrimary, fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 8),
          ...CareerGoals.all.map((goal) => _buildGoalOption(goal, isDark)),
          
          const SizedBox(height: 24),
          
          // Analyze button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: _analyzeProgress,
              icon: const Icon(Icons.analytics_rounded),
              label: const Text('Analyze My Progress', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
            ),
          ),
          
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildGoalOption(CareerGoal goal, bool isDark) {
    final isSelected = _selectedGoalId == goal.id;
    return GestureDetector(
      onTap: () => setState(() => _selectedGoalId = goal.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor.withOpacity(isDark ? 0.2 : 0.1) : (isDark ? AppTheme.surfaceColor : Colors.white),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? AppTheme.primaryColor : Colors.transparent, width: 2),
        ),
        child: Row(
          children: [
            Text(goal.icon, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(goal.title, style: TextStyle(color: isDark ? AppTheme.textPrimary : AppTheme.lightTextPrimary, fontWeight: FontWeight.w600, fontSize: 13)),
                  Text(goal.description, style: TextStyle(color: isDark ? AppTheme.textMuted : AppTheme.lightTextSecondary, fontSize: 11)),
                ],
              ),
            ),
            if (isSelected)
              Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(color: AppTheme.primaryColor, shape: BoxShape.circle),
                child: const Icon(Icons.check, color: Colors.white, size: 14),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalysisView(bool isDark, ProgressService service) {
    final analysis = service.analysis!;
    final goal = service.selectedGoal!;
    
    return ListView(
      padding: const EdgeInsets.all(20),
      physics: const ClampingScrollPhysics(),
      children: [
        // Goal header
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: AppTheme.primaryGradient,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Text(goal.icon, style: const TextStyle(fontSize: 36)),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Goal: ${goal.title}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 4),
                    Text('${goal.level} Level • ${goal.minExperienceYears}+ years experience', style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Progress circle
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? AppTheme.cardColor : Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: CircularProgressIndicator(
                      value: analysis.matchPercentage / 100,
                      strokeWidth: 10,
                      backgroundColor: isDark ? AppTheme.surfaceColor : Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation(
                        analysis.matchPercentage >= 80 ? AppTheme.successColor :
                        analysis.matchPercentage >= 50 ? AppTheme.warningColor : AppTheme.errorColor,
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Text('${analysis.matchPercentage.round()}%', style: TextStyle(color: isDark ? AppTheme.textPrimary : AppTheme.lightTextPrimary, fontWeight: FontWeight.bold, fontSize: 28)),
                      Text('Match', style: TextStyle(color: isDark ? AppTheme.textMuted : AppTheme.lightTextSecondary, fontSize: 12)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text('${analysis.matchedSkills} of ${analysis.totalRequired} required skills', style: TextStyle(color: isDark ? AppTheme.textSecondary : AppTheme.lightTextSecondary, fontSize: 13)),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Assessment
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppTheme.secondaryColor.withOpacity(isDark ? 0.15 : 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(Icons.lightbulb_outline, color: AppTheme.secondaryColor, size: 20),
              const SizedBox(width: 10),
              Expanded(child: Text(analysis.overallAssessment, style: TextStyle(color: isDark ? AppTheme.textPrimary : AppTheme.lightTextPrimary, fontSize: 12, height: 1.4))),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Your Strengths
        if (analysis.strengths.isNotEmpty) ...[
          Text('Your Strengths', style: TextStyle(color: isDark ? AppTheme.textPrimary : AppTheme.lightTextPrimary, fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: analysis.strengths.map((skill) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppTheme.successColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle, color: AppTheme.successColor, size: 14),
                  const SizedBox(width: 4),
                  Text(skill, style: TextStyle(color: AppTheme.successColor, fontSize: 11, fontWeight: FontWeight.w500)),
                ],
              ),
            )).toList(),
          ),
          const SizedBox(height: 16),
        ],
        
        // Skills to Learn
        if (analysis.gaps.isNotEmpty) ...[
          Text('Skills to Learn', style: TextStyle(color: isDark ? AppTheme.textPrimary : AppTheme.lightTextPrimary, fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 8),
          ...analysis.gaps.map((gap) => _buildSkillGapCard(gap, isDark)),
        ],
        
        const SizedBox(height: 16),
        
        // Next Steps
        Text('Next Steps', style: TextStyle(color: isDark ? AppTheme.textPrimary : AppTheme.lightTextPrimary, fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 8),
        ...analysis.nextSteps.asMap().entries.map((entry) => Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDark ? AppTheme.surfaceColor : Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Container(
                width: 24, height: 24,
                decoration: BoxDecoration(gradient: AppTheme.primaryGradient, shape: BoxShape.circle),
                alignment: Alignment.center,
                child: Text('${entry.key + 1}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
              ),
              const SizedBox(width: 10),
              Expanded(child: Text(entry.value, style: TextStyle(color: isDark ? AppTheme.textPrimary : AppTheme.lightTextPrimary, fontSize: 12))),
            ],
          ),
        )),
        
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildSkillGapCard(SkillGap gap, bool isDark) {
    Color priorityColor;
    if (gap.priority == 1) {
      priorityColor = AppTheme.errorColor;
    } else if (gap.priority == 2) {
      priorityColor = AppTheme.warningColor;
    } else {
      priorityColor = AppTheme.textMuted;
    }
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.surfaceColor : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border(left: BorderSide(color: priorityColor, width: 3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(gap.skillName, style: TextStyle(color: isDark ? AppTheme.textPrimary : AppTheme.lightTextPrimary, fontWeight: FontWeight.w600, fontSize: 13)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: priorityColor.withOpacity(0.15), borderRadius: BorderRadius.circular(6)),
                child: Text(gap.priorityLabel, style: TextStyle(color: priorityColor, fontSize: 9, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(gap.recommendation, style: TextStyle(color: isDark ? AppTheme.textMuted : AppTheme.lightTextSecondary, fontSize: 11)),
        ],
      ),
    );
  }
}
