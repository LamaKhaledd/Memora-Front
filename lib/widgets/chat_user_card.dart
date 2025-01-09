import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:memora/models/ChatUser.dart';

import '../screens/chat/chat_screen.dart';  // Import the ChatUser model

class ChatUserCard extends StatelessWidget {
  final ChatUser user;

  const ChatUserCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    // Define mq locally to get the screen size
    Size mq = MediaQuery.of(context).size;

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () {
          //for navigating to chat screen
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => ChatScreen(user: user)));
        },
        child: ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(mq.height * .3), // Use mq here
            child: CachedNetworkImage(
              width: mq.height * .055,
              height: mq.height * .055,
              imageUrl: user.image,
              errorWidget: (context, url, error) =>
              const CircleAvatar(child: Icon(CupertinoIcons.person)),
            ),
          ),
          title: Text(user.username),  // Display user's username
          subtitle: Text(user.about, maxLines: 1),  // Display user's about text
          trailing: Container(
            width: 15,
            height: 15,
            decoration: BoxDecoration(
                color: Colors.greenAccent.shade400,
                borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ),
    );
  }
}
