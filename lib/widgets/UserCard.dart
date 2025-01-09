import 'package:flutter/material.dart';

class UserCard extends StatelessWidget {
  final Color primary;
  final String? imgPath;
  final String userName;
  final int userAge;
  final int numOfCreatedFlashcards;
  final int numOfCompletedFlashcards;
  final int flashcardsCount;
  final int studyStreak;
  final Widget? backWidget;
  final Color chipColor;
  final bool isPrimaryCard;

  const UserCard({
    Key? key,
    this.primary = Colors.redAccent,
    this.imgPath,
    required this.userName,
    required this.userAge,
    required this.numOfCreatedFlashcards,
    required this.numOfCompletedFlashcards,
    required this.flashcardsCount,
    required this.studyStreak,
    this.backWidget,
    this.chipColor = Colors.orange,
    this.isPrimaryCard = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      height: isPrimaryCard ? 220 : 210,
      width: isPrimaryCard ? width * .28 : width * .28,
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 15),
      decoration: BoxDecoration(
        color: primary.withAlpha(200),
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            offset: Offset(0, 5),
            blurRadius: 10,
            color: Colors.purple.withAlpha(20),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        child: Stack(
          children: <Widget>[
            if (backWidget != null) backWidget!,
            Positioned(
              top: 10,
              left: 10,
              right: 10,
              child: _headerRow(context),
            ),
            Positioned(
              bottom: 50,
              left: 10,
              right: 10,
              child: _cardInfo(context),
            ),
            Positioned(
              bottom: 10,
              left: 10,
              right: 10,
              child: _moreInfoButton(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _headerRow(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: Colors.grey.shade300,
          backgroundImage: imgPath != null
              ? AssetImage(imgPath!)
              : const AssetImage("assets/images/main_avatar.png"),
        ),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            userName,
            style: TextStyle(
              fontSize: 16, // Larger font size for the user name
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _cardInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // First Column
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _infoText("Age", "$userAge"),
                _infoText("Created", "$numOfCreatedFlashcards"),
              ],
            ),
            // Second Column
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _infoText("Total", "$flashcardsCount"),
                _infoText("Streak", "$studyStreak days"),
              ],
            ),
          ],
        ),
        SizedBox(height: 10),
        _infoText("Completed", "$numOfCompletedFlashcards"),
      ],
    );
  }

  Widget _infoText(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: TextStyle(
              fontSize: 14, // Larger font size for labels
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14, // Larger font size for values
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _moreInfoButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: chipColor, // Matches the chip color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      onPressed: () {
        // Handle button press, e.g., navigate to another page or show a dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("More info about $userName")),
        );
      },
      child: Text(
        "More Info",
        style: TextStyle(
          color: Colors.white,
          fontSize: 14, // Button text size
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
