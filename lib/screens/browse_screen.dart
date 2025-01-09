import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';



class FlashcardBrowserApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flashcard Browser',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Color(0xFFF3E5F5), // Light purple background
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF4F3466), // Dark purple color #4f3466
          elevation: 4, // Slight shadow for depth
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: FlashcardBrowserPage(),
    );
  }
}

class FlashcardBrowserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Browse (1 of 2 cards selected)'),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.edit, color: Colors.white)),
          IconButton(onPressed: () {}, icon: Icon(Icons.view_list, color: Colors.white)),
          IconButton(onPressed: () {}, icon: Icon(Icons.card_membership, color: Colors.white)),
          IconButton(onPressed: () {}, icon: Icon(Icons.help_outline, color: Colors.white)),
        ],
      ),
      body: Row(
        children: [
          Sidebar(), // Sidebar with all sections
          Expanded(
            child: Column(
              children: [
                SearchBar(),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(child: CardListView()), // Card List View
                      CardDetailPanel(), // Right-side Editing Panel
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Sidebar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      color: Color(0xFFF5F5F5),
      child: ListView(
        padding: EdgeInsets.all(8),
        children: [
          SidebarSection(
            title: "Saved Searches",
            items: [
              SidebarItem(icon: Icons.today, label: "Today"),
              SidebarItem(icon: Icons.event, label: "Due"),
              SidebarItem(icon: Icons.add, label: "Added"),
              SidebarItem(icon: Icons.edit, label: "Edited"),
              SidebarItem(icon: Icons.visibility, label: "Studied"),
              SidebarItem(icon: Icons.update, label: "First Review"),
              SidebarItem(icon: Icons.refresh, label: "Rescheduled"),
              SidebarItem(icon: Icons.replay, label: "Again"),
              SidebarItem(icon: Icons.alarm, label: "Overdue"),
            ],
          ),
          SidebarSection(
            title: "Flags",
            items: [
              SidebarItem(icon: Icons.flag, label: "No Flag"),
              SidebarItem(icon: Icons.flag, label: "Red", iconColor: Colors.red),
              SidebarItem(icon: Icons.flag, label: "Orange", iconColor: Colors.orange),
              SidebarItem(icon: Icons.flag, label: "Green", iconColor: Colors.green),
              SidebarItem(icon: Icons.flag, label: "Blue", iconColor: Colors.blue),
              SidebarItem(icon: Icons.flag, label: "Pink", iconColor: Colors.pink),
              SidebarItem(icon: Icons.flag, label: "Turquoise", iconColor: Colors.cyan),
              SidebarItem(icon: Icons.flag, label: "Purple", iconColor: Color(0xFF4F3466)),
            ],
          ),
          SidebarSection(
            title: "Card State",
            items: [
              SidebarItem(icon: Icons.circle, label: "New", iconColor: Colors.blue),
              SidebarItem(icon: Icons.circle, label: "Learning", iconColor: Colors.purple),
              SidebarItem(icon: Icons.circle, label: "Review", iconColor: Colors.yellow),
              SidebarItem(icon: Icons.circle, label: "Suspended", iconColor: Colors.green),
              SidebarItem(icon: Icons.circle, label: "Buried", iconColor: Colors.grey),
            ],
          ),
          SidebarSection(
            title: "Decks",
            items: [
              SidebarItem(icon: Icons.folder, label: "Current Deck"),
              SidebarItem(icon: Icons.folder, label: "Default"),
              SidebarItem(icon: Icons.folder, label: "nnmm"),
            ],
          ),
          SidebarSection(
            title: "Note Types",
            items: [
              SidebarItem(icon: Icons.notes, label: "Basic"),
              SidebarItem(icon: Icons.notes, label: "Basic (and reversed card)"),
              SidebarItem(icon: Icons.notes, label: "Basic (optional reversed card)"),
              SidebarItem(icon: Icons.notes, label: "Basic (type in the answer)"),
              SidebarItem(icon: Icons.notes, label: "Cloze"),
              SidebarItem(icon: Icons.notes, label: "Image Occlusion"),
            ],
          ),
          SidebarSection(
            title: "Tags",
            items: [SidebarItem(icon: Icons.label, label: "Untagged")],
          ),
        ],
      ),
    );
  }
}

class SidebarSection extends StatelessWidget {
  final String title;
  final List<SidebarItem> items;

  SidebarSection({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        ...items,
      ],
    );
  }
}

class SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? iconColor;

  SidebarItem({required this.icon, required this.label, this.iconColor});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: iconColor ?? Colors.black),
      title: Text(label),
      dense: true,
      onTap: () {},
    );
  }
}

class SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0), // Sufficient margin around the search bar
      child: TextField(
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search),
          hintText: 'Search cards/notes (type text, then press Enter)',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}

class CardListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(8.0),
      children: [
        DataTable(
          columns: [
            DataColumn(label: Text('Sort Field')),
            DataColumn(label: Text('Card Type')),
            DataColumn(label: Text('Due')),
            DataColumn(label: Text('Deck')),
          ],
          rows: [
            DataRow(cells: [
              DataCell(Text('Card 1')),
              DataCell(Text('Basic')),
              DataCell(Text('2024-11-02')),
              DataCell(Text('nnmm')),
            ]),
            DataRow(cells: [
              DataCell(Text('mmnn')),
              DataCell(Text('Card 1')),
              DataCell(Text('2024-11-02')),
              DataCell(Text('nnmm')),
            ]),
          ],
        ),
      ],
    );
  }
}

class CardDetailPanel extends StatefulWidget {
  @override
  _CardDetailPanelState createState() => _CardDetailPanelState();
}

class _CardDetailPanelState extends State<CardDetailPanel> {
  final TextEditingController _frontController = TextEditingController();
  final TextEditingController _backController = TextEditingController();
  List<String> _history = [];
  int _historyIndex = -1;

  void saveState() {
    if (_historyIndex < _history.length - 1) {
      _history = _history.sublist(0, _historyIndex + 1);
    }
    _history.add(_frontController.text);
    _historyIndex++;
  }


  bool isBold = false;
  bool isItalic = false;
  bool isUnderline = false;
  bool isStrikethrough = false;
  Color textColor = Colors.black;
  Color backgroundColor = Colors.transparent;

  TextStyle getTextStyle() {
    return TextStyle(
      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
      fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
      decoration: (isUnderline ? TextDecoration.underline : TextDecoration.none),
      color: textColor,
      backgroundColor: backgroundColor,
    );
  }

  void toggleBold() => setState(() => isBold = !isBold);
  void toggleItalic() => setState(() => isItalic = !isItalic);
  void toggleUnderline() => setState(() => isUnderline = !isUnderline);
  void toggleStrikethrough() => setState(() => isStrikethrough = !isStrikethrough);

  void changeTextColor() {
    // Set up a dialog to pick color (simple color picker or preset colors).
    // This is a placeholder:
    setState(() => textColor = Colors.blue);
  }

  void changeBackgroundColor() {
    // Similar to textColor; choose a background color.
    setState(() => backgroundColor = Colors.yellow.withOpacity(0.2));
  }

  void insertSuperscript() {
    _frontController.text += 'ᴺᵒ';
  }

  void insertSubscript() {
    _frontController.text += 'ₙₒ';
  }

  void alignTextLeft() {
    // TextField is already left-aligned
  }

  void addBulletList() {
    _frontController.text = "• " + _frontController.text.replaceAll("\n", "\n• ");
  }

  void addNumberedList() {
    final lines = _frontController.text.split('\n');
    _frontController.text = lines
        .asMap()
        .entries
        .map((entry) => "${entry.key + 1}. ${entry.value}")
        .join("\n");
  }

  void increaseIndent() {
    _frontController.text = "    " + _frontController.text.replaceAll("\n", "\n    ");
  }


  void undo() {
    if (_historyIndex > 0) {
      _historyIndex--;
      _frontController.text = _history[_historyIndex];
    }
  }

  void redo() {
    if (_historyIndex < _history.length - 1) {
      _historyIndex++;
      _frontController.text = _history[_historyIndex];
    }
  }


  void attachFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);
      print('Attached file: ${file.path}');
    }
  }

  void insertPhoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      print('Inserted photo: ${imageFile.path}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 700,
      color: Color(0xFFF5F5F5),
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Toolbar with formatting icons
          Row(
            children: [
              IconButton(icon: Icon(Icons.format_bold), onPressed: toggleBold),
              IconButton(icon: Icon(Icons.format_italic), onPressed: toggleItalic),
              IconButton(icon: Icon(Icons.format_underline), onPressed: toggleUnderline),
              IconButton(icon: Icon(Icons.strikethrough_s), onPressed: toggleStrikethrough),
              IconButton(icon: Icon(Icons.format_color_text), onPressed: changeTextColor),
              IconButton(icon: Icon(Icons.format_color_fill), onPressed: changeBackgroundColor),
              IconButton(icon: Icon(Icons.superscript), onPressed: insertSuperscript),
              IconButton(icon: Icon(Icons.subscript), onPressed: insertSubscript),
              IconButton(icon: Icon(Icons.format_align_left), onPressed: alignTextLeft),
              IconButton(icon: Icon(Icons.format_list_bulleted), onPressed: addBulletList),
              IconButton(icon: Icon(Icons.format_list_numbered), onPressed: addNumberedList),
              IconButton(icon: Icon(Icons.format_indent_increase), onPressed: increaseIndent),
              IconButton(icon: Icon(Icons.undo), onPressed: undo),
              IconButton(icon: Icon(Icons.redo), onPressed: redo),
              IconButton(icon: Icon(Icons.attach_file), onPressed: attachFile),
              IconButton(icon: Icon(Icons.insert_photo), onPressed: insertPhoto),
            ],
          ),
          Divider(),
          Text("Front"),
          SizedBox(height: 4),
          TextField(
            controller: _frontController,
            style: getTextStyle(),
            maxLines: 5,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Front content',
            ),
          ),
          SizedBox(height: 16),
          Text("Back"),
          SizedBox(height: 4),
          TextField(
            controller: _backController,
            style: getTextStyle(),
            maxLines: 5,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Back content',
            ),
          ),
        ],
      ),
    );
  }
}