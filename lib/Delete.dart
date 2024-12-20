import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'db_helper.dart';

class DeleteScreen extends StatelessWidget {
  final int id;

  const DeleteScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete Confirmation'),
      content: const Text('Are you sure you want to delete this entry?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _deleteHealthData,
          child: const Text('Delete'),
        ),
      ],
    );
  }

  // Delete health data from the database
  Future<void> _deleteHealthData() async {
    await DBHelper().deleteHealthData(id);
    Navigator.pop(context as BuildContext);
  }
}
