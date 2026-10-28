import 'package:flutter/material.dart';
import 'status_badge.dart';

class StatusIcon extends StatelessWidget {
  final String status;
  final double size;

  const StatusIcon({
    super.key,
    required this.status,
    this.size = 20,
  });

  IconData _getIcon(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Icons.check_circle_rounded;
      case 'in-progress':
        return Icons.hourglass_top_rounded;
      case 'pending':
      default:
        return Icons.access_time_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = getStatusColor(status);
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        shape: BoxShape.circle,
      ),
      child: Icon(
        _getIcon(status),
        color: color,
        size: size,
      ),
    );
  }
}
