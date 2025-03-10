import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditTaskPage extends StatefulWidget {
  // vairables
  final Map<String, String> task;
  final Function(Map<String, String>) onUpdate;

  // Required vairables if other page is trying to access
  const EditTaskPage({super.key, required this.task, required this.onUpdate});

  @override
  State<EditTaskPage> createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  DateTime? _selectedDate;

  @override
  void initState() {
    // Using the init method, this will be the original data
    super.initState();
    _titleController = TextEditingController(text: widget.task["title"]);
    _descriptionController =
        TextEditingController(text: widget.task["description"]);
    _selectedDate = DateTime.parse(widget.task["dueDate"]!);
  }

  // Select date template method
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _updateTask() {
    // if one of this condition is met then the user must complete the editing
    if (_titleController.text.isEmpty ||
        _selectedDate == null ||
        _descriptionController.text.isEmpty) {
      return;
    }

    // the updated information
    final updatedTask = {
      "title": _titleController.text,
      "dueDate": _selectedDate!.toIso8601String(),
      "category": widget.task["category"]!,
      "description": _descriptionController.text,
    };

    Navigator.pop(context,
        updatedTask); // Ensure the updated task is returned, this is returned to the home page
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Task"),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Title",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: "Enter task title",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              "Description",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: "Enter task description",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              "Due Date",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            InkWell(
              // Effects
              onTap: () => _selectDate(
                  context), // Opens a calender widget for the user to select
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5),
                ),

                // The date is displayed in the text template
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      DateFormat('MMMM d, yyyy').format(_selectedDate!),
                      style: const TextStyle(fontSize: 16),
                    ),
                    const Icon(Icons.calendar_today, color: Colors.purple),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Spacing for the update task button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                ),
                onPressed: _updateTask,
                child: const Text(
                  "Update Task",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
