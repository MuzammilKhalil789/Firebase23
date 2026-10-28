import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../Components/components.dart';
import '../services/task_service.dart';
import '../widgets/task_list_view.dart';
import 'insert-screen.dart';
import 'login_screen.dart';

class FetchDataScreen extends StatefulWidget {
  const FetchDataScreen({super.key});

  @override
  State<FetchDataScreen> createState() => _FetchDataScreenState();
}

class _FetchDataScreenState extends State<FetchDataScreen> {
  String get currentUserId => TaskService.currentUserId;

  String userName = '';
  String userEmail = '';
  String userImage = '';
  Map<String, dynamic> userProfileData = {};
  bool isProfileLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final userId = currentUserId;
    if (userId.isEmpty) return;

    setState(() => isProfileLoading = true);

    try {
      final doc = await TaskService.getUserProfile(userId);

      if (mounted) {
        setState(() {
          if (doc.exists && doc.data() != null) {
            userProfileData = doc.data()! as Map<String, dynamic>;
            userName = userProfileData['name']?.toString() ?? '';
            userEmail = userProfileData['email']?.toString() ??
                TaskService.currentUserEmail ??
                '';
            userImage = userProfileData['profile_image']?.toString() ?? '';
          } else {
            userEmail = TaskService.currentUserEmail ?? '';
          }
          isProfileLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => isProfileLoading = false);
    }
  }

  void _openProfileDialog() {
    UserProfileDialog.show(
      context,
      userName: userName,
      userEmail: userEmail,
      userImage: userImage,
      currentUserId: currentUserId,
      userProfileData: userProfileData,
    );
  }

  void _openEditTaskDialog(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    final initialTitle = data['title']?.toString() ?? data['name']?.toString() ?? '';
    final initialDesc = data['description']?.toString() ?? data['address']?.toString() ?? '';
    final initialStatus = data['status']?.toString() ?? 'pending';

    EditTaskDialog.show(
      context,
      initialTitle: initialTitle,
      initialDescription: initialDesc,
      initialStatus: initialStatus,
      onUpdate: (title, description, status) async {
        try {
          await TaskService.updateTask(
            userId: currentUserId,
            taskId: doc.id,
            title: title,
            description: description,
            status: status,
          );

          if (mounted) {
            _showSnackBar('Task updated successfully in subcollection', Colors.green);
          }
        } catch (e) {
          if (mounted) {
            _showSnackBar('Error updating task: $e', Colors.redAccent);
          }
        }
      },
    );
  }

  void _openDeleteDialog(String docId) {
    DeleteConfirmationDialog.show(
      context,
      onConfirm: () async {
        try {
          await TaskService.deleteTask(
            userId: currentUserId,
            taskId: docId,
          );

          if (mounted) {
            _showSnackBar('Task deleted successfully from subcollection', Colors.green);
          }
        } catch (e) {
          if (mounted) {
            _showSnackBar('Error deleting task: $e', Colors.redAccent);
          }
        }
      },
    );
  }

  void _navigateToInsertScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const InsertDataScreen()),
    );
  }

  Future<void> _logout() async {
    await TaskService.signOut();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  void _showSnackBar(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: FetchDataAppBar(
        userName: userName,
        userImage: userImage,
        onProfileTap: _openProfileDialog,
        onAddTap: _navigateToInsertScreen,
        onLogoutTap: _logout,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToInsertScreen,
        backgroundColor: const Color(0xFF2563EB),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add Task'),
      ),
      body: TaskListView(
        userId: currentUserId,
        onEdit: _openEditTaskDialog,
        onDelete: _openDeleteDialog,
        onInsertTap: _navigateToInsertScreen,
      ),
    );
  }
}
