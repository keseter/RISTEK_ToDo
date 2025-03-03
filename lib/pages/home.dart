import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String profileImagePath = "assets/cropped_image.png";
  String userName = "Edward"; // Profile picture
  String quote = "Loading quote..."; // Initial quote before API fetch
  String author = ""; // Author of the quote
  late Timer _timer; // Timer for periodic updates

  @override
  void initState() {
    super.initState();
    fetchQuote(); // Fetch initial quote
    _timer = Timer.periodic(const Duration(minutes: 2), (timer) {
      fetchQuote(); // Fetch a new quote every 2 minutes
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel timer to prevent memory leaks
    super.dispose();
  }

  Future<void> fetchQuote() async {
    final response =
        await http.get(Uri.parse('https://zenquotes.io/api/random'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        quote = data[0]['q']; // Quote text
        author = data[0]['a']; // Author name
      });
    } else {
      setState(() {
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
