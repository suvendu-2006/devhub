class SkillGap {
  final String skillName;
  final bool hasSkill;
  final int priority; // 1 = High, 2 = Medium, 3 = Low
  final String recommendation;

  const SkillGap({
    required this.skillName,
    required this.hasSkill,
    required this.priority,
    required this.recommendation,
  });

  String get priorityLabel {
    switch (priority) {
      case 1: return 'High Priority';
      case 2: return 'Medium Priority';
      default: return 'Nice to Have';
    }
  }
}

class ProgressAnalysis {
  final int matchedSkills;
  final int totalRequired;
  final double matchPercentage;
  final List<SkillGap> gaps;
  final List<String> strengths;
  final String overallAssessment;
  final List<String> nextSteps;

  const ProgressAnalysis({
    required this.matchedSkills,
    required this.totalRequired,
    required this.matchPercentage,
    required this.gaps,
    required this.strengths,
    required this.overallAssessment,
    required this.nextSteps,
  });
}
