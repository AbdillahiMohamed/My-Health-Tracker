import 'package:flutter/material.dart';
import 'db_helper.dart';

class UpdateScreen extends StatefulWidget {
  final int id;
  final String currentTitle;
  final String currentDescription;

  const UpdateScreen({
    super.key,
    required this.id,
    required this.currentTitle,
    required this.currentDescription,
  });

  @override
  _UpdateScreenState createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.currentTitle);
    _descController = TextEditingController(text: widget.currentDescription);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update Health Data')),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter title' : null,
              ),
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter description' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateHealthData,
                child: const Text('Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Update health data in the database
  Future<void> _updateHealthData() async {
    if (_formKey.currentState!.validate()) {
      await DBHelper().updateHealthData(widget.id, {
        'title': _titleController.text,
        'description': _descController.text,
        'date': DateTime.now().toString(),
      });
      Navigator.pop(context);
    }
  }
}
