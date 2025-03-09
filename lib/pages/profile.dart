import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:intl/intl.dart';

class ProfilePage extends StatefulWidget {
  final String userName;
  final String profileImagePath;
  final String major;
  final String dateOfBirth;
  final String email;
  final Function(String, String, String, String, String) onUpdateProfile;

  const ProfilePage({
    super.key,
    required this.userName,
    required this.profileImagePath,
    required this.major,
    required this.dateOfBirth,
    required this.email,
    required this.onUpdateProfile,
  });

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _majorController;
  late TextEditingController _dobController;
  late TextEditingController _emailController;
  late String _profileImagePath;

  @override
  void initState() {
    super.initState();

    // Retrieve saved data from Hive or set default values
    _nameController = TextEditingController(text: widget.userName);
    _majorController = TextEditingController(text: widget.major);
    _dobController = TextEditingController(text: widget.dateOfBirth);
    _emailController = TextEditingController(text: widget.email);
    _profileImagePath = widget.profileImagePath;
  }

  // Function to select a new profile picture
  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImagePath = pickedFile.path;
      });
    }
  }

  // Function to select a date of birth
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dobController.text = DateFormat('MMMM d, yyyy').format(picked);
      });
    }
  }

  // Function to save the profile data
  void _saveProfile() {
    widget.onUpdateProfile(
      _nameController.text,
      _profileImagePath,
      _majorController.text,
      _dobController.text,
      _emailController.text,
    );

    // Show a confirmation message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profile saved successfully!")),
    );

    // Optionally, navigate back
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: const Text("My Profile"), backgroundColor: Colors.blue),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Picture
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _profileImagePath.isNotEmpty
                    ? FileImage(File(_profileImagePath)) as ImageProvider
                    : const AssetImage("assets/cropped_image.png"),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Icon(Icons.camera_alt,
                      color: Colors.white.withOpacity(0.8)),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Name Input Field
            _buildTextField("Name", _nameController),

            // Major Input Field
            _buildTextField("Major", _majorController),

            // Date of Birth Picker
            GestureDetector(
              onTap: () => _selectDate(context),
              child: AbsorbPointer(
                child: _buildTextField("Date of Birth", _dobController),
              ),
            ),

            // Email Input Field
            _buildTextField("Email", _emailController),

            const SizedBox(height: 30),

            // Save Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                onPressed: _saveProfile,
                child: const Text("Save",
                    style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Reusable Text Field Widget
  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
