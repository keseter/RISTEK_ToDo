import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:hive/hive.dart';

// function of this class is to recieve data, store initiial value, canot update ui
class ProfilePage extends StatefulWidget {
  // Needed variables
  final String userName;
  final String profileImagePath;
  final String major;
  final String dateOfBirth;
  final String email;
  final Function(String, String, String, String, String) onUpdateProfile;

  // Requiired vairalbe needed whhen other pages are trying to access this page
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

// this is where we manage text fields and form of intereactiopns
// Manages ui and logic, set state to modify UI
class _ProfilePageState extends State<ProfilePage> {
  // Controllers for text fields input
  late TextEditingController _nameController;
  late TextEditingController _majorController;
  late TextEditingController _dobController;
  late TextEditingController _emailController;
  late String _profileImagePath;

  @override
  // Retrieves stored user profile date from hive, initiialize and loaded, widget values are the one if no data exist in the Hive
  void initState() {
    super.initState();
    final profileBox = Hive.box('profileBox');

    _nameController = TextEditingController(
        text: profileBox.get('userName', defaultValue: widget.userName));
    _majorController = TextEditingController(
        text: profileBox.get('major', defaultValue: widget.major));
    _dobController = TextEditingController(
        text: profileBox.get('dateOfBirth', defaultValue: widget.dateOfBirth));
    _emailController = TextEditingController(
        text: profileBox.get('email', defaultValue: widget.email));
    _profileImagePath = profileBox.get('profileImagePath',
        defaultValue: widget.profileImagePath);
  }

  // Function to select a new profile picture, template
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
      initialDate: DateTime.now(), // sets defulat date
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
    final profileBox =
        Hive.box('profileBox'); // opens  for the hive storage box

    // save all this to Hive
    profileBox.put('userName', _nameController.text);
    profileBox.put('profileImagePath', _profileImagePath);
    profileBox.put('major', _majorController.text);
    profileBox.put('dateOfBirth', _dobController.text);
    profileBox.put('email', _emailController.text);

    // Passes the latest user input
    widget.onUpdateProfile(
      _nameController.text,
      _profileImagePath,
      _majorController.text,
      _dobController.text,
      _emailController.text,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profile saved successfully!")),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            "My Profile",
            style: TextStyle(
              fontSize: 30,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.blue),
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
                      color:
                          const Color.fromARGB(255, 0, 0, 0).withOpacity(0.8)),
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
