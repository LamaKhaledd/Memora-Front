import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:memora/models/FlashcardModel.dart';
import 'package:memora/models/TopicModel.dart';
import 'package:memora/screens/study_session_screen.dart';
import 'package:memora/widgets/DrawerMenu.dart';
import 'package:memora/widgets/FlashcardForm.dart';
import 'package:memora/widgets/FlashcardPreview.dart';
import 'dart:convert';

import '../models/SubjectModel.dart'; // Add this import at the top of the file


class FlashcardScreen extends StatefulWidget {
  const FlashcardScreen({super.key, this.topic});

  final TopicModel? topic;

  @override
  State<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> {
  void _removeFlashcard(FlashcardModel flashcard) {
    setState(() {
      widget.topic!.flashcards.remove(flashcard);
    });
  }

  void _loadWeweFile() async {
    final html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.accept = ".wewe"; // Restrict to .wewe files
    uploadInput.click();

    uploadInput.onChange.listen((event) async {
      final files = uploadInput.files;
      if (files != null && files.isNotEmpty) {
        final reader = html.FileReader();
        reader.readAsText(files.first);

        reader.onLoadEnd.listen((_) {
          if (reader.result != null) {
            final content = reader.result as String;

            try {
              // Parse JSON string to Map
              final Map<String, dynamic> jsonData = jsonDecode(content);

              // Create FlashcardModel from parsed JSON
              final newFlashcard = FlashcardModel.fromJson(jsonData);
              print(newFlashcard);

              setState(() {
                widget.topic!.flashcards.add(newFlashcard);
              });

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Flashcard loaded successfully!')),
              );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Invalid file format.')),
              );
            }
          }
        });

        reader.onError.listen((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to load the file.')),
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<FlashcardModel> flashcards = widget.topic!.flashcards;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(
                Icons.menu_rounded,
                color: Theme.of(context).textTheme.bodyMedium!.color,
                size: 30,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                widget.topic!.topicName,
                style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).textTheme.bodyMedium!.color),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            )
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: widget.topic!.flashcards.isNotEmpty
                ? () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return StudySession(
                      flashcardList: widget.topic!.flashcards, subjectId: widget.topic!.subjectId, topicId: widget.topic!.id, topicName: widget.topic?.topicName, );
                },
              );
            }
                : null,
            icon: Icon(
              Icons.play_arrow_rounded,
              size: 40,
              color: widget.topic!.flashcards.isNotEmpty
                  ? Theme.of(context).textTheme.bodyMedium!.color
                  : Colors.white.withOpacity(0.5),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.upload_file_rounded,
                    size: 30,
                    color: Theme.of(context).textTheme.bodyMedium!.color,
                  ),
                  onPressed: () {
                    // Add your UploadFileModal logic here if necessary
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.add_circle_outline, // (+) Icon for .wewe upload
                    size: 30,
                    color: Colors.green,
                  ),
                  onPressed: _loadWeweFile,
                ),
              ],
            ),
          ),
        ],
      ),
      drawer: const DrawerMenu(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            const SizedBox(
              height: 30,
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      "Score: 7/20",
                      style: TextStyle(fontSize: 20, color: Colors.red),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      "Time: 00:15:20",
                      style: TextStyle(fontSize: 20, color: Colors.blue),
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: Text(
                      "4",
                      style: TextStyle(fontSize: 20, color: Colors.green),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: Text(
                      "10",
                      style: TextStyle(fontSize: 20, color: Colors.blue),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: Text(
                      "6",
                      style: TextStyle(fontSize: 20, color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  Visibility(
                    visible: widget.topic!.flashcards.isNotEmpty,
                    replacement: SizedBox(
                      height: MediaQuery.of(context).size.height * .8,
                      width: MediaQuery.of(context).size.width * .85,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Icon(
                              Icons.block,
                              size: 50,
                              color: Colors.grey,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              "No flashcards yet",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 22,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .color,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: flashcards.length,
                        gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 20,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          return FlashcardPreview(
                            flashcard: widget.topic!.flashcards[index],
                            onDelete: _removeFlashcard,
                          );
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor:
        Theme.of(context).floatingActionButtonTheme.backgroundColor,
        onPressed: () async {
          final flashcardObject = await showDialog<FlashcardModel>(
            context: context,
            builder: (BuildContext context) {
              return FlashcardForm(
                subjectId: widget.topic!.subjectId,
                topicId: widget.topic!.id,
              );
            },
          );

          if (flashcardObject != null) {
            setState(() {
              widget.topic!.flashcards.add(flashcardObject);
            });
          }
        },
        tooltip: 'Create new Flashcard',
        child: Icon(Icons.add,
            color: Theme.of(context).textTheme.bodyMedium!.color),
      ),
    );
  }
}
