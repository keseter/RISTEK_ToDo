import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:in_a_year/pages/addTask.dart';
import 'package:in_a_year/pages/todoSocial_tile.dart';
import 'package:in_a_year/pages/todoWork_tile.dart';
import 'package:intl/intl.dart';
import 'package:in_a_year/pages/todoLeisure_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Initialize variables
  String profileImagePath = "assets/cropped_image.png";
  String userName = "Edward"; // Profile picture
  String quote = "Loading quote..."; // Initial quote before API fetch
  String author = ""; // Author of the quote
  late Timer _timer; // Timer for periodic updates
  int totalTask = 0; // Completed tasks
  int level = 1;
  int tasksToLevelUp = 5; // Tasks required for next level

  // List of tasks
  List<Map<String, String>> tasks = [
    {"title": "Watch a movie", "dueDate": "2024-03-10"},
    {"title": "Read a book", "dueDate": "2024-03-12"},
    {"title": "Go for a walk", "dueDate": "2024-03-15"},
    {"title": "Go for a walk", "dueDate": "2024-03-15"},
    {"title": "Go for a walk", "dueDate": "2024-03-15"},
    {"title": "Go for a walk", "dueDate": "2024-03-15"},
  ];

  // Runs when the widget is created
  @override
  void initState() {
    super.initState();
    fetchQuote(); // Fetch quote on start
    _timer = Timer.periodic(const Duration(minutes: 2), (timer) {
      fetchQuote(); // Refresh quote every 2 minutes
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Prevent memory leaks
    super.dispose();
  }

  // Retrieve data from API through HTTP request
  Future<void> fetchQuote() async {
    final response =
        await http.get(Uri.parse('https://zenquotes.io/api/random'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        quote = data[0]['q'];
        author = data[0]['a'];
      });
    } else {
      setState(() {
        quote = "Failed to load quote.";
        author = "";
      });
    }
  }

  void completeTask() {
    setState(() {
      totalTask++;
      if (totalTask >= tasksToLevelUp) {
        level++;
        totalTask = 0;
        tasksToLevelUp += 2;
      }
    });
  }

  // Function to delete a task
  void deleteTask(Map<String, String> taskToDelete) {
    setState(() {
      tasks.removeWhere((task) => task == taskToDelete);
    });
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate =
        DateFormat('EEEE, MMMM d, yyyy').format(DateTime.now());
    double progress = totalTask / tasksToLevelUp;

    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        color: Colors.blue.shade900,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.home, color: Colors.white),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.bar_chart, color: Colors.white),
              onPressed: () {},
            ),
            const SizedBox(width: 40),
            IconButton(
              icon: const Icon(Icons.people, color: Colors.white),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.person, color: Colors.white),
              onPressed: () {},
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.greenAccent,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, size: 30, color: Colors.white),
        onPressed: () async {
          final newTask = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTaskPage()),
          );

          if (newTask != null) {
            setState(() {
              tasks.add(newTask);
            });
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // Enable Vertical Scrolling
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(), // Smooth scrolling effect
        child: Column(
          children: [
            // Background Gradient Covering Full Screen
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 30, 117, 231),
                    Color.fromARGB(255, 28, 51, 225),
                    Color.fromARGB(255, 45, 78, 226)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 25),

                  // Display Date at the Top
                  Text(
                    formattedDate,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Profile Picture & Username
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage(profileImagePath),
                        backgroundColor: Colors.transparent,
                      ),
                      const SizedBox(width: 20),
                      Text(
                        "Hello $userName!",
                        style: const TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Quote Display
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      children: [
                        Text(
                          quote,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white70,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "- $author",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white54,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Level Display
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "Level $level",
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // Task Progress
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Tasks: ",
                          style: const TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "$totalTask / $tasksToLevelUp",
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: Colors.greenAccent,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Progress Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.white24,
                        color: Colors.greenAccent,
                        minHeight: 12,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Leisure Task List (Scrollable)
                  LeisureTile(
                    tasks: tasks
                        .where((task) => task["category"] == "Leisure")
                        .toList(),
                    onDelete: deleteTask, // Make sure this is correctly passed
                    onEdit: (oldTask, updatedTask) {
                      setState(() {
                        int originalIndex = tasks.indexWhere((task) =>
                            task["title"] == oldTask["title"] &&
                            task["dueDate"] ==
                                oldTask["dueDate"]); // Find the correct task

                        if (originalIndex != -1) {
                          tasks[originalIndex] =
                              updatedTask; // Replace the task
                        }
                      });
                    },
                  ),

                  SocialTile(
                    tasks: tasks
                        .where((task) => task["category"] == "Social")
                        .toList(),
                    onDelete: deleteTask, // Make sure this is correctly passed
                    onEdit: (oldTask, updatedTask) {
                      setState(() {
                        int originalIndex = tasks.indexWhere((task) =>
                            task["title"] == oldTask["title"] &&
                            task["dueDate"] ==
                                oldTask["dueDate"]); // Find the correct task

                        if (originalIndex != -1) {
                          tasks[originalIndex] =
                              updatedTask; // Replace the task
                        }
                      });
                    },
                  ),

                  WorkTile(
                    tasks: tasks
                        .where((task) => task["category"] == "Work")
                        .toList(),
                    onDelete: deleteTask, // Make sure this is correctly passed
                    onEdit: (oldTask, updatedTask) {
                      setState(() {
                        int originalIndex = tasks.indexWhere((task) =>
                            task["title"] == oldTask["title"] &&
                            task["dueDate"] ==
                                oldTask["dueDate"]); // Find the correct task

                        if (originalIndex != -1) {
                          tasks[originalIndex] =
                              updatedTask; // Replace the task
                        }
                      });
                    },
                  ),

                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
