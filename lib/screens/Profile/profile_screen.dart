import 'package:flutter/material.dart';


class GreenProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top Section with a background image and avatar
            Container(
              height: 250,
              width: double.infinity,
              child: Stack(
                children: [
                  // Full background image
                  Positioned.fill(
                    child: Image.asset(
                      'assets/images/about.svg', // Replace with your provided background image
                      fit: BoxFit.cover, // Cover the whole area
                    ),
                  ),
                  // Avatar and Profile Information on top of the image
                  Positioned(
                    top: 60,
                    left: 0,
                    right: 0,


                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 45,
                          child: Image.asset(
                            "assets/avat.jpg",
                          ), // Replace with your avatar
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Ghazal Riaz',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '+88001712346789',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Rounded White Container Below the Avatar using ClipRRect
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),  // Rounded corners at the top
                  topRight: Radius.circular(40),
                ),
                child: Container(
                  color: Colors.white,  // White background color for the container
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        // Account Overview Section with colored icons
                        AccountOption(
                          icon: Icons.person,
                          title: 'My Profile',
                          iconBgColor: Colors.blue.shade100,
                          iconColor: Colors.blue,
                        ),
                        AccountOption(
                          icon: Icons.shopping_bag,
                          title: 'My Orders',
                          iconBgColor: Colors.pink.shade100,
                          iconColor: Colors.pink,
                        ),
                        AccountOption(
                          icon: Icons.money,
                          title: 'Refund',
                          iconBgColor: Colors.green.shade100,
                          iconColor: Colors.green,
                        ),
                        AccountOption(
                          icon: Icons.lock,
                          title: 'Change Password',
                          iconBgColor: Colors.orange.shade100,
                          iconColor: Colors.orange,
                        ),
                        AccountOption(
                          icon: Icons.language,
                          title: 'Change Language',
                          iconBgColor: Colors.purple.shade100,
                          iconColor: Colors.purple,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      // Bottom navigation bar with 'Profile' selected by default
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.green.shade800,
        unselectedItemColor: Colors.grey,
        currentIndex: 3, // 'Profile' is selected
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// Custom widget for account options with colored icons
class AccountOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color iconBgColor;
  final Color iconColor;

  const AccountOption({
    required this.icon,
    required this.title,
    required this.iconBgColor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: iconColor,
            ),
          ),
          const SizedBox(width: 20),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}