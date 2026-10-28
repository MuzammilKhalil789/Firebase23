import 'package:flutter/material.dart';

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
    final hasImage = userImage != null && userImage!.isNotEmpty;

    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: Colors.blue.shade100,
            backgroundImage: hasImage ? NetworkImage(userImage!) : null,
            child: !hasImage
                ? Text(
                    userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  )
                : null,
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

class ProfileDetailRow extends StatelessWidget {
  final String label;
  final dynamic value;

  const ProfileDetailRow({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    if (value == null || value.toString().trim().isEmpty) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 95,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.toString(),
              style: const TextStyle(fontSize: 13, color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }
}
