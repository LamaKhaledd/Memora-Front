import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../models/ChatUser.dart';
import '../../models/MessageModel.dart';
import '../../services/repositories/message_repo.dart';
import '../../widgets/MessageCard.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;

  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<MessageModel> _list = [];
  final TextEditingController _messageController = TextEditingController();
  final MessageRepository _messageRepository = MessageRepository();

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size; // Define mq here

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: _appBar(mq),
        ),
        backgroundColor: const Color.fromARGB(255, 234, 248, 255),
        body: Column(
          children: [
            Expanded(
              child: FutureBuilder<List<MessageModel>>(
                future: _messageRepository.fetchMessages(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return const Center(child: CircularProgressIndicator());
                    case ConnectionState.done:
                      if (snapshot.hasError) {
                        return Center(
                            child: Text('Error: ${snapshot.error.toString()}'));
                      }
                      if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                        _list.clear();
                        _list.addAll(snapshot.data!);
                        return ListView.builder(
                          itemCount: _list.length,
                          padding: EdgeInsets.only(top: mq.height * 0.01),
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return MessageCard(message: _list[index]);
                          },
                        );
                      } else {
                        return const Center(
                          child: Text(
                            'Say Hii! 👋',
                            style: TextStyle(fontSize: 20),
                          ),
                        );
                      }
                    default:
                      return const SizedBox();
                  }
                },
              ),
            ),
            _chatInput(mq),
          ],
        ),
      ),
    );
  }

  Widget _appBar(Size mq) {
    return InkWell(
      onTap: () {},
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.black54),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(mq.height * 0.03),
            child: CachedNetworkImage(
              width: mq.height * 0.05,
              height: mq.height * 0.05,
              imageUrl: widget.user.image,
              errorWidget: (context, url, error) =>
              const CircleAvatar(child: Icon(CupertinoIcons.person)),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.user.username,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                'Last seen not available',
                style: TextStyle(fontSize: 13, color: Colors.black54),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _chatInput(Size mq) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: mq.height * 0.01, horizontal: mq.width * 0.025),
      child: Row(
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.emoji_emotions,
                        color: Colors.blueAccent, size: 25),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: const InputDecoration(
                        hintText: 'Type Something...',
                        hintStyle: TextStyle(color: Colors.blueAccent),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.image,
                        color: Colors.blueAccent, size: 26),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.camera_alt_rounded,
                        color: Colors.blueAccent, size: 26),
                  ),
                  SizedBox(width: mq.width * 0.02),
                ],
              ),
            ),
          ),
          MaterialButton(
            onPressed: () async {
              if (_messageController.text.trim().isNotEmpty) {
                final newMessage = MessageModel(
                  toId: widget.user.userId,
                  fromId: "currentUserId", // Replace with the actual current user ID
                  msg: _messageController.text.trim(),
                  sent: DateTime.now().toString(),
                  type: Type.TEXT,
                  read: '',
                  messageId: '5',
                );
                try {
                  final sentMessage =
                  await _messageRepository.sendMessage(newMessage);
                  setState(() {
                    _list.add(sentMessage);
                  });
                  _messageController.clear();
                } catch (e) {
                  print('Error sending message: $e');
                }
              }
            },
            minWidth: 0,
            padding: const EdgeInsets.all(10),
            shape: const CircleBorder(),
            color: Colors.green,
            child: const Icon(Icons.send, color: Colors.white, size: 28),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}
