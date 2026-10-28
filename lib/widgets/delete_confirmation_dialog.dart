import 'package:flutter/material.dart';

class DeleteConfirmationDialog extends StatefulWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final Color confirmColor;
  final Future<void> Function() onConfirm;

  const DeleteConfirmationDialog({
    super.key,
    this.title = 'Delete Subcollection Item',
    this.message = 'Are you sure you want to delete this task from subcollection?',
    this.confirmText = 'Delete',
    this.cancelText = 'Cancel',
    this.confirmColor = Colors.red,
    required this.onConfirm,
  });

  static Future<void> show(
    BuildContext context, {
    String title = 'Delete Subcollection Item',
    String message = 'Are you sure you want to delete this task from subcollection?',
    String confirmText = 'Delete',
    String cancelText = 'Cancel',
    Color confirmColor = Colors.red,
    required Future<void> Function() onConfirm,
  }) {
    return showDialog(
      context: context,
      builder: (dialogContext) => DeleteConfirmationDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        confirmColor: confirmColor,
        onConfirm: onConfirm,
      ),
    );
  }

  @override
  State<DeleteConfirmationDialog> createState() => _DeleteConfirmationDialogState();
}

class _DeleteConfirmationDialogState extends State<DeleteConfirmationDialog> {
  bool _isLoading = false;

  Future<void> _handleConfirm() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await widget.onConfirm();
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Center(
        child: Text(
          widget.title,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
      ),
      content: Text(
        widget.message,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 14,
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: Container(
            height: 38,
            width: 75,
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                widget.cancelText,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
        TextButton(
          onPressed: _isLoading ? null : _handleConfirm,
          child: Container(
            height: 38,
            width: 75,
            decoration: BoxDecoration(
              color: widget.confirmColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: _isLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      widget.confirmText,
                      style: const TextStyle(color: Colors.white),
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
