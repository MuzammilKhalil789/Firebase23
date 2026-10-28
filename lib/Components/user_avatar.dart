import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final String? imageUrl;
  final String userName;
  final double radius;
  final Color? backgroundColor;
  final Color textColor;
  final VoidCallback? onTap;

  const UserAvatar({
    super.key,
    this.imageUrl,
    required this.userName,
    this.radius = 20,
    this.backgroundColor,
    this.textColor = Colors.white,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage = imageUrl != null && imageUrl!.trim().isNotEmpty;
    final initialLetter =
        userName.trim().isNotEmpty ? userName.trim()[0].toUpperCase() : 'U';

    Widget avatar = CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor ?? Colors.white24,
      backgroundImage: hasImage ? NetworkImage(imageUrl!) : null,
      child: !hasImage
          ? Text(
              initialLetter,
              style: TextStyle(
                color: textColor,
                fontSize: radius * 0.9,
                fontWeight: FontWeight.bold,
              ),
            )
          : null,
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: avatar,
      );
    }
    return avatar;
  }
}
