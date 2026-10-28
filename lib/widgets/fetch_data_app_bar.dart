import 'package:flutter/material.dart';

class FetchDataAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String userName;
  final String userImage;
  final VoidCallback onProfileTap;
  final VoidCallback onAddTap;
  final VoidCallback onLogoutTap;

  const FetchDataAppBar({
    super.key,
    required this.userName,
    required this.userImage,
    required this.onProfileTap,
    required this.onAddTap,
    required this.onLogoutTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: GestureDetector(
        onTap: onProfileTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.white24,
            backgroundImage: userImage.isNotEmpty ? NetworkImage(userImage) : null,
            child: userImage.isEmpty
                ? Text(
                    userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : null,
          ),
        ),
      ),
      title: GestureDetector(
        onTap: onProfileTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              userName.isNotEmpty ? 'Hi, $userName' : 'Subcollection Data',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const Text(
              'Tap for profile details',
              style: TextStyle(fontSize: 11, color: Colors.white70),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.add_circle_outline),
          tooltip: 'Insert New Task',
          onPressed: onAddTap,
        ),
        IconButton(
          icon: const Icon(Icons.logout),
          tooltip: 'Logout',
          onPressed: onLogoutTap,
        ),
      ],
      backgroundColor: const Color(0xFF131D36),
      foregroundColor: Colors.white,
      centerTitle: false,
    );
  }
}
