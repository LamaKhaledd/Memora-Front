import 'dart:convert';
import 'package:flutter/material.dart';
import '../../models/ChatUser.dart'; // Assuming ChatUser is the model for users
import '../../services/repositories/user_repo.dart'; // Your repository for fetching users

class AddChildPage extends StatefulWidget {
  final String parentId;

  const AddChildPage({Key? key, required this.parentId}) : super(key: key);

  @override
  State<AddChildPage> createState() => _AddChildPageState();
}

class _AddChildPageState extends State<AddChildPage> {
  List<ChatUser> _users = [];
  List<ChatUser> _allUsers = []; // To store the full list of users
  List<ChatUser> _selectedUsers = [];
  final TextEditingController _searchController = TextEditingController();
  final UserRepository _userRepository = UserRepository();

  void _submitForm() {
    // Debugging line to check if the function is called
    print("Submit button pressed!");

    // Send the data to the server or handle it as needed.
    print("Selected Users: ${_selectedUsers.map((user) => user.username).join(', ')}");

    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Request Sent'),
        content: Text('Your request has been sent successfully to the admin. Please wait for their acceptance.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
              Navigator.pop(context); // Pop the AddChildPage to go back to the parent screen
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    try {
      final users = await _userRepository.fetchUsers();
      setState(() {
        _users = users;
        _allUsers = users; // Save the full list of users
      });
    } catch (e) {
      print("Error fetching users: $e");
    }
  }

  void _onUserSelected(ChatUser user) {
    setState(() {
      if (_selectedUsers.contains(user)) {
        _selectedUsers.remove(user);
      } else {
        _selectedUsers.add(user);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Child"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20),
            Text("Search for your child by his ID"),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search users...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (query) {
                setState(() {
                  if (query.isEmpty) {
                    _users = _allUsers; // Reset to the full list when search is cleared
                  } else {
                    _users = _allUsers.where((user) {
                      return user.username.toLowerCase().contains(query.toLowerCase());
                    }).toList();
                  }
                });
              },
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _users.length,
                itemBuilder: (context, index) {
                  final user = _users[index];
                  return ListTile(
                    title: Text(user.username),
                    trailing: _selectedUsers.contains(user)
                        ? Icon(Icons.check_circle, color: Colors.green)
                        : Icon(Icons.check_circle_outline),
                    onTap: () => _onUserSelected(user),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Wrap(
              spacing: 8.0,
              children: _selectedUsers.map((user) {
                return Chip(
                  label: Text(user.username),
                  onDeleted: () => _onUserSelected(user),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitForm,
              child: Text("Send Request"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
