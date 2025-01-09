
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class QuickNoteWidget extends StatefulWidget {
  @override
  _QuickNoteWidgetState createState() => _QuickNoteWidgetState();
}

class _QuickNoteWidgetState extends State<QuickNoteWidget> {
  final List<String> notes = [];  // List to store added notes
  bool isEditorVisible = true;  // Track which view (Notes or Quick Note editor) is visible
  TextEditingController _controller = TextEditingController();  // Controller for text editing

  // Function to toggle between "Notes" and "Quick Note" views
  void _toggleView() {
    setState(() {
      isEditorVisible = !isEditorVisible;
    });
  }

  // Function to add the note after editing
  void _addNote() {
    setState(() {
      String note = _controller.text;
      if (note.isNotEmpty) {
        notes.add(note);  // Add the new note to the list
        _controller.clear();  // Clear the editor after adding
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row with IconButton for "Notes" and "Quick Note"
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: _toggleView,
                  icon: Icon(Icons.note),
                  tooltip: 'Notes',
                  iconSize: 30,
                  color: Colors.black,
                ),
                IconButton(
                  onPressed: _toggleView,
                  icon: Icon(Icons.edit),
                  tooltip: 'Quick Note',
                  iconSize: 30,
                  color: Colors.black,
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Switch between the editor and the list of notes
            if (isEditorVisible)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Quick Note",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Row for split screen: Image and TextField
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Left half: Image (outside the white box)
                      Container(
                        width: 120,  // Set a fixed width for the image
                        height: 120,  // Set height for the image
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Image.asset(
                          'images/light.png',  // Your image path here
                          fit: BoxFit.cover,  // Ensure the image fills the container
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Right half: TextField for note entry with a defined width
                      Expanded(
                        child: Container(
                          height: 120,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: TextField(
                            controller: _controller,
                            maxLines: null,  // Allow unlimited lines
                            decoration: InputDecoration(
                              hintText: "Type your note here...",
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(10),
                            ),
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _addNote,
                    child: Text("Add Note"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF4F3466),  // Use backgroundColor instead of color
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),

                ],
              ),
            if (!isEditorVisible)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Notes",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Display the added notes as small paper cards
                  for (var note in notes)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Container(
                        padding: EdgeInsets.all(12),
                        margin: EdgeInsets.symmetric(vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.amber[50], // Light paper-like color
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4,
                              offset: Offset(2, 2), // Position of the shadow
                            ),
                          ],
                        ),
                        child: Text(
                          note,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
