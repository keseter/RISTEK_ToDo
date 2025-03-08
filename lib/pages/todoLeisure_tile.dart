import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LeisureTile extends StatelessWidget {
  final List<Map<String, String>> tasks;
  final Function(int) onDelete; // Callback to delete task from HomePage

  const LeisureTile({super.key, required this.tasks, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true, // Prevent infinite height
      physics:
          const NeverScrollableScrollPhysics(), // Sync with HomePage scroll
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        return Dismissible(
          key: Key(tasks[index]["title"]!), // Unique key for each task
          direction: DismissDirection.endToStart, // Swipe left to delete
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            color: Colors.red,
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          onDismissed: (direction) {
            onDelete(index); // Call delete function from HomePage
          },
          child: Container(
            width: double.infinity, // Expands to fill available width
            height: 90, // Keeps a fixed height for better alignment
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: const DecorationImage(
                image: AssetImage("assets/Leisure.jpg"), // Background image
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
                    "Leisure",
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
                  "Due: ${DateFormat('MMMM d, yyyy').format(DateTime.parse(tasks[index]["dueDate"]!))}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 8,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
