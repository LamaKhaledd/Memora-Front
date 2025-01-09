import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:memora/models/ChatUser.dart'; // Import the ChatUser model
import 'package:memora/screens/chat/profile_screen.dart';

import '../../services/repositories/user_repo.dart';
import '../../widgets/chat_user_card.dart';

class ChatHomeScreen extends StatefulWidget {
  const ChatHomeScreen({super.key});

  @override
  State<ChatHomeScreen> createState() => _ChatHomeScreenState();
}

class _ChatHomeScreenState extends State<ChatHomeScreen> {
  late Size mq;
  late Future<List<ChatUser>> users;
  List<ChatUser> list = [];
  // for storing searched items
  final List<ChatUser> _searchList = [];
  // for storing search status
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    users = UserRepository().fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;

    return GestureDetector(
      // for hiding keyboard when a tap is detected on screen
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        // if search is on & back button is pressed then close search
        // or else simple close current screen on back button click
        onWillPop: () {
          if (_isSearching) {
            setState(() {
              _isSearching = !_isSearching;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
          // App bar
          appBar: AppBar(
            leading: const Icon(CupertinoIcons.home),
            title: _isSearching
                ? TextField(
              decoration: const InputDecoration(
                  border: InputBorder.none, hintText: 'Name, Email, ...'),
              autofocus: true,
              style: const TextStyle(fontSize: 17, letterSpacing: 0.5),
              // when search text changes then updated search list
              onChanged: (val) {
                // search logic
                _searchList.clear();

                for (var user in list) {
                  if (user.username.toLowerCase().contains(val.toLowerCase()) ||
                      user.email.toLowerCase().contains(val.toLowerCase())) {
                    _searchList.add(user);
                  }
                }
                setState(() {});
              },
            )
                : const Text('Your Chats'),
            actions: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      _isSearching = !_isSearching;
                    });
                  },
                  icon: Icon(_isSearching
                      ? CupertinoIcons.clear_circled_solid
                      : Icons.search)),
              IconButton(
                  onPressed: () {
                    // Make sure list is populated with the fetched users
                    if (list.isNotEmpty) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ProfileScreen(user: list[0])));
                    }
                  },
                  icon: const Icon(Icons.more_vert)),
            ],
          ),
          // Floating button to add new user
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: FloatingActionButton(
              onPressed: () {},
              child: const Icon(Icons.add_comment_rounded),
            ),
          ),

          // Body
          body: FutureBuilder<List<ChatUser>>(
            future: users,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator()); // Show loading spinner while fetching users
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}')); // Show error if fetching fails
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No users available')); // No users available
              }

              // Update the list with the fetched data
              list = snapshot.data!;

              // Return the list of users in the UI
              return ListView.builder(
                itemCount: _isSearching ? _searchList.length : list.length,
                padding: EdgeInsets.only(top: mq.height * .01),
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  ChatUser user =
                  _isSearching ? _searchList[index] : list[index];
                  return ChatUserCard(user: user); // Pass user to the card
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
