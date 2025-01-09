import 'package:flutter/material.dart';
import '../models/BookModel.dart';
import '../services/repositories/book_repo.dart'; // Import the BookRepository
import '../models/ChatUser.dart';
import '../services/repositories/user_repo.dart';
import '../widgets/EditParentWidget.dart';
import '../widgets/FeaturedRowOfUsers.dart';

class ParentHomePage extends StatefulWidget {
  final String parentEmail;

  ParentHomePage({required this.parentEmail});

  @override
  _ParentHomePageState createState() => _ParentHomePageState();
}

class _ParentHomePageState extends State<ParentHomePage> {
  int _selectedIndex = 0;
  final UserRepository _userRepository = UserRepository();
  final BookRepository _bookRepository = BookRepository(); // Initialize BookRepository
  late List<BookModel> _books = []; // List to store fetched books

  // Parent's Information
  String _parentName = "Ahmed Basem";
  String _parentAddress = "Nablus - Rafedia";
  String _parentPhone = "592516238";
  String _parentEmail = "Ahmed@outlook.sa";
  late ChatUser user; // Declare the ChatUser variable

  @override
  void initState() {
    super.initState();
    print(widget.parentEmail);
    _fetchParentData(widget.parentEmail);
    _fetchBooks(); // Fetch books on initialization
  }

  // Fetch all books from the repository
  Future<void> _fetchBooks() async {
    try {
      List<BookModel> books = await _bookRepository.fetchBooks();
      setState(() {
        _books = books; // Update the books list with fetched data
      });
    } catch (e) {
      print('Failed to fetch books: $e');
    }
  }

  // Fetch parent data by email
  Future<void> _fetchParentData(String email) async {
    try {
      user = await _userRepository.findUserByEmail(email);
      setState(() {
        _parentName = user.username;
        _parentAddress = user.location; // Assuming 'location' contains address
        _parentPhone = user.telephone;
        _parentEmail = user.email;
      });
    } catch (e) {
      setState(() {
        _parentName = "Error loading data";
        _parentAddress = "N/A";
        _parentPhone = "N/A";
        _parentEmail = email;
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Parent Dashboard",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF4F3466),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          // First tab: Children's information
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Parent Information Section
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Color(0xFF4F3466),
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: AssetImage("assets/images/main_avatar.png"),
                      ),
                      SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Welcome, $_parentName",
                            style: TextStyle(
                              fontSize: 22,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Track your children's progress",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Title for "Your Children"
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Text(
                    "Your Children",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),

                // Featured Row of Users, passing the user object
                FeaturedRowOfUsers(parent: user),

                // Recent Activities Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Text(
                    "Recent Activities",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Card(
                    elevation: 4,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Color(0xFF4F3466),
                        child: Icon(Icons.school, color: Colors.white),
                      ),
                      title: Text("Completed 'Excel Skills for Business'"),
                      subtitle: Text("John Doe - 2 hours ago"),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Card(
                    elevation: 4,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.orangeAccent,
                        child: Icon(Icons.star, color: Colors.white),
                      ),
                      title: Text("Achieved 'Top Performer' badge"),
                      subtitle: Text("Emily Doe - Yesterday"),
                    ),
                  ),
                ),

                SizedBox(height: 30), // Space between Recent Activities and Feedback Section

                // Feedback Section
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        offset: Offset(0, 4),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Feedback / Message",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 10),

                      // Teacher's Email Field
                      TextField(
                        decoration: InputDecoration(
                          labelText: "Teacher's Email",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.email),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      SizedBox(height: 15),

                      // Message Field
                      TextField(
                        decoration: InputDecoration(
                          labelText: "Your Message",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.message),
                        ),
                        maxLines: 5,
                      ),
                      SizedBox(height: 15),

                      // Send Button
                      ElevatedButton(
                        onPressed: () {
                          // Implement the logic for sending the message (e.g., validation, API call)
                          print("Message Sent");
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF4F3466),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text("Send Message"),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20), // Space at the bottom of the feedback section
              ],
            ),
          ),

          // Second tab: Contact Information
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Parent's Avatar
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage("assets/images/main_avatar.png"),
                ),
                SizedBox(height: 15),

                // Name and Role
                Text(
                  _parentName,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  "Parent of 2 children",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 20),

                // Contact Information
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.location_on, color: Colors.blueGrey),
                            SizedBox(width: 10),
                            Text(
                              _parentAddress,
                              style: TextStyle(fontSize: 16, color: Colors.black87),
                            ),
                          ],
                        ),
                        Divider(),
                        Row(
                          children: [
                            Icon(Icons.phone, color: Colors.green),
                            SizedBox(width: 10),
                            Text(
                              _parentPhone,
                              style: TextStyle(fontSize: 16, color: Colors.black87),
                            ),
                          ],
                        ),
                        Divider(),
                        Row(
                          children: [
                            Icon(Icons.email, color: Colors.red),
                            SizedBox(width: 10),
                            Text(
                              _parentEmail,
                              style: TextStyle(fontSize: 16, color: Colors.black87),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // Edit Button
                ElevatedButton(
                  onPressed: () async {
                    final updatedInfo = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditParent(
                          name: _parentName,
                          address: _parentAddress,
                          phone: _parentPhone,
                          email: _parentEmail,
                        ),
                      ),
                    );

                    if (updatedInfo != null) {
                      setState(() {
                        _parentName = updatedInfo['name'];
                        _parentAddress = updatedInfo['address'];
                        _parentPhone = updatedInfo['phone'];
                        _parentEmail = updatedInfo['email'];
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF4F3466),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text("Edit My Contact Data"),
                ),
              ],
            ),
          ),

          // Third tab: Books Section
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Books for Your Children",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 20),

                  // Check if books are fetched, else show a loading indicator
                  _books.isEmpty
                      ? Center(child: CircularProgressIndicator())
                      : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _books.length,
                    itemBuilder: (context, index) {
                      final book = _books[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20), // Space between books
                        child: _bookBlock(
                          imageUrl: book.imageUrl ?? 'assets/images/default_book.png',
                          title: book.title ?? 'No title available',
                          ageRange: book.ageRange ?? 'N/A',
                          onDownload: () {
                            print('Download ${book.title}');
                            // Implement download functionality
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Children',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contact_page),
            label: 'Contact Info',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Books',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xFF4F3466),
        onTap: _onItemTapped,
      ),
    );
  }

  // Book Block Widget
  Widget _bookBlock({
    required String imageUrl,
    required String title,
    required String ageRange,
    required VoidCallback onDownload,
  }) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 4),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        children: [
          Image.network(
            imageUrl,
            width: 100,
            height: 150,
            fit: BoxFit.cover,
          ),
          SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              Text(
                ageRange,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: onDownload,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF4F3466),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text("Download"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
