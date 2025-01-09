import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/ChatUser.dart';
import '../../services/repositories/user_repo.dart';

class ProfileScreen extends StatefulWidget {
  final ChatUser user;

  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? _image;
  final _nameController = TextEditingController();
  final _aboutController = TextEditingController();
  final _ageController = TextEditingController();
  final _telephoneController = TextEditingController();
  final _flashcardsCreatedController = TextEditingController();
  final _flashcardsCompletedController = TextEditingController();
  final _studyStreakController = TextEditingController();
  final _roleController = TextEditingController();
  final _favoriteCategoriesController = TextEditingController(); // Added for categories
  final UserRepository userRepository = UserRepository();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.user.username;
    _aboutController.text = widget.user.about;
    _ageController.text = widget.user.age.toString();
    _telephoneController.text = widget.user.telephone;
    _flashcardsCreatedController.text = widget.user.numOfCreatedFlashcards.toString();
    _flashcardsCompletedController.text = widget.user.numOfCompletedFlashcards.toString();
    _studyStreakController.text = widget.user.studyStreak.toString();
    _roleController.text = widget.user.role;
    _favoriteCategoriesController.text = widget.user.favouriteCategories; // Initialize categories
  }

  Future<void> _updateProfile() async {
    try {
      // Concatenate categories into a single string
      String categories = _favoriteCategoriesController.text
          .split(',') // Split by commas
          .map((category) => category.trim()) // Trim any extra spaces
          .join(', '); // Join with commas

      final updatedUser = await userRepository.updateUser(
        widget.user.userId,
        _nameController.text.trim(),
        _aboutController.text.trim(),
        int.parse(_ageController.text.trim()),
        _telephoneController.text.trim(),
        int.parse(_flashcardsCreatedController.text.trim()),
        int.parse(_flashcardsCompletedController.text.trim()),
        int.parse(_studyStreakController.text.trim()),
        _roleController.text.trim(),
        categories, // Pass the concatenated categories string
      );

      setState(() {
        widget.user.username = updatedUser.username;
        widget.user.about = updatedUser.about;
        widget.user.age = updatedUser.age;
        widget.user.telephone = updatedUser.telephone;
        widget.user.numOfCreatedFlashcards = updatedUser.numOfCreatedFlashcards;
        widget.user.numOfCompletedFlashcards = updatedUser.numOfCompletedFlashcards;
        widget.user.studyStreak = updatedUser.studyStreak;
        widget.user.role = updatedUser.role;
        widget.user.favouriteCategories = updatedUser.favouriteCategories; // Update favorite categories
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile update failed!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile Screen')),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: FloatingActionButton.extended(
          backgroundColor: Colors.redAccent,
          onPressed: () async {
            // Add your logout functionality here
          },
          icon: const Icon(Icons.logout),
          label: const Text('Logout'),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: mq.width * .05),
        child: Column(
          children: [
            SizedBox(width: mq.width, height: mq.height * .03),
            Stack(
              children: [
                _image != null
                    ? ClipRRect(
                    borderRadius: BorderRadius.circular(mq.height * .1),
                    child: Image.file(File(_image!),
                        width: mq.height * .2,
                        height: mq.height * .2,
                        fit: BoxFit.cover))
                    : ClipRRect(
                  borderRadius: BorderRadius.circular(mq.height * .1),
                  child: CachedNetworkImage(
                    width: mq.height * .2,
                    height: mq.height * .2,
                    fit: BoxFit.cover,
                    imageUrl: widget.user.image,
                    errorWidget: (context, url, error) =>
                    const CircleAvatar(child: Icon(CupertinoIcons.person)),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: MaterialButton(
                    elevation: 1,
                    onPressed: () {
                      _showBottomSheet();
                    },
                    shape: const CircleBorder(),
                    color: Colors.white,
                    child: const Icon(Icons.edit, color: Colors.blue),
                  ),
                ),
              ],
            ),
            SizedBox(height: mq.height * .03),
            Text(widget.user.email,
                style: const TextStyle(color: Colors.black54, fontSize: 16)),
            SizedBox(height: mq.height * .03),
            // Text Fields for user details
            ..._buildUserDetailsForm(mq),
            SizedBox(height: mq.height * .1), // Increase space before the button
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(),
                minimumSize: Size(mq.width * .5, mq.height * .06),
              ),
              onPressed: _updateProfile,
              icon: const Icon(Icons.edit, size: 28),
              label: const Text('UPDATE', style: TextStyle(fontSize: 16)),
            ),
            SizedBox(height: mq.height * .2),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildUserDetailsForm(Size mq) {
    return [
      TextFormField(
        controller: _nameController,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.person, color: Colors.blue),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          hintText: 'eg. Happy Singh',
          label: const Text('Name'),
          contentPadding: EdgeInsets.symmetric(vertical: mq.height * 0.03), // Increase padding for taller input fields
        ),
      ),
      SizedBox(height: mq.height * .03), // Increase space between fields
      TextFormField(
        controller: _aboutController,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.info_outline, color: Colors.blue),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          hintText: 'eg. Feeling Happy',
          label: const Text('About'),
          contentPadding: EdgeInsets.symmetric(vertical: mq.height * 0.03),
        ),
      ),
      SizedBox(height: mq.height * .03),
      TextFormField(
        controller: _ageController,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.cake, color: Colors.blue),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          hintText: 'eg. 25',
          label: const Text('Age'),
          contentPadding: EdgeInsets.symmetric(vertical: mq.height * 0.03),
        ),
        keyboardType: TextInputType.number,
      ),
      SizedBox(height: mq.height * .03),
      TextFormField(
        controller: _telephoneController,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.phone, color: Colors.blue),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          hintText: 'eg. +1 234 567 890',
          label: const Text('Telephone'),
          contentPadding: EdgeInsets.symmetric(vertical: mq.height * 0.03),
        ),
      ),
      SizedBox(height: mq.height * .03),
      TextFormField(
        controller: _flashcardsCreatedController,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.add_box, color: Colors.blue),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          hintText: 'eg. 10',
          label: const Text('Flashcards Created'),
          contentPadding: EdgeInsets.symmetric(vertical: mq.height * 0.03),
        ),
        keyboardType: TextInputType.number,
        enabled: false,
      ),
      SizedBox(height: mq.height * .03),
      TextFormField(
        controller: _flashcardsCompletedController,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.check_box, color: Colors.blue),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          hintText: 'eg. 8',
          label: const Text('Flashcards Completed'),
          contentPadding: EdgeInsets.symmetric(vertical: mq.height * 0.03),
        ),
        keyboardType: TextInputType.number,
        enabled: false,
      ),
      SizedBox(height: mq.height * .03),
      TextFormField(
        controller: _studyStreakController,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.calendar_today, color: Colors.blue),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          hintText: 'eg. 5',
          label: const Text('Study Streak (days)'),
          contentPadding: EdgeInsets.symmetric(vertical: mq.height * 0.03),
        ),
        keyboardType: TextInputType.number,
        enabled: false,
      ),
      SizedBox(height: mq.height * .03),
      TextFormField(
        controller: _roleController,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.security, color: Colors.blue),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          hintText: 'eg. User',
          label: const Text('Role'),
          contentPadding: EdgeInsets.symmetric(vertical: mq.height * 0.03),
        ),
        enabled: false,
      ),
      SizedBox(height: mq.height * .03),
      TextFormField(
        controller: _favoriteCategoriesController,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.category, color: Colors.blue),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          hintText: 'eg. Science, Math, History',
          label: const Text('Favorite Categories'),
          contentPadding: EdgeInsets.symmetric(vertical: mq.height * 0.03),
        ),
      ),
    ];
  }

  void _showBottomSheet() {
    final mq = MediaQuery.of(context).size;

    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(top: mq.height * .03, bottom: mq.height * .05),
            children: [
              const Text('Pick Profile Picture',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
              SizedBox(height: mq.height * .02),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: const CircleBorder(),
                          fixedSize: Size(mq.width * .3, mq.height * .15)),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                        if (image != null) {
                          setState(() {
                            _image = image.path;
                          });
                          Navigator.pop(context);
                        }
                      },
                      child: Image.asset('images/add_image.png')),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: const CircleBorder(),
                          fixedSize: Size(mq.width * .3, mq.height * .15)),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        final XFile? image = await picker.pickImage(source: ImageSource.camera);
                        if (image != null) {
                          setState(() {
                            _image = image.path;
                          });
                          Navigator.pop(context);
                        }
                      },
                      child: Image.asset('images/camera.png')),
                ],
              )
            ],
          );
        });
  }
}
