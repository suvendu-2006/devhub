import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../models/course.dart';
import '../models/opportunity.dart';
import '../widgets/course_card.dart';
import '../widgets/opportunity_card.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedCategory = 'All';
  bool _isRefreshing = false;
  bool _isLoading = true;
  bool _hasError = false;
  
  final List<String> _categories = ['All', 'DSA', 'Programming', 'ML/AI', 'Web Dev', 'System Design', 'Database'];

  List<Course> _courses = [];
  List<Opportunity> _opportunities = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  void _loadData() {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });
    
    try {
      _courses = [
        // FREE COURSES
        // DSA
        Course(title: 'Data Structures & Algorithms', provider: 'freeCodeCamp', providerLogo: '🔥', description: 'Complete DSA course with practice problems', duration: '20 hours', level: 'Beginner', category: 'DSA', url: 'https://www.freecodecamp.org/learn/javascript-algorithms-and-data-structures/', isFree: true),
        Course(title: 'MIT 6.006: Algorithms', provider: 'MIT OpenCourseWare', providerLogo: '🎓', description: 'Introduction to algorithms from MIT', duration: '14 weeks', level: 'Intermediate', category: 'DSA', url: 'https://ocw.mit.edu/courses/6-006-introduction-to-algorithms-spring-2020/', isFree: true),
        Course(title: 'Competitive Programming', provider: 'Codeforces', providerLogo: '⚡', description: 'Learn competitive programming techniques', duration: 'Self-paced', level: 'Advanced', category: 'DSA', url: 'https://codeforces.com/', isFree: true),
        Course(title: 'LeetCode Patterns', provider: 'NeetCode', providerLogo: '📝', description: 'Master coding interview patterns', duration: '10 hours', level: 'Intermediate', category: 'DSA', url: 'https://neetcode.io/', isFree: true),
        
        // Programming
        Course(title: 'CS50: Introduction to CS', provider: 'Harvard • edX', providerLogo: '🏛️', description: 'Classic intro to computer science', duration: '12 weeks', level: 'Beginner', category: 'Programming', url: 'https://cs50.harvard.edu/x/', isFree: true),
        Course(title: 'Python for Everybody', provider: 'University of Michigan', providerLogo: '🐍', description: 'Learn Python from scratch', duration: '8 weeks', level: 'Beginner', category: 'Programming', url: 'https://www.py4e.com/', isFree: true),
        Course(title: 'Java Programming', provider: 'MOOC.fi', providerLogo: '☕', description: 'Object-oriented programming with Java', duration: '14 weeks', level: 'Beginner', category: 'Programming', url: 'https://java-programming.mooc.fi/', isFree: true),
        
        // ML/AI
        Course(title: 'Deep Learning with Python', provider: 'fast.ai', providerLogo: '🚀', description: 'Practical deep learning for coders', duration: '7 weeks', level: 'Intermediate', category: 'ML/AI', url: 'https://www.fast.ai/', isFree: true),
        Course(title: 'Machine Learning Basics', provider: 'Google', providerLogo: '🔵', description: 'ML crash course from Google', duration: '15 hours', level: 'Beginner', category: 'ML/AI', url: 'https://developers.google.com/machine-learning/crash-course', isFree: true),
        
        // Web Dev
        Course(title: 'Responsive Web Design', provider: 'freeCodeCamp', providerLogo: '🔥', description: 'Learn HTML, CSS, and responsive design', duration: '300 hours', level: 'Beginner', category: 'Web Dev', url: 'https://www.freecodecamp.org/learn/responsive-web-design/', isFree: true),
        Course(title: 'The Odin Project', provider: 'Odin Project', providerLogo: '⚔️', description: 'Full-stack web development curriculum', duration: 'Self-paced', level: 'Beginner', category: 'Web Dev', url: 'https://www.theodinproject.com/', isFree: true),
        Course(title: 'React Tutorial', provider: 'Scrimba', providerLogo: '⚛️', description: 'Interactive React.js course', duration: '12 hours', level: 'Intermediate', category: 'Web Dev', url: 'https://scrimba.com/learn/learnreact', isFree: true),
        
        // System Design
        Course(title: 'System Design Primer', provider: 'GitHub', providerLogo: '🏗️', description: 'Learn how to design large-scale systems', duration: 'Self-paced', level: 'Intermediate', category: 'System Design', url: 'https://github.com/donnemartin/system-design-primer', isFree: true),
        Course(title: 'Design Patterns', provider: 'Refactoring Guru', providerLogo: '🧩', description: 'Software design patterns explained', duration: 'Self-paced', level: 'Intermediate', category: 'System Design', url: 'https://refactoring.guru/design-patterns', isFree: true),
        
        // Database
        Course(title: 'Intro to SQL', provider: 'Khan Academy', providerLogo: '📚', description: 'Learn database querying with SQL', duration: '5 hours', level: 'Beginner', category: 'Database', url: 'https://www.khanacademy.org/computing/computer-programming/sql', isFree: true),
        Course(title: 'MongoDB University', provider: 'MongoDB', providerLogo: '🍃', description: 'NoSQL database fundamentals', duration: '8 weeks', level: 'Beginner', category: 'Database', url: 'https://university.mongodb.com/', isFree: true),
        
        // PREMIUM COURSES
        Course(title: 'Machine Learning Specialization', provider: 'Stanford • Coursera', providerLogo: '🎓', description: 'Learn ML fundamentals from Andrew Ng', duration: '3 months', level: 'Beginner', category: 'ML/AI', url: 'https://www.coursera.org/specializations/machine-learning-introduction', isFree: false),
        Course(title: 'Full Stack Web Development', provider: 'Meta • Coursera', providerLogo: '🌐', description: 'Build modern web applications', duration: '4 months', level: 'Intermediate', category: 'Web Dev', url: 'https://www.coursera.org/professional-certificates/meta-front-end-developer', isFree: false),
        Course(title: 'NLP Specialization', provider: 'DeepLearning.AI', providerLogo: '🧠', description: 'NLP with attention models', duration: '4 weeks', level: 'Advanced', category: 'ML/AI', url: 'https://www.deeplearning.ai/courses/natural-language-processing-specialization/', isFree: false),
        Course(title: 'Grokking System Design', provider: 'Educative', providerLogo: '📐', description: 'Master system design interviews', duration: '20 hours', level: 'Advanced', category: 'System Design', url: 'https://www.educative.io/courses/grokking-the-system-design-interview', isFree: false),
        Course(title: 'Advanced DSA', provider: 'AlgoExpert', providerLogo: '🏆', description: '160+ interview questions explained', duration: 'Self-paced', level: 'Advanced', category: 'DSA', url: 'https://www.algoexpert.io/', isFree: false),
      ];
      
      _opportunities = [
        Opportunity(title: 'ML Engineer Intern', company: 'Google', companyLogo: '🔵', location: 'Mountain View, CA', type: 'Internship', postedDate: '2 days ago', description: 'Work on cutting-edge ML infrastructure', applyUrl: 'https://careers.google.com/', isNew: true),
        Opportunity(title: 'AI Research Scientist', company: 'OpenAI', companyLogo: '🟢', location: 'San Francisco, CA', type: 'Full-time', postedDate: '1 week ago', description: 'Push the boundaries of AI capabilities', applyUrl: 'https://openai.com/careers/', isNew: false),
        Opportunity(title: 'Data Science Fellow', company: 'Microsoft', companyLogo: '🔷', location: 'Remote', type: 'Fellowship', postedDate: '3 days ago', description: 'Join our AI and research division', applyUrl: 'https://careers.microsoft.com/', isNew: true),
        Opportunity(title: 'AI Product Manager', company: 'Anthropic', companyLogo: '🟣', location: 'San Francisco, CA', type: 'Full-time', postedDate: '5 days ago', description: 'Lead AI product development', applyUrl: 'https://www.anthropic.com/careers', isNew: false),
      ];
      
      setState(() {
        _isLoading = false;
        _hasError = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  Future<void> _refresh() async {
    setState(() => _isRefreshing = true);
    await Future.delayed(const Duration(milliseconds: 300));
    if (_tabController.index == 0) {
      _courses.shuffle();
    } else {
      _opportunities.shuffle();
    }
    setState(() => _isRefreshing = false);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Course> get _filteredCourses {
    if (_selectedCategory == 'All') return _courses;
    return _courses.where((c) => c.category == _selectedCategory).toList();
  }

  List<Course> get _freeCourses => _filteredCourses.where((c) => c.isFree).toList();
  List<Course> get _paidCourses => _filteredCourses.where((c) => !c.isFree).toList();

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDarkMode;
    
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
                    child: const Icon(Icons.school_rounded, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Learn & Grow', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: isDark ? AppTheme.textPrimary : AppTheme.lightTextPrimary)),
                      Text('Courses and opportunities', style: TextStyle(color: isDark ? AppTheme.textMuted : AppTheme.lightTextSecondary, fontSize: 11)),
                    ],
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: _isRefreshing ? null : _refresh,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(gradient: AppTheme.primaryGradient, borderRadius: BorderRadius.circular(10)),
                      child: _isRefreshing
                          ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : const Icon(Icons.refresh_rounded, color: Colors.white, size: 18),
                    ),
                  ),
                ],
              ),
            ),
            
            // Tab bar
            Container(
              margin: const EdgeInsets.fromLTRB(20, 4, 20, 8),
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: isDark ? AppTheme.surfaceColor : Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(gradient: AppTheme.primaryGradient, borderRadius: BorderRadius.circular(8)),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: Colors.white,
                unselectedLabelColor: isDark ? AppTheme.textMuted : AppTheme.lightTextSecondary,
                labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                dividerColor: Colors.transparent,
                splashFactory: NoSplash.splashFactory,
                onTap: (_) => setState(() {}),
                tabs: const [
                  Tab(height: 36, child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.menu_book, size: 16), SizedBox(width: 6), Text('Courses')])),
                  Tab(height: 36, child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.work, size: 16), SizedBox(width: 6), Text('Jobs')])),
                ],
              ),
            ),
            
            // Tab content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                physics: const ClampingScrollPhysics(),
                children: [
                  // Courses tab
                  Column(
                    children: [
                      // Category filter
                      SizedBox(
                        height: 34,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          physics: const ClampingScrollPhysics(),
                          itemCount: _categories.length,
                          itemBuilder: (context, index) {
                            final cat = _categories[index];
                            final isSelected = cat == _selectedCategory;
                            return Padding(
                              padding: const EdgeInsets.only(right: 6),
                              child: GestureDetector(
                                onTap: () => setState(() => _selectedCategory = cat),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 14),
                                  decoration: BoxDecoration(
                                    gradient: isSelected ? AppTheme.primaryGradient : null,
                                    color: isSelected ? null : (isDark ? AppTheme.surfaceColor : Colors.white),
                                    borderRadius: BorderRadius.circular(17),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    cat,
                                    style: TextStyle(
                                      color: isSelected ? Colors.white : (isDark ? AppTheme.textSecondary : AppTheme.lightTextSecondary),
                                      fontSize: 12,
                                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Course list with Free/Paid sections
                      Expanded(
                        child: ListView(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          physics: const ClampingScrollPhysics(),
                          children: [
                            // Free Courses Section
                            if (_freeCourses.isNotEmpty) ...[
                              _SectionHeader(
                                title: '🆓 Free Courses',
                                count: _freeCourses.length,
                                isDark: isDark,
                              ),
                              ..._freeCourses.map((course) => CourseCard(course: course)),
                            ],
                            
                            // Premium Courses Section
                            if (_paidCourses.isNotEmpty) ...[
                              const SizedBox(height: 16),
                              _SectionHeader(
                                title: '⭐ Premium Courses',
                                count: _paidCourses.length,
                                isDark: isDark,
                              ),
                              ..._paidCourses.map((course) => CourseCard(course: course)),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  // Opportunities tab
                  ListView.builder(
                    padding: const EdgeInsets.all(20),
                    physics: const ClampingScrollPhysics(),
                    itemCount: _opportunities.length,
                    itemBuilder: (context, index) => OpportunityCard(opportunity: _opportunities[index]),
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

class _SectionHeader extends StatelessWidget {
  final String title;
  final int count;
  final bool isDark;

  const _SectionHeader({
    required this.title,
    required this.count,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? AppTheme.textPrimary : AppTheme.lightTextPrimary,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '$count',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
