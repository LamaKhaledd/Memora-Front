import 'dart:convert';
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:intl/intl.dart';
import 'package:memora/models/FlashcardModel.dart';
import 'package:memora/widgets/Flashcard.dart';
import 'package:memora/widgets/FlashcardForm.dart';

class FlashcardPreview extends StatefulWidget {
  final FlashcardModel flashcard;
  final void Function(FlashcardModel flashcard) onDelete;

  const FlashcardPreview({
    required this.flashcard,
    required this.onDelete,
    super.key,
  });

  @override
  State<FlashcardPreview> createState() => _FlashcardPreviewState();
}

class _FlashcardPreviewState extends State<FlashcardPreview> {
  FlashcardModel? flashcard;
  bool showEditOptions = false;
  QuillController _questionController = QuillController.basic();

  @override
  void initState() {
    super.initState();
    flashcard = widget.flashcard;

    final questionJson = flashcard?.question != null &&
        flashcard!.question!.isNotEmpty
        ? jsonDecode(flashcard!.question!)
        : [
      {"insert": ""}
    ];

    final questionDoc = Document.fromJson(questionJson is List ? questionJson : []);
    _questionController = QuillController(
      document: questionDoc,
      selection: TextSelection.collapsed(offset: 0),
    );
  }

  Future<void> deleteFlashcard(FlashcardModel flashcard) async {
    try {
      widget.onDelete(flashcard); // Call the callback to update the parent state
    } catch (error) {
      print("Error deleting flashcard");
    }
  }


  Future<void> _downloadFlashcard(FlashcardModel flashcard) async {
    try {
      // Convert the flashcard to JSON
      final jsonData = flashcard.toJson();
      final jsonString = jsonEncode(jsonData);

      // Show a dialog to ask for the filename
      final fileName = await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          String tempFileName = flashcard.id ?? 'flashcard';
          return AlertDialog(
            title: const Text('Enter File Name'),
            content: TextField(
              onChanged: (value) {
                tempFileName = value;
              },
              decoration: const InputDecoration(
                labelText: 'File Name',
                hintText: 'Enter the name for the file',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, null), // Cancel
                child: const Text('Cancel'),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF503464), // Hex color #503464
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, tempFileName), // Confirm
                child: const Text('Save'),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF503464), // Hex color #503464
                ),
              ),
            ],
          );
        },
      );

      // Exit if no filename was provided
      if (fileName == null || fileName.isEmpty) {
        print('File download canceled');
        return;
      }

      // Create a Blob for the JSON string
      final blob = html.Blob([jsonString], 'application/json');
      final url = html.Url.createObjectUrlFromBlob(blob);

      // Create an anchor element to trigger the download
      final anchor = html.AnchorElement()
        ..href = url
        ..download = '$fileName.wewe' // Use custom extension
        ..style.display = 'none';

      // Add the anchor to the document and trigger a click
      html.document.body?.append(anchor);
      anchor.click();

      // Clean up
      anchor.remove();
      html.Url.revokeObjectUrl(url);

      print("Flashcard downloaded successfully as $fileName.wewe");
    } catch (error) {
      print("Error downloading flashcard: $error");
    }
  }

  void _shareFlashcard(FlashcardModel flashcard) {
    // Logic to share flashcard
    print("Share Flashcard: ${flashcard.id}");
  }

  Future<void> showDeleteFlashcardDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).dialogTheme.backgroundColor,
          title: Icon(Icons.warning_amber_rounded, color: Colors.red[600], size: 50),
          content: const Text(
            "Do you really want to delete this flashcard?",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Yes', style: TextStyle(fontSize: 16)),
              onPressed: () async {
                await deleteFlashcard(flashcard!);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('No', style: TextStyle(fontSize: 16)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onLongPress: () {
        setState(() {
          showEditOptions = !showEditOptions;
        });
      },
      onTap: () {
        if (!showEditOptions) {
          showDialog<void>(
            context: context,
            builder: (BuildContext context) {
              return Flashcard(flashcard: flashcard);
            },
          );
        }
      },
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).floatingActionButtonTheme.backgroundColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 80,
                      child: QuillEditor.basic(
                        configurations: QuillEditorConfigurations(
                          controller: _questionController,
                          checkBoxReadOnly: true,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Next Review Date: ${flashcard?.nextReviewDate != null ? DateFormat('yyyy-MM-dd HH:mm').format(flashcard!.nextReviewDate!) : 'N/A'}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: PopupMenuButton<String>(
              onSelected: (String value) {
                if (value == 'download') {
                  _downloadFlashcard(flashcard!);
                } else if (value == 'share') {
                  _shareFlashcard(flashcard!);
                }
              },
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem(
                    value: 'download',
                    child: Row(
                      children: const [
                        Icon(Icons.download, color: Colors.blue),
                        SizedBox(width: 8),
                        Text('Download'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'share',
                    child: Row(
                      children: const [
                        Icon(Icons.share, color: Colors.green),
                        SizedBox(width: 8),
                        Text('Share'),
                      ],
                    ),
                  ),
                ];
              },
            ),
          ),
          if (showEditOptions)
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  color: Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.5),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () async {
                            final flashcardObject = await showDialog<FlashcardModel>(
                              context: context,
                              builder: (BuildContext context) {
                                return FlashcardForm(flashcard: flashcard);
                              },
                            );
                            if (flashcardObject != null) {
                              setState(() {
                                flashcard = flashcardObject;
                                showEditOptions = false;
                              });
                            }
                          },
                          icon: const Icon(Icons.edit, color: Colors.blue, size: 40),
                        ),
                        const SizedBox(width: 10),
                        IconButton(
                          onPressed: () async {
                            await showDeleteFlashcardDialog(context);
                            setState(() {
                              showEditOptions = false;
                            });
                          },
                          icon: const Icon(Icons.delete, color: Colors.red, size: 40),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
