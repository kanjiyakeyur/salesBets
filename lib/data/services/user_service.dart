import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/sales_bet_user.dart';

class UserService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _usersCollection = 'users';

  // Create or update user in Firestore
  static Future<SalesBetUser> createOrUpdateUser(User firebaseUser) async {
    try {
      final userDoc = _firestore.collection(_usersCollection).doc(firebaseUser.uid);
      final docSnapshot = await userDoc.get();

      SalesBetUser salesBetUser;

      if (docSnapshot.exists) {
        // User exists, update last active time
        salesBetUser = SalesBetUser.fromFirestore(docSnapshot);
        salesBetUser = salesBetUser.copyWith(
          lastActiveAt: DateTime.now(),
          displayName: firebaseUser.displayName ?? salesBetUser.displayName,
          photoUrl: firebaseUser.photoURL ?? salesBetUser.photoUrl,
        );
      } else {
        // New user, create with default values
        salesBetUser = SalesBetUser.fromFirebaseUser(
          uid: firebaseUser.uid,
          email: firebaseUser.email!,
          displayName: firebaseUser.displayName,
          photoUrl: firebaseUser.photoURL,
        );
      }

      await userDoc.set(salesBetUser.toFirestore(), SetOptions(merge: true));
      return salesBetUser;
    } catch (e) {
      throw 'Failed to create/update user profile: $e';
    }
  }

  // Get user by ID
  static Future<SalesBetUser?> getUser(String userId) async {
    try {
      final doc = await _firestore.collection(_usersCollection).doc(userId).get();
      if (doc.exists) {
        return SalesBetUser.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw 'Failed to get user: $e';
    }
  }

  // Update user credits (for betting rewards)
  static Future<void> updateUserCredits(String userId, int newCredits) async {
    try {
      await _firestore.collection(_usersCollection).doc(userId).update({
        'credits': newCredits,
        'lastActiveAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw 'Failed to update user credits: $e';
    }
  }

  // Add credits to user (for wins)
  static Future<void> addCreditsToUser(String userId, int creditsToAdd) async {
    try {
      await _firestore.collection(_usersCollection).doc(userId).update({
        'credits': FieldValue.increment(creditsToAdd),
        'totalWinnings': FieldValue.increment(creditsToAdd),
        'lastActiveAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw 'Failed to add credits: $e';
    }
  }

  // Follow/Unfollow team
  static Future<void> toggleFollowTeam(String userId, String teamId, bool follow) async {
    try {
      if (follow) {
        await _firestore.collection(_usersCollection).doc(userId).update({
          'followedTeams': FieldValue.arrayUnion([teamId]),
          'lastActiveAt': FieldValue.serverTimestamp(),
        });
      } else {
        await _firestore.collection(_usersCollection).doc(userId).update({
          'followedTeams': FieldValue.arrayRemove([teamId]),
          'lastActiveAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      throw 'Failed to update team follow status: $e';
    }
  }

  // Add achievement to user
  static Future<void> addAchievement(String userId, String achievementId) async {
    try {
      await _firestore.collection(_usersCollection).doc(userId).update({
        'achievements': FieldValue.arrayUnion([achievementId]),
        'lastActiveAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw 'Failed to add achievement: $e';
    }
  }

  // Update user profile
  static Future<void> updateUserProfile({
    required String userId,
    String? displayName,
    String? photoUrl,
  }) async {
    try {
      final updateData = <String, dynamic>{
        'lastActiveAt': FieldValue.serverTimestamp(),
      };

      if (displayName != null) {
        updateData['displayName'] = displayName;
      }
      if (photoUrl != null) {
        updateData['photoUrl'] = photoUrl;
      }

      await _firestore.collection(_usersCollection).doc(userId).update(updateData);
    } catch (e) {
      throw 'Failed to update user profile: $e';
    }
  }

  // Get users stream for real-time updates
  static Stream<SalesBetUser?> getUserStream(String userId) {
    return _firestore
        .collection(_usersCollection)
        .doc(userId)
        .snapshots()
        .map((doc) => doc.exists ? SalesBetUser.fromFirestore(doc) : null);
  }

  // Get leaderboard (top users by total winnings)
  static Future<List<SalesBetUser>> getLeaderboard({int limit = 10}) async {
    try {
      final query = await _firestore
          .collection(_usersCollection)
          .orderBy('totalWinnings', descending: true)
          .limit(limit)
          .get();

      return query.docs.map((doc) => SalesBetUser.fromFirestore(doc)).toList();
    } catch (e) {
      throw 'Failed to get leaderboard: $e';
    }
  }

  // Search users by display name or email
  static Future<List<SalesBetUser>> searchUsers(String searchTerm) async {
    try {
      // Note: This is a simple search. For production, consider using
      // Algolia or similar service for better search functionality
      final query = await _firestore
          .collection(_usersCollection)
          .where('displayName', isGreaterThanOrEqualTo: searchTerm)
          .where('displayName', isLessThanOrEqualTo: '$searchTerm\uf8ff')
          .limit(20)
          .get();

      return query.docs.map((doc) => SalesBetUser.fromFirestore(doc)).toList();
    } catch (e) {
      throw 'Failed to search users: $e';
    }
  }

  // Delete user data (for account deletion)
  static Future<void> deleteUser(String userId) async {
    try {
      await _firestore.collection(_usersCollection).doc(userId).delete();
    } catch (e) {
      throw 'Failed to delete user data: $e';
    }
  }
}