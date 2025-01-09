import 'package:flutter/material.dart';
import '../models/MessageModel.dart';

class MessageCard extends StatelessWidget {
  const MessageCard({super.key, required this.message});

  final MessageModel message;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size; // Define mq here

    return message.fromId == "user4" // Replace with actual user logic
        ? _greenMessage(mq)
        : _blueMessage(mq);
  }

  // Message from another user
  Widget _blueMessage(Size mq) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.all(mq.width * 0.04),
            margin: EdgeInsets.symmetric(
                horizontal: mq.width * 0.04, vertical: mq.height * 0.01),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 221, 245, 255),
              border: Border.all(color: Colors.lightBlue),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Text(
              message.msg,
              style: const TextStyle(fontSize: 15, color: Colors.black87),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: mq.width * 0.04),
          child: Text(
            message.sent,
            style: const TextStyle(fontSize: 13, color: Colors.black54),
          ),
        ),
      ],
    );
  }

  // Message from the current user
  Widget _greenMessage(Size mq) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SizedBox(width: mq.width * 0.04),
            const Icon(Icons.done_all_rounded, color: Colors.blue, size: 20),
            const SizedBox(width: 2),
            Text(
              message.read,
              style: const TextStyle(fontSize: 13, color: Colors.black54),
            ),
          ],
        ),
        Flexible(
          child: Container(
            padding: EdgeInsets.all(mq.width * 0.04),
            margin: EdgeInsets.symmetric(
                horizontal: mq.width * 0.04, vertical: mq.height * 0.01),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 218, 255, 176),
              border: Border.all(color: Colors.lightGreen),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
                bottomLeft: Radius.circular(30),
              ),
            ),
            child: Text(
              message.msg,
              style: const TextStyle(fontSize: 15, color: Colors.black87),
            ),
          ),
        ),
      ],
    );
  }
}
