import 'package:flutter/material.dart';

import 'profile_detail_row.dart';
import 'user_avatar.dart';

class UserProfileDialog extends StatelessWidget {
  final String userName;
  final String userEmail;
  final String? userImage;
  final String currentUserId;
  final Map<String, dynamic> userProfileData;

  const UserProfileDialog({
    super.key,
    required this.userName,
    required this.userEmail,
    this.userImage,
    required this.currentUserId,
    required this.userProfileData,
  });

  static Future<void> show(
    BuildContext context, {
    required String userName,
    required String userEmail,
    String? userImage,
    required String currentUserId,
    required Map<String, dynamic> userProfileData,
  }) {
    return showDialog(
      context: context,
      builder: (dialogContext) => UserProfileDialog(
        userName: userName,
        userEmail: userEmail,
        userImage: userImage,
        currentUserId: currentUserId,
        userProfileData: userProfileData,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Row(
        children: [
          UserAvatar(
            imageUrl: userImage,
            userName: userName,
            radius: 22,
            backgroundColor: Colors.blue.shade100,
            textColor: Colors.blue,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName.isNotEmpty ? userName : 'User Profile',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  userEmail,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(),
            ProfileDetailRow(label: 'Father Name:', value: userProfileData['fname']),
            ProfileDetailRow(label: 'Age:', value: userProfileData['age']),
            ProfileDetailRow(
              label: 'Email:',
              value: userProfileData['email'] ?? userEmail,
            ),
            ProfileDetailRow(label: 'Phone:', value: userProfileData['phone']),
            ProfileDetailRow(label: 'Gender:', value: userProfileData['gender']),
            ProfileDetailRow(label: 'Address:', value: userProfileData['address']),
            ProfileDetailRow(label: 'User ID:', value: currentUserId),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close', style: TextStyle(color: Colors.blue)),
        ),
      ],
    );
  }
}
