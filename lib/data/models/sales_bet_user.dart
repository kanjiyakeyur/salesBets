import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SalesBetUser extends Equatable {
  final String id;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final int credits;
  final int totalWinnings;
  final List<String> followedTeams;
  final List<String> achievements;
  final DateTime createdAt;
  final DateTime lastActiveAt;
  final bool isActive;

  const SalesBetUser({
    required this.id,
    required this.email,
    this.displayName,
    this.photoUrl,
    this.credits = 100, // Default starting credits
    this.totalWinnings = 0,
    this.followedTeams = const [],
    this.achievements = const [],
    required this.createdAt,
    required this.lastActiveAt,
    this.isActive = true,
  });

  // Create user from Firebase User
  factory SalesBetUser.fromFirebaseUser({
    required String uid,
    required String email,
    String? displayName,
    String? photoUrl,
  }) {
    final now = DateTime.now();
    return SalesBetUser(
      id: uid,
      email: email,
      displayName: displayName,
      photoUrl: photoUrl,
      createdAt: now,
      lastActiveAt: now,
    );
  }

  // Create user from Firestore document
  factory SalesBetUser.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SalesBetUser(
      id: doc.id,
      email: data['email'] ?? '',
      displayName: data['displayName'],
      photoUrl: data['photoUrl'],
      credits: data['credits'] ?? 100,
      totalWinnings: data['totalWinnings'] ?? 0,
      followedTeams: List<String>.from(data['followedTeams'] ?? []),
      achievements: List<String>.from(data['achievements'] ?? []),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      lastActiveAt: (data['lastActiveAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isActive: data['isActive'] ?? true,
    );
  }

  // Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'credits': credits,
      'totalWinnings': totalWinnings,
      'followedTeams': followedTeams,
      'achievements': achievements,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastActiveAt': Timestamp.fromDate(lastActiveAt),
      'isActive': isActive,
    };
  }

  // Copy with method for updating user data
  SalesBetUser copyWith({
    String? id,
    String? email,
    String? displayName,
    String? photoUrl,
    int? credits,
    int? totalWinnings,
    List<String>? followedTeams,
    List<String>? achievements,
    DateTime? createdAt,
    DateTime? lastActiveAt,
    bool? isActive,
  }) {
    return SalesBetUser(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      credits: credits ?? this.credits,
      totalWinnings: totalWinnings ?? this.totalWinnings,
      followedTeams: followedTeams ?? this.followedTeams,
      achievements: achievements ?? this.achievements,
      createdAt: createdAt ?? this.createdAt,
      lastActiveAt: lastActiveAt ?? this.lastActiveAt,
      isActive: isActive ?? this.isActive,
    );
  }

  // Helper methods
  bool hasFollowedTeam(String teamId) => followedTeams.contains(teamId);

  bool hasAchievement(String achievementId) => achievements.contains(achievementId);

  String get displayNameOrEmail => displayName ?? email.split('@').first;

  @override
  List<Object?> get props => [
        id,
        email,
        displayName,
        photoUrl,
        credits,
        totalWinnings,
        followedTeams,
        achievements,
        createdAt,
        lastActiveAt,
        isActive,
      ];
}