import 'package:flutter/material.dart';
import '../models/ChatUser.dart';
import '../screens/AddChildPage.dart';
import '../services/repositories/parentChild_repo.dart';
import 'UserCard.dart';
import 'dart:async';

class FeaturedRowOfUsers extends StatelessWidget {
  final ChatUser parent; // Adding parent parameter

  const FeaturedRowOfUsers({Key? key, required this.parent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Printing the parent's data
    print('Parent Name: ${parent.username}');
    print('Parent ID: ${parent.userId}');
    print('Parent Age: ${parent.age}'); // Assuming `age` is available in the ChatUser model.
    print('Parent Email: ${parent.email}');
    print('Parent Address: ${parent.location}');

    // Fetching children data using the repository
    final ParentChildRelationshipRepository repository =
    ParentChildRelationshipRepository();
    final Future<List<dynamic>> childrenFuture =
    repository.getAllChildrenByParentId(parent.userId); // Assuming parent has an `id`.

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: FutureBuilder<List<dynamic>>(
        future: childrenFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final childrenList = snapshot.data!;

            return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                for (var child in childrenList)
                  UserCard(
                    primary: Colors.white,
                    chipColor: Colors.orange[200]!,
                    backWidget: _decorationContainerF(
                      Colors.orange[200]!,
                      Colors.orange,
                      50,
                      -30,
                    ),
                    userName: child['username'] ?? 'Unknown', // Assuming the API returns `username`
                    userAge: child['age'] ?? 0, // Assuming the API returns `age`
                    numOfCreatedFlashcards: 60,
                    numOfCompletedFlashcards: 35,
                    flashcardsCount: 60,
                    studyStreak: 10,
                    imgPath: "assets/images/main_avatar.png",
                  ),
                // Add Child Button/Card
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              AddChildPage(parentId: parent.userId),
                        ),
                      );
                    },
                    child: Card(
                      color: Colors.blue[100],
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add, size: 40, color: Colors.blue),
                            SizedBox(height: 8),
                            Text("Add Child",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Center(child: Text('No children found.'));
          }
        },
      ),
    );
  }

  Widget _decorationContainerE(Color primary, double top, double left,
      {Color? secondary}) {
    return Positioned(
      top: top,
      left: left,
      child: CircleAvatar(
        radius: 30,
        backgroundColor: primary,
        child: CircleAvatar(
          radius: 25,
          backgroundColor: secondary,
        ),
      ),
    );
  }

  Widget _decorationContainerF(
      Color primary, Color secondary, double top, double left) {
    return Positioned(
      top: top,
      left: left,
      child: CircleAvatar(
        radius: 30,
        backgroundColor: primary,
        child: CircleAvatar(
          radius: 25,
          backgroundColor: secondary,
        ),
      ),
    );
  }

  Widget _decorationContainerA(Color primary, double top, double left) {
    return Positioned(
      top: top,
      left: left,
      child: CircleAvatar(
        radius: 30,
        backgroundColor: primary,
      ),
    );
  }
}
