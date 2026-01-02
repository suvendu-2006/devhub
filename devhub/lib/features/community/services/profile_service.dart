import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_profile.dart';

class ProfileService extends ChangeNotifier {
  final SharedPreferences _prefs;
  UserProfile? _currentProfile;
  List<UserProfile> _friends = [];
  final Random _random = Random();
  
  // Pool of global profiles that rotate on refresh
  final List<Map<String, dynamic>> _profilePool = [
    {'name': 'Andrew Ng', 'linkedInId': 'andrewyng', 'skills': ['Machine Learning', 'Deep Learning'], 'bio': 'Founder DeepLearning.AI • Stanford Professor'},
    {'name': 'Fei-Fei Li', 'linkedInId': 'faboratory', 'skills': ['Computer Vision', 'AI'], 'bio': 'Stanford HAI Co-Director • ImageNet Creator'},
    {'name': 'Andrej Karpathy', 'linkedInId': 'andrejkarpathy', 'skills': ['Deep Learning', 'Tesla AI'], 'bio': 'Former Tesla AI Director • OpenAI'},
    {'name': 'Yann LeCun', 'linkedInId': 'yaboratory', 'skills': ['Deep Learning', 'CNN'], 'bio': 'Meta Chief AI Scientist • Turing Award'},
    {'name': 'Demis Hassabis', 'linkedInId': 'demishassabis', 'skills': ['AI', 'DeepMind'], 'bio': 'CEO Google DeepMind • Nobel Laureate'},
    {'name': 'Ilya Sutskever', 'linkedInId': 'ilyasutskever', 'skills': ['Deep Learning', 'NLP'], 'bio': 'OpenAI Co-founder • Seq2Seq Pioneer'},
    {'name': 'Geoffrey Hinton', 'linkedInId': 'geoffrey-hinton', 'skills': ['Neural Networks', 'AI'], 'bio': 'Godfather of Deep Learning • Turing Award'},
    {'name': 'Yoshua Bengio', 'linkedInId': 'yoshuabengio', 'skills': ['Deep Learning', 'NLP'], 'bio': 'Mila Founder • Turing Award Winner'},
    {'name': 'Sam Altman', 'linkedInId': 'samaltman', 'skills': ['AI', 'Startups'], 'bio': 'CEO OpenAI • Former Y Combinator President'},
    {'name': 'Dario Amodei', 'linkedInId': 'dario-amodei', 'skills': ['AI Safety', 'Research'], 'bio': 'CEO Anthropic • Former OpenAI VP'},
    {'name': 'Satya Nadella', 'linkedInId': 'satyanadella', 'skills': ['AI', 'Cloud', 'Leadership'], 'bio': 'CEO Microsoft • AI Transformation Leader'},
    {'name': 'Sundar Pichai', 'linkedInId': 'sundarpichai', 'skills': ['AI', 'Cloud'], 'bio': 'CEO Google & Alphabet'},
    {'name': 'Jensen Huang', 'linkedInId': 'jenhsunhuang', 'skills': ['AI', 'GPUs', 'Hardware'], 'bio': 'CEO NVIDIA • AI Chip Revolution'},
    {'name': 'Lex Fridman', 'linkedInId': 'lexfridman', 'skills': ['AI', 'Deep Learning', 'Podcasting'], 'bio': 'MIT Researcher • AI Podcast Host'},
  ];

  ProfileService(this._prefs) {
    _loadData();
  }

  UserProfile? get currentProfile => _currentProfile;
  List<UserProfile> get friends => _friends;
  bool get isRegistered => _currentProfile != null;

  void _loadData() {
    final profileJson = _prefs.getString('user_profile');
    if (profileJson != null) {
      _currentProfile = UserProfile.fromJson(jsonDecode(profileJson));
    }
    
    final friendsJson = _prefs.getStringList('friends') ?? [];
    _friends = friendsJson.map((f) => UserProfile.fromJson(jsonDecode(f))).toList();
  }

  Future<void> registerProfile(UserProfile profile) async {
    _currentProfile = profile;
    await _prefs.setString('user_profile', jsonEncode(profile.toJson()));
    notifyListeners();
  }

  Future<void> addFriend(UserProfile friend) async {
    if (!_friends.any((f) => f.id == friend.id || f.linkedInId == friend.linkedInId)) {
      _friends.add(friend);
      await _prefs.setStringList('friends', _friends.map((f) => jsonEncode(f.toJson())).toList());
      notifyListeners();
    }
  }

  Future<void> removeFriend(String id) async {
    _friends.removeWhere((f) => f.id == id);
    await _prefs.setStringList('friends', _friends.map((f) => jsonEncode(f.toJson())).toList());
    notifyListeners();
  }

  List<UserProfile> searchUsers(String query) {
    if (query.isEmpty) return [];
    return getGlobalProfiles().where((u) =>
      u.name.toLowerCase().contains(query.toLowerCase()) ||
      u.skills.any((s) => s.toLowerCase().contains(query.toLowerCase()))
    ).toList();
  }

  // Get randomized global profiles each time
  List<UserProfile> getGlobalProfiles() {
    final shuffled = List<Map<String, dynamic>>.from(_profilePool)..shuffle(_random);
    final selected = shuffled.take(6).toList();
    
    return selected.asMap().entries.map((entry) {
      final data = entry.value;
      return UserProfile(
        id: 'global_${entry.key}_${_random.nextInt(1000)}',
        name: data['name'],
        email: '${data['linkedInId']}@example.com',
        linkedInId: data['linkedInId'],
        skills: List<String>.from(data['skills']),
        bio: data['bio'],
      );
    }).toList();
  }
}
