import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'editTask.dart';

class WorkTile extends StatelessWidget {
  // Define
  final List<Map<String, String>> tasks;
  final Function(Map<String, String>) onDelete;
  final Function(Map<String, String>, Map<String, String>) onEdit;

  // Required parameter if used by other pages or class
  const WorkTile(
      {super.key,
      required this.tasks,
      required this.onDelete,
      required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true, // Prevent infinite height
      physics:
          const NeverScrollableScrollPhysics(), // Sync with HomePage scroll, overriding
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        return Dismissible(
          // allows to be swiped
          key: Key(tasks[index]["title"]!), // Unique key for each task
          direction: DismissDirection.endToStart, // Swipe left to delete
          background: Container(
            //background of the dismissable
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            color: Colors.red,
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          onDismissed: (direction) {
            final removedTask = tasks[index]; // Store the task before removing
            onDelete(removedTask); // Delete the task in HomePage

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("${removedTask["title"]} deleted"),
                action: SnackBarAction(
                  label: "Undo",
                  onPressed: () {
                    tasks.insert(
                        index, removedTask); // Restore task if undo is pressed
                  },
                ),
              ),
            );
          },

          // Container wrapped inside dismissable
          child: InkWell(
            // provide a tap click effect inkwell
            onTap: () async {
              final updatedTask = await Navigator.push(
                // opens a new screen edittask, the wait ensures that flutter waits for the user to reurn from the EditTaskPage before continue execution
                context,
                MaterialPageRoute(
                  builder: (context) => EditTaskPage(
                    task: tasks[
                        index], // Passes the selected task at a certain index to the edit page
                    onUpdate: (updatedTask) {}, // No update inside EditTaskPage
                  ),
                ),
              );

              if (updatedTask != null) {
                onEdit(tasks[index],
                    updatedTask); // Pass both old and updated task to HomePage, so that the index in the old task could be replaxed by the edited tak
              }
            },
            child: Container(
              width: double.infinity, // Expands to fill available width
              height: 90, // Keeps a fixed height for better alignment
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: const DecorationImage(
                  image: AssetImage("assets/Work.jpg"), // Background image
                  fit: BoxFit.cover,
                ),
              ),
              padding: const EdgeInsets.all(12), // Padding inside the tile
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center, // Center content
                children: [
                  // Category Subtitle
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.black45,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Text(
                      "Work",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),

                  // Task Title
                  Text(
                    tasks[index]["title"]!,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis, // Prevents text overflow
                  ),
                  const SizedBox(height: 5),

                  // Due Date
                  Text(
                    "Due: ${DateFormat('MMMM d, yyyy').format(DateTime.parse(tasks[index]["dueDate"]!))}", // fprmatting
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 8,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
