
import 'package:flutter/material.dart';

class FlashcardTile extends StatelessWidget {
  final String title;
  final String terms;
  final String username;
  final String imageUrl;
  final String avatarUrl;

  const FlashcardTile({
    required this.title,
    required this.terms,
    required this.username,
    required this.imageUrl,
    required this.avatarUrl,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0), // Smaller corner radius
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12.0), // Smaller padding
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Section
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
          const SizedBox(height: 8.0),

          // Text Section
          Text(
            title,
            style: const TextStyle(
              fontSize: 14, // Smaller font size
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4.0),
          Text(
            "$terms terms",
            style: const TextStyle(
              fontSize: 12, // Smaller font size
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 8.0),

          // User Section
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(avatarUrl),
                radius: 10, // Smaller avatar
              ),
              const SizedBox(width: 8.0),
              Text(
                username,
                style: const TextStyle(
                  fontSize: 12, // Smaller font size
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
