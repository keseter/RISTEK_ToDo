import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  // User text input save in thsi variable
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // Variables, default is leisure
  String _selectedCategory = "Leisure";
  DateTime? _selectedDate;

  // Method to select date template
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _createTask() {
    // this prevents the task tile from being emptu, if one condition is not met
    if (_titleController.text.isEmpty ||
        _selectedDate == null ||
        _descriptionController.text.isEmpty) {
      return;
    }

    final task = {
      // Store in a map
      "title": _titleController.text,
      "dueDate": _selectedDate!.toIso8601String(),
      "category": _selectedCategory,
      "description": _descriptionController.text,
    };

    // pass the data to home screen to be displayeed
    Navigator.pop(context, task);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App bar
      appBar: AppBar(
        title: const Text(
          "Add Task",
          style: const TextStyle(
            fontSize: 30,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 20, 157, 216),
      ),

      // The body
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
              // add effects using inkwell
              onTap: () => _selectDate(context), // opens a calender like dialog
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Display the selected date in a text
                    Text(
                      _selectedDate == null
                          ? "Select Due Date"
                          : DateFormat('MMMM d, yyyy').format(_selectedDate!),
                      style: const TextStyle(fontSize: 16),
                    ),
                    const Icon(Icons.calendar_today, color: Colors.purple),
                  ],
                ),
              ),
            ),

            // Category bar
            const SizedBox(height: 15),
            const Text(
              "Category",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Row of buttons when selected it changes color
                _categoryButton("Leisure"),
                _categoryButton("Social"),
                _categoryButton("Work"),
              ],
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 51, 9, 221),
                ),
                onPressed: _createTask,
                child: const Text(
                  "Create Task",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // create each button
  Widget _categoryButton(String category) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: _selectedCategory == category
            ? const Color.fromARGB(255, 18, 2, 255)
            : Colors.grey.shade300,
      ),
      onPressed: () {
        setState(() {
          _selectedCategory = category; // change the color
        });
      },
      child: Text(
        category,
        style: TextStyle(
          color: _selectedCategory == category ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}
