import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:in_a_year/pages/addTask.dart';
import 'package:in_a_year/pages/profile.dart';
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

  // Runs when the the widget is created, it runs only once when the screen widget is first created
  // this is where we set up things that should start when the app loads
  @override
  void initState() {
    // using super.initState does not break flutter default behavior so it keeps existing
    super.initState();
    _loadProfileData(); // Load profile data when app starts
    fetchQuote(); // Fetch quote on start
    _timer = Timer.periodic(const Duration(minutes: 2), (timer) {
      fetchQuote(); // Refresh quote every 2 minutes
    });
  }

  // Overriding the built in dispose method both modifying it and extending it, dispose at default runs when the app is closed
  @override
  // this iis important as the time will keep running even if we close the app wasting memory and cpu resourves
  void dispose() {
    _timer.cancel(); // Prevent memory leaks
    super.dispose();
  }

  // Retrive data from API through HTTP library
  // Async, so the app does not freeze and UI is responsive, so flutter run this function in the background.
  Future<void> fetchQuote() async {
    final response =
        await http.get(Uri.parse('https://zenquotes.io/api/random'));

    // == 200 means it recieves successfuly
    if (response.statusCode == 200) {
      final data = jsonDecode(response
          .body); // Extracts the raw JSON string and convert into a dart object
      setState(() {
        // Show in the ui
        quote = data[0]['q']; // Quote text
        author = data[0]['a']; // Author name
      });
    } else {
      setState(() {
        // If no interent
        quote = "Failed to load quote.";
        author = "";
      });
    }
  }

  void _loadProfileData() {
    final profileBox = Hive.box(
        'profileBox'); //  This retrieves the Hive box named 'profileBox, in main

    // setState() ensures that any changes to userName or profileImagePath will immediately reflect in the UI.
    setState(() {
      // Retrieves the Saved User Name: This fetches 'userName' from Hive storage.
      // default Value If 'userName' is not found in Hive, it defaults to 'Your Name'.
      userName = profileBox.get('userName', defaultValue: 'Your Name');
      profileImagePath = profileBox.get('profileImagePath',
          defaultValue: 'assets/cropped_image.png');
    });
  }

  // ranking system Completeing task
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
    // Formatting date
    String formattedDate =
        DateFormat('EEEE, MMMM d, yyyy').format(DateTime.now());

    // Progress bar for every task the user complete stored in a variable
    double progress = totalTask / tasksToLevelUp;

    return Scaffold(
      // Bottom navbar
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

            // Route to about
            IconButton(
              icon: const Icon(Icons.person, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(
                      // pass user date from home to profile page with its required paramters
                      userName: userName,
                      profileImagePath: profileImagePath,
                      major: "Your Major Here",
                      dateOfBirth: "Your Date of Birth Here",
                      email: "your.email@example.com",
                      onUpdateProfile:
                          (newName, newImagePath, newMajor, newDOB, newEmail) {
                        setState(() {
                          userName = newName;
                          profileImagePath = newImagePath;
                        });
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),

      // Add task button
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 15, 26, 235),
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
            // Background Gradient Covering Full Screen with bue theme
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
                      // cut corners and prevent overflowing clipRRect
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        // Progess every task is done
                        value: progress,
                        backgroundColor: Colors.white24,
                        color: Colors.greenAccent,
                        minHeight: 12,
                      ),
                    ),
                  ),

                  // ======== TO DO TILES ======
                  const SizedBox(height: 10),

                  // Leisure Task List
                  LeisureTile(
                    tasks: tasks
                        .where((task) =>
                            task["category"] ==
                            "Leisure") // Filters the list to only include tasks where the "category" is "Leisure".
                        .toList(), //  Converts the filtered tasks into a new list.
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
                    onDelete: deleteTask,
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
                    onDelete: deleteTask,
                    onEdit: (oldTask, updatedTask) {
                      setState(() {
                        int originalIndex = tasks.indexWhere((task) =>
                            task["title"] == oldTask["title"] &&
                            task["dueDate"] ==
                                oldTask["dueDate"]); // Find the correct task

                        if (originalIndex != -1) {
                          tasks[originalIndex] = updatedTask;
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
