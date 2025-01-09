import 'package:flutter/material.dart';

import '../Login/login_screen.dart';
import 'Data/flashcards.dart';
import 'Data/InfoCard.dart';
import 'Data/FeatureCard.dart';
import 'Data/flashcardtile.dart';

class CombinedPage extends StatelessWidget {
  const CombinedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        title: Row(
          children: [
            // Logo
            Image.asset(
              'memora.png', // Replace with your logo's path
              height: 150, // Adjust size as needed
            ),
            const SizedBox(width: 20),
            // Navigation Items
            DropdownButton<String>(
              underline: const SizedBox(), // Removes underline
              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black),
              hint: const Text(
                'Study tools',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
              ),
              items: <String>['Option 1', 'Option 2', 'Option 3']
                  .map((String value) => DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              ))
                  .toList(),
              onChanged: (String? value) {
                // Handle dropdown action
              },
            ),
            const SizedBox(width: 24),
            DropdownButton<String>(
              underline: const SizedBox(),
              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black),
              hint: const Text(
                'Subjects',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
              ),
              items: <String>['Option 1', 'Option 2', 'Option 3']
                  .map((String value) => DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              ))
                  .toList(),
              onChanged: (String? value) {
                // Handle dropdown action
              },
            ),
          ],
        ),
        actions: [
          const SizedBox(width: 16),

          // "Create" Button
          TextButton(
            onPressed: () {
              // Handle create button action
            },
            child: const Text(
              '+ Create',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(width: 8),

          // "Log in" Button
          ElevatedButton(
            onPressed: () async {
              // Show a loading indicator dialog
              showDialog(
                context: context,
                barrierDismissible: false, // Prevent closing the dialog by tapping outside
                builder: (BuildContext context) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              );
              // Simulate a delay (e.g., for network request)
              Future.delayed(const Duration(seconds: 2), () {
                // Close the loading dialog
                Navigator.pop(context);

                // Navigate to LoginScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple[50], // Button background color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Log in',
              style: TextStyle(color: Color(0xFF4F3466)),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),

      backgroundColor: Colors.purple[50],
      body: SingleChildScrollView(
        child: Column(
          children: [
// Top Section
            Container(
              padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 16),
              alignment: Alignment.center,
              child: Column(
                children: [
                  const Text(
                    'How do you want to study?',
                    style: TextStyle(
                      fontSize: 30,  // Increased font size
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),  // Increased space
                  const Text(
                    "Master whatever you're learning with Memora's interactive flashcards, practice tests, and study activities.",
                    style: TextStyle(
                      fontSize: 20,  // Increased font size
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),  // Increased space

                  // Image Asset
                  Image.asset(
                    'images/book.png',  // Replace with your image path
                    width: 350,  // Adjust the width as needed
                    height: 250,  // Adjust the height as needed
                    fit: BoxFit.cover,  // Optionally adjust the fit property
                  ),
                  const SizedBox(height: 32),  // Space after the image

                  // Buttons
                  ElevatedButton(
                    onPressed: () {
                      // Handle Sign Up action
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF4F3466), // Button color
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),  // Increased padding
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Sign up for free',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,  // Increased font size
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),  // Increased space
                  GestureDetector(
                    onTap: () {
                      // Handle "I'm a teacher" action
                    },
                    child: const Text(
                      "I'm a teacher",
                      style: TextStyle(
                        fontSize: 15,  // Increased font size
                        color: Color(0xFF4F3466),
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // First Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 100.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left Column
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 40),
                        Container(
                          margin: const EdgeInsets.only(left: 300, bottom: 20),
                          child: const Text(
                            'The easiest way to make and\nstudy flashcards',
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              height: 1.4,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          width: 600,
                          margin: const EdgeInsets.only(left: 300),
                          child: const Text(
                            'A better way to study with flashcards is here. Memora makes it simple to create your own flashcards, study those of a classmate, or search our archive of millions of flashcard decks from other students.',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                              height: 1.6,
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        // InfoCards Column
                        Container(
                          margin: const EdgeInsets.only(left: 300),
                          child: Column(
                            children: [
                              const InfoCard(
                                icon: Icons.image,
                                title: 'Over 1 million',
                                subtitle: 'flashcards created',
                              ),
                              const SizedBox(height: 20),
                              const InfoCard(
                                icon: Icons.check_circle,
                                title: '90% of students',
                                subtitle: 'who use Memora report receiving higher grades',
                              ),
                              const SizedBox(height: 20),
                              const InfoCard(
                                icon: Icons.star,
                                title: 'The most popular',
                                subtitle: 'online learning tool in Palestine',
                              ),
                              const SizedBox(height: 40),
                              ElevatedButton(
                                onPressed: () {
                                  // Action for the button
                                  print('Create a flashcard set button pressed');
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                                  backgroundColor: Colors.blue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  'Create a flashcard set',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Right Column
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: Card(
                        elevation: 10,
                        margin: const EdgeInsets.only(right: 200),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Container(
                          width: 400,  // Increased width from 300 to 400
                          height: 600,
                          decoration: BoxDecoration(
                            color: Colors.orange[50],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.asset(
                              'images/flash.jpg',  // Update with the correct asset path
                              fit: BoxFit.cover,         // Makes the image fill the container
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ),

            // Second Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 100.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Flashcard Image Section
                  Expanded(
                    flex: 2,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 600,
                          height: 600,
                          decoration: BoxDecoration(
                            color: Colors.blue[100],
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        Container(
                          width: 600,  // Set the same width as the blue container
                          height: 600,  // Set the same height as the blue container
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),  // Ensures image matches container's border radius
                            child: Image.asset(
                              'images/flashcards.jpg',  // Replace with your image path
                              width: 600,  // Set the width to match the blue section's width
                              height: 600,  // Set the height to match the blue section's height
                              fit: BoxFit.cover,  // Makes sure the image covers the area without distortion
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 40),

                  // Text and Feature Section
                  Expanded(
                    flex: 3,
                    child: Container(
                      padding: const EdgeInsets.all(20.0),
                      margin: const EdgeInsets.only(right: 100),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Make flashcards',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Creating your own set of flashcards is simple with our free flashcard maker — just add a term and definition. You can even add an image from our library. Once your flashcard set is complete, you can study and share it with friends.',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                              height: 1.6,
                            ),
                          ),
                          const SizedBox(height: 40),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              FeatureCard(
                                icon: Icons.import_export,
                                title: 'Import',
                                subtitle: 'Easily make your notes into flashcards.',
                              ),
                              FeatureCard(
                                icon: Icons.edit,
                                title: 'Customize',
                                subtitle: 'Take existing flashcards and make them your own.',
                              ),
                              FeatureCard(
                                icon: Icons.star,
                                title: 'Star',
                                subtitle: 'Only study the flashcards you want to focus on.',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Third Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 100.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Title Section
                  const Text(
                    "Explore flashcards",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Flashcard Grid Section
                  SizedBox(
                    height: 600, // Set a fixed height to prevent overflow
                    child: GridView.builder(
                      itemCount: flashcards.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3, // Number of columns
                        crossAxisSpacing: 16, // Adjust spacing between cards
                        mainAxisSpacing: 16,
                        childAspectRatio: 4 / 3, // Smaller aspect ratio for smaller cards
                      ),
                      itemBuilder: (context, index) {
                        final flashcard = flashcards[index];
                        return FlashcardTile(
                          title: flashcard['title']!,
                          terms: flashcard['terms']!,
                          username: flashcard['username']!,
                          imageUrl: flashcard['imageUrl']!,
                          avatarUrl: flashcard['avatarUrl']!,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      minimumSize: const Size(200, 50), // Size of the button
                    ),
                    child: const Text(
                      'Search flashcards',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Fourth Section (added as a new section directly)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 100.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Left Image Section
                  Container(
                    width: 500.0,
                    height: 500.0,
                    margin: const EdgeInsets.only(left: 40.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16.0),
                      child: Image.asset(
                        'images/flashcards-menu-header.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  const SizedBox(width: 40.0), // Spacing between sections

                  // Right Text Section
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(right: 40.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Study with our flashcard app",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          const Text(
                            "Take your flashcards anywhere with Memora’s free app. Use swipe mode to review flashcards quickly and make learning more engaging. Swipe right if you know it, swipe left if you don’t — and learn what you need to focus on.",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 24.0),
                          Row(
                            children: [
                              // App Store Button
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  color: Colors.black,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                  vertical: 12.0,
                                ),
                                child: Row(
                                  children: const [
                                    Icon(
                                      Icons.apple,
                                      color: Colors.white,
                                      size: 20.0,
                                    ),
                                    SizedBox(width: 8.0),
                                    Text(
                                      "Download on the App Store",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16.0),
                              // Google Play Button
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  color: Colors.black,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                  vertical: 12.0,
                                ),
                                child: Row(
                                  children: const [
                                    Icon(
                                      Icons.android,
                                      color: Colors.white,
                                      size: 20.0,
                                    ),
                                    SizedBox(width: 8.0),
                                    Text(
                                      "Get it on Google Play",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
