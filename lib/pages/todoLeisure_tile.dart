import 'package:flutter/material.dart';

class LeisureTile extends StatelessWidget {
  const LeisureTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // Expands to available space
      height: 120, // Fixed height
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20), // Rounded corners
        image: DecorationImage(
          image: AssetImage("assets/Leisure.jpg"),
          fit: BoxFit.cover, // Ensures the image covers the whole container
        ),
      ),
    );
  }
}
