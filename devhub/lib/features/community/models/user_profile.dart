class UserProfile {
  final String id;
  final String name;
  final String email;
  final String linkedInId;
  final String? avatarUrl;
  final List<String> skills;
  final String? bio;
  final DateTime createdAt;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.linkedInId,
    this.avatarUrl,
    this.skills = const [],
    this.bio,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'linkedInId': linkedInId,
      'avatarUrl': avatarUrl,
      'skills': skills,
      'bio': bio,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      linkedInId: json['linkedInId'] ?? '',
      avatarUrl: json['avatarUrl'],
      skills: List<String>.from(json['skills'] ?? []),
      bio: json['bio'],
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : DateTime.now(),
    );
  }

  UserProfile copyWith({
    String? id,
    String? name,
    String? email,
    String? linkedInId,
    String? avatarUrl,
    List<String>? skills,
    String? bio,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      linkedInId: linkedInId ?? this.linkedInId,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      skills: skills ?? this.skills,
      bio: bio ?? this.bio,
      createdAt: createdAt,
    );
  }
}
