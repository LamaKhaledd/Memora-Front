import 'package:flutter/material.dart';
import '../models/ChatUser.dart';
import 'InfoColumn.dart';
class TopCreatorCard extends StatelessWidget {
  final ChatUser creator;

  const TopCreatorCard({
    Key? key,
    required this.creator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      shadowColor: Colors.black.withOpacity(0.1),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: const Color(0xFF503C74), // Solid purple background
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center, // Center content vertically
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(creator.image),
                backgroundColor: Colors.grey.shade300,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, // Center content vertically within the Column
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      creator.username,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // White text color
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      creator.about ?? "No description",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white70, // Lighter white text for description
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InfoColumn(title: "Age", value: creator.age.toString()),
                        InfoColumn(title: "Flashcards", value: creator.flashcardsCount.toString()),
                        InfoColumn(title: "Streak", value: creator.studyStreak.toString()),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
