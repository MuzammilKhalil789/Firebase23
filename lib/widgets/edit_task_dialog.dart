import 'package:flutter/material.dart';
import '../Components/Textfield.dart';

class EditTaskDialog extends StatefulWidget {
  final String initialTitle;
  final String initialDescription;
  final String initialStatus;
  final Future<void> Function(String title, String description, String status) onUpdate;

  const EditTaskDialog({
    super.key,
    required this.initialTitle,
    required this.initialDescription,
    required this.initialStatus,
    required this.onUpdate,
  });

  static Future<void> show(
    BuildContext context, {
    required String initialTitle,
    required String initialDescription,
    required String initialStatus,
    required Future<void> Function(String title, String description, String status) onUpdate,
  }) {
    return showDialog(
      context: context,
      builder: (dialogContext) => EditTaskDialog(
        initialTitle: initialTitle,
        initialDescription: initialDescription,
        initialStatus: initialStatus,
        onUpdate: onUpdate,
      ),
    );
  }

  @override
  State<EditTaskDialog> createState() => _EditTaskDialogState();
}

class _EditTaskDialogState extends State<EditTaskDialog> {
  late final TextEditingController _titleController;
  late final TextEditingController _descController;
  late String _selectedStatus;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle);
    _descController = TextEditingController(text: widget.initialDescription);
    _selectedStatus = widget.initialStatus.isNotEmpty ? widget.initialStatus : 'pending';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _handleUpdate() async {
    setState(() {
      _isSubmitting = true;
    });

    try {
      await widget.onUpdate(
        _titleController.text.trim(),
        _descController.text.trim(),
        _selectedStatus,
      );
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
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
      title: const Center(
        child: Text(
          'Update Subcollection Task',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            CustomTextField(
              controller: _titleController,
              labelText: 'Task Title',
              prefixIcon: Icons.title_rounded,
              textColor: Colors.black87,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _descController,
              maxLines: 3,
              style: const TextStyle(color: Colors.black87, fontSize: 15),
              cursorColor: Colors.black87,
              decoration: InputDecoration(
                labelText: 'Description',
                labelStyle: const TextStyle(color: Colors.black54),
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(bottom: 35.0),
                  child: Icon(Icons.description_outlined, color: Colors.black54),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: Colors.blue, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
            const SizedBox(height: 14),
            DropdownButtonFormField<String>(
              initialValue: _selectedStatus,
              decoration: InputDecoration(
                labelText: 'Status',
                prefixIcon: const Icon(Icons.flag_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              items: const [
                DropdownMenuItem(value: 'pending', child: Text('Pending')),
                DropdownMenuItem(value: 'in-progress', child: Text('In Progress')),
                DropdownMenuItem(value: 'completed', child: Text('Completed')),
              ],
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    _selectedStatus = val;
                  });
                }
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSubmitting ? null : () => Navigator.pop(context),
          child: Container(
            height: 38,
            width: 75,
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text('Cancel', style: TextStyle(color: Colors.white)),
            ),
          ),
        ),
        TextButton(
          onPressed: _isSubmitting ? null : _handleUpdate,
          child: Container(
            height: 38,
            width: 75,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: _isSubmitting
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text('Update', style: TextStyle(color: Colors.white)),
            ),
          ),
        ),
      ],
    );
  }
}
