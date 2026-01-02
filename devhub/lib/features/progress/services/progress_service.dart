import 'package:flutter/foundation.dart';
import '../models/career_goal.dart';
import '../models/skill_gap.dart';

class ProgressService extends ChangeNotifier {
  String? _currentRole;
  int _yearsExperience = 0;
  List<String> _currentSkills = [];
  String? _selectedGoalId;
  ProgressAnalysis? _analysis;

  // Getters
  String? get currentRole => _currentRole;
  int get yearsExperience => _yearsExperience;
  List<String> get currentSkills => _currentSkills;
  String? get selectedGoalId => _selectedGoalId;
  ProgressAnalysis? get analysis => _analysis;
  CareerGoal? get selectedGoal => _selectedGoalId != null ? CareerGoals.getById(_selectedGoalId!) : null;
  bool get hasAnalysis => _analysis != null;

  // Common skills database for suggestions
  static const List<String> allSkills = [
    'Python', 'JavaScript', 'TypeScript', 'Java', 'C++', 'C#', 'Go', 'Rust', 'Swift', 'Kotlin', 'Dart', 'R', 'PHP', 'Ruby',
    'React', 'Vue.js', 'Angular', 'Next.js', 'Node.js', 'Django', 'Flask', 'Spring Boot', 'Express.js', 'FastAPI',
    'Flutter', 'React Native', 'SwiftUI', 'Jetpack Compose',
    'SQL', 'PostgreSQL', 'MySQL', 'MongoDB', 'Redis', 'Firebase', 'DynamoDB', 'Elasticsearch',
    'Docker', 'Kubernetes', 'AWS', 'GCP', 'Azure', 'Terraform', 'CI/CD', 'Linux', 'Git', 'Bash',
    'TensorFlow', 'PyTorch', 'Scikit-learn', 'Pandas', 'NumPy', 'Keras', 'Machine Learning', 'Deep Learning', 'NLP', 'Computer Vision',
    'REST APIs', 'GraphQL', 'Microservices', 'System Design', 'Data Structures', 'Algorithms',
    'HTML/CSS', 'Figma', 'UI/UX', 'Responsive Design', 'Testing', 'Agile', 'Scrum',
    'Statistics', 'Linear Algebra', 'Mathematics', 'Data Visualization', 'A/B Testing', 'Jupyter',
    'MLOps', 'Transformers', 'Research', 'Publications', 'Monitoring', 'App Store',
  ];

  void setCurrentRole(String role) {
    _currentRole = role;
    notifyListeners();
  }

  void setYearsExperience(int years) {
    _yearsExperience = years;
    notifyListeners();
  }

  void setCurrentSkills(List<String> skills) {
    _currentSkills = skills;
    notifyListeners();
  }

  void addSkill(String skill) {
    if (!_currentSkills.contains(skill)) {
      _currentSkills = [..._currentSkills, skill];
      notifyListeners();
    }
  }

  void removeSkill(String skill) {
    _currentSkills = _currentSkills.where((s) => s != skill).toList();
    notifyListeners();
  }

  void setSelectedGoal(String goalId) {
    _selectedGoalId = goalId;
    notifyListeners();
  }

  void analyzeProgress() {
    if (_selectedGoalId == null) return;
    
    final goal = CareerGoals.getById(_selectedGoalId!);
    if (goal == null) return;

    final requiredSkills = goal.requiredSkills;
    final userSkillsLower = _currentSkills.map((s) => s.toLowerCase()).toSet();
    
    // Find matched skills
    final matched = <String>[];
    final missing = <String>[];
    
    for (final skill in requiredSkills) {
      if (userSkillsLower.contains(skill.toLowerCase())) {
        matched.add(skill);
      } else {
        missing.add(skill);
      }
    }

    // Create skill gaps with priorities
    final gaps = <SkillGap>[];
    for (int i = 0; i < missing.length; i++) {
      final skill = missing[i];
      final priority = i < 3 ? 1 : (i < 6 ? 2 : 3);
      gaps.add(SkillGap(
        skillName: skill,
        hasSkill: false,
        priority: priority,
        recommendation: _getRecommendation(skill),
      ));
    }

    // Calculate percentage
    final percentage = requiredSkills.isEmpty ? 0.0 : (matched.length / requiredSkills.length) * 100;

    // Generate assessment
    String assessment;
    if (percentage >= 80) {
      assessment = 'Excellent! You\'re very close to your goal. Focus on the remaining skills to complete your profile.';
    } else if (percentage >= 60) {
      assessment = 'Good progress! You have a solid foundation. Prioritize the high-priority skills to accelerate your journey.';
    } else if (percentage >= 40) {
      assessment = 'You\'re on the right track! Focus on building core skills first before moving to advanced topics.';
    } else {
      assessment = 'Great starting point! Begin with the fundamentals and work your way up. Consistency is key.';
    }

    // Generate next steps
    final nextSteps = <String>[];
    if (gaps.isNotEmpty) {
      nextSteps.add('Start learning ${gaps.first.skillName} - it\'s your highest priority');
    }
    if (gaps.length > 1) {
      nextSteps.add('Build a project combining ${matched.isNotEmpty ? matched.first : gaps[0].skillName} and ${gaps[1].skillName}');
    }
    if (_yearsExperience < goal.minExperienceYears) {
      nextSteps.add('Gain ${goal.minExperienceYears - _yearsExperience} more year(s) of experience through projects or internships');
    }
    nextSteps.add('Check the Courses tab for learning resources');

    _analysis = ProgressAnalysis(
      matchedSkills: matched.length,
      totalRequired: requiredSkills.length,
      matchPercentage: percentage,
      gaps: gaps,
      strengths: matched,
      overallAssessment: assessment,
      nextSteps: nextSteps,
    );

    notifyListeners();
  }

  String _getRecommendation(String skill) {
    final recommendations = {
      'Python': 'Start with Python basics on Codecademy or freeCodeCamp',
      'JavaScript': 'Learn JavaScript fundamentals on MDN Web Docs',
      'TensorFlow': 'Take the TensorFlow Developer Certificate course',
      'PyTorch': 'Follow the official PyTorch tutorials',
      'React': 'Complete the official React tutorial and build a project',
      'Docker': 'Learn Docker through the official Get Started guide',
      'SQL': 'Practice SQL on LeetCode or SQLZoo',
      'Machine Learning': 'Take Andrew Ng\'s ML course on Coursera',
      'Deep Learning': 'Complete the fast.ai practical deep learning course',
      'AWS': 'Start with AWS Cloud Practitioner certification',
      'Kubernetes': 'Learn Kubernetes basics with Minikube',
      'Flutter': 'Follow the official Flutter codelabs',
      'System Design': 'Study system design on educative.io or Grokking',
    };
    return recommendations[skill] ?? 'Explore online courses and tutorials for $skill';
  }

  void reset() {
    _currentRole = null;
    _yearsExperience = 0;
    _currentSkills = [];
    _selectedGoalId = null;
    _analysis = null;
    notifyListeners();
  }
}
