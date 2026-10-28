import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'status_badge.dart';
import 'status_icon.dart';

class TaskCard extends StatelessWidget {
  final String title;
  final String description;
  final String status;
  final String docId;
  final dynamic timestamp;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TaskCard({
    super.key,
    required this.title,
    required this.description,
    required this.status,
    required this.docId,
    this.timestamp,
    required this.onEdit,
    required this.onDelete,
  });

  String _formatTimestamp(dynamic timestamp) {
    if (timestamp == null) return '';
    DateTime? date;
    if (timestamp is Timestamp) {
      date = timestamp.toDate();
    } else if (timestamp is DateTime) {
      date = timestamp;
    }
    if (date != null) {
      final day = date.day.toString().padLeft(2, '0');
      final month = date.month.toString().padLeft(2, '0');
      final year = date.year;
      final hour = date.hour.toString().padLeft(2, '0');
      final minute = date.minute.toString().padLeft(2, '0');
      return '$day/$month/$year $hour:$minute';
    }
    return timestamp.toString();
  }

  @override
  Widget build(BuildContext context) {
    final timestampText = _formatTimestamp(timestamp);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Status Icon + Title & Badge + Edit/Delete Buttons
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StatusIcon(status: status),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      StatusBadge(status: status),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit_outlined, color: Colors.blue, size: 20),
                  tooltip: 'Edit Task',
                  onPressed: onEdit,
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                  tooltip: 'Delete Task',
                  onPressed: onDelete,
                ),
              ],
            ),

            // Description
            if (description.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                description,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade700,
                ),
              ),
            ],

            // Footer: ID and Date
            const SizedBox(height: 8),
            const Divider(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'ID: $docId',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey.shade500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (timestampText.isNotEmpty)
                  Text(
                    timestampText,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey.shade500,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
