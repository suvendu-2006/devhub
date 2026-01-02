class CareerGoal {
  final String id;
  final String title;
  final String description;
  final String icon;
  final List<String> requiredSkills;
  final int minExperienceYears;
  final String level; // Entry, Mid, Senior, Lead

  const CareerGoal({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.requiredSkills,
    required this.minExperienceYears,
    required this.level,
  });
}

// Predefined career goals
class CareerGoals {
  static const List<CareerGoal> all = [
    CareerGoal(
      id: 'ml_engineer',
      title: 'Machine Learning Engineer',
      description: 'Build and deploy ML models at scale',
      icon: '🤖',
      requiredSkills: ['Python', 'TensorFlow', 'PyTorch', 'Scikit-learn', 'SQL', 'Docker', 'MLOps', 'Statistics', 'Linear Algebra', 'Deep Learning'],
      minExperienceYears: 2,
      level: 'Mid',
    ),
    CareerGoal(
      id: 'data_scientist',
      title: 'Data Scientist',
      description: 'Extract insights from data using ML and statistics',
      icon: '📊',
      requiredSkills: ['Python', 'R', 'SQL', 'Statistics', 'Machine Learning', 'Data Visualization', 'Pandas', 'NumPy', 'Jupyter', 'A/B Testing'],
      minExperienceYears: 1,
      level: 'Entry',
    ),
    CareerGoal(
      id: 'fullstack_dev',
      title: 'Full Stack Developer',
      description: 'Build complete web applications frontend to backend',
      icon: '🌐',
      requiredSkills: ['JavaScript', 'TypeScript', 'React', 'Node.js', 'SQL', 'Git', 'REST APIs', 'HTML/CSS', 'MongoDB', 'Docker'],
      minExperienceYears: 1,
      level: 'Entry',
    ),
    CareerGoal(
      id: 'frontend_dev',
      title: 'Frontend Developer',
      description: 'Create beautiful and responsive user interfaces',
      icon: '🎨',
      requiredSkills: ['JavaScript', 'TypeScript', 'React', 'Vue.js', 'HTML/CSS', 'Git', 'REST APIs', 'Figma', 'Responsive Design', 'Testing'],
      minExperienceYears: 1,
      level: 'Entry',
    ),
    CareerGoal(
      id: 'backend_dev',
      title: 'Backend Developer',
      description: 'Build scalable server-side applications and APIs',
      icon: '⚙️',
      requiredSkills: ['Python', 'Java', 'Node.js', 'SQL', 'PostgreSQL', 'REST APIs', 'Docker', 'Git', 'Redis', 'System Design'],
      minExperienceYears: 1,
      level: 'Entry',
    ),
    CareerGoal(
      id: 'mobile_dev',
      title: 'Mobile Developer',
      description: 'Build native and cross-platform mobile apps',
      icon: '📱',
      requiredSkills: ['Flutter', 'Dart', 'React Native', 'Swift', 'Kotlin', 'Git', 'REST APIs', 'Firebase', 'UI/UX', 'App Store'],
      minExperienceYears: 1,
      level: 'Entry',
    ),
    CareerGoal(
      id: 'devops_engineer',
      title: 'DevOps Engineer',
      description: 'Automate and optimize development workflows',
      icon: '🔧',
      requiredSkills: ['Docker', 'Kubernetes', 'AWS', 'Linux', 'CI/CD', 'Terraform', 'Git', 'Python', 'Bash', 'Monitoring'],
      minExperienceYears: 2,
      level: 'Mid',
    ),
    CareerGoal(
      id: 'ai_researcher',
      title: 'AI Research Scientist',
      description: 'Push the boundaries of artificial intelligence',
      icon: '🧠',
      requiredSkills: ['Python', 'PyTorch', 'Deep Learning', 'NLP', 'Computer Vision', 'Mathematics', 'Research', 'Publications', 'TensorFlow', 'Transformers'],
      minExperienceYears: 3,
      level: 'Senior',
    ),
  ];

  static CareerGoal? getById(String id) {
    try {
      return all.firstWhere((g) => g.id == id);
    } catch (_) {
      return null;
    }
  }
}
