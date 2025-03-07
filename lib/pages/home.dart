import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';

// Ini HTTP to get fetch api from the link we choose in the web
import 'package:http/http.dart' as http;
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
  late Timer
      _timer; // Timer for periodic updates the Late keyword means it will be initialized later in the initState

  // Runs when the the widget is created, it runs only once when the screen widget is first created
  // this is where we set up things that should start when the app loads
  @override
  void initState() {
    // using super.initState does not break flutter default behavior so it keeps existing
    super.initState();
    fetchQuote(); // Fetch initial quote calls the function, before the 2 minute timer start
    _timer = Timer.periodic(const Duration(minutes: 2), (timer) {
      // Repeating timer
      fetchQuote(); // Fetch a new quote every 2 minutes
    });
  }

  // Overriding the built in dispose method both modifying it and extending it, dispose at default runs when the app is closed
  @override
  // this iis important as the time will keep running even if we close the app wasting memory and cpu resourves
  void dispose() {
    _timer.cancel(); // Cancel timer to prevent memory leaks
    super.dispose();
  }

  // Retrive data from API through HTTP library
  // Async, so the app does not freeze and UI is responsive, so flutter run this function in the background.
  Future<void> fetchQuote() async {
    final response = await http.get(Uri.parse(
        'https://zenquotes.io/api/random')); // Get request, await wait unttil the API responds before moving to the next line

    if (response.statusCode == 200) {
      // == 200 means it recieves successfuly
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient Covering Full Screen
          Container(
            width: double.infinity,
            height: double.infinity,
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
          ),

          Column(
            children: [
              const SizedBox(height: 60),

              // Profile Picture & Username
              Row(
                children: [
                  const SizedBox(width: 40),
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

              const SizedBox(height: 20), // Space between username and quote

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

                    // ======== TO DO TILES ======
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20), // Controls outer spacing
                      child: LeisureTile(), // Now it will expand properly
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
