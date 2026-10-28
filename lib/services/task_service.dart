import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TaskService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static String get currentUserId => _auth.currentUser?.uid ?? '';
  static String? get currentUserEmail => _auth.currentUser?.email;

  /// Stream of tasks from subcollection: users -> userId -> tasks
  static Stream<QuerySnapshot> getTasksStream(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('tasks')
        .snapshots();
  }

  /// Fetch user profile details from users collection
  static Future<DocumentSnapshot> getUserProfile(String userId) {
    return _firestore.collection('users').doc(userId).get();
  }

  /// Update an existing task in subcollection
  static Future<void> updateTask({
    required String userId,
    required String taskId,
    required String title,
    required String description,
    required String status,
  }) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('tasks')
        .doc(taskId)
        .update({
      'title': title,
      'description': description,
      'status': status,
      'updated_at': FieldValue.serverTimestamp(),
    });
  }

  /// Delete a task from subcollection
  static Future<void> deleteTask({
    required String userId,
    required String taskId,
  }) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('tasks')
        .doc(taskId)
        .delete();
  }

  /// Sign out current user
  static Future<void> signOut() {
    return _auth.signOut();
  }
}
