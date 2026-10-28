import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../services/task_service.dart';
import 'empty_tasks_view.dart';
import 'task_card.dart';

class TaskListView extends StatelessWidget {
  final String userId;
  final Function(DocumentSnapshot doc) onEdit;
  final Function(String docId) onDelete;
  final VoidCallback onInsertTap;

  const TaskListView({
    super.key,
    required this.userId,
    required this.onEdit,
    required this.onDelete,
    required this.onInsertTap,
  });

  @override
  Widget build(BuildContext context) {
    if (userId.isEmpty) {
      return const Center(child: Text('User not logged in'));
    }

    return StreamBuilder<QuerySnapshot>(
      stream: TaskService.getTasksStream(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return EmptyTasksView(
            onButtonPressed: onInsertTap,
          );
        }

        final docs = snapshot.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.only(
            left: 12,
            right: 12,
            top: 12,
            bottom: 80,
          ),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final doc = docs[index];
            final data = doc.data() as Map<String, dynamic>? ?? {};

            final title = data['title']?.toString() ??
                data['name']?.toString() ??
                'Untitled Task';
            final description = data['description']?.toString() ??
                data['address']?.toString() ??
                '';
            final status = data['status']?.toString() ?? 'pending';
            final docId = data['docId']?.toString() ?? doc.id;
            final timestamp = data['timestamp'];

            return TaskCard(
              title: title,
              description: description,
              status: status,
              docId: docId,
              timestamp: timestamp,
              onEdit: () => onEdit(doc),
              onDelete: () => onDelete(doc.id),
            );
          },
        );
      },
    );
  }
}
