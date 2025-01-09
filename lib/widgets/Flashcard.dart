import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:memora/models/FlashcardModel.dart';
import 'package:flip_card/flip_card.dart';

class Flashcard extends StatefulWidget {
  final FlashcardModel? flashcard;
  final bool isSession;
  final Function(int)? onRatingSubmitted; // Callback to handle rating submission

  const Flashcard({super.key, this.flashcard, this.isSession = false, this.onRatingSubmitted});

  @override
  State<Flashcard> createState() => _FlashcardState();
}

class _FlashcardState extends State<Flashcard> {
  FlashcardModel? flashcard;
  int? _selectedRating; // Tracks the user's selected rating
  QuillController _questionController = QuillController.basic();
  QuillController _answerController = QuillController.basic();

  @override
  void initState() {
    flashcard = widget.flashcard;

    // Decode the question and answer from JSON into Delta format for QuillController
    final questionJson = flashcard?.question != null && flashcard!.question!.isNotEmpty
        ? jsonDecode(flashcard!.question!)
        : [{"insert": ""}]; // Default to empty content if no question

    final answerJson = flashcard?.answer != null && flashcard!.answer!.isNotEmpty
        ? jsonDecode(flashcard!.answer!)
        : [{"insert": ""}]; // Default to empty content if no answer

    final questionDoc = Document.fromJson(questionJson is List ? questionJson : []);
    final answerDoc = Document.fromJson(answerJson is List ? answerJson : []);

    _questionController = QuillController(
      document: questionDoc,
      selection: TextSelection.collapsed(offset: 0),
    );

    _answerController = QuillController(
      document: answerDoc,
      selection: TextSelection.collapsed(offset: 0),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(0),
      backgroundColor: Colors.transparent,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        width: MediaQuery.of(context).size.width * 0.8,
        child: FlipCard(
          fill: Fill.fillBack,
          direction: FlipDirection.HORIZONTAL,
          side: CardSide.FRONT,
          front: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).floatingActionButtonTheme.backgroundColor,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 30),
                  child: Text("Question:", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: SizedBox(
                      height: 100, // Adjust height as needed
                      child: Align(
                        alignment: Alignment.center, // Center the text inside the editor
                        child: QuillEditor.basic(
                          configurations: QuillEditorConfigurations(
                            controller: _questionController,
                            checkBoxReadOnly: true,
                              padding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          back: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).floatingActionButtonTheme.backgroundColor,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 30),
                  child: Text("Answer:", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: SizedBox(
                      height: 100, // Adjust height as needed
                      child: Align(
                        alignment: Alignment.center, // Center the text inside the editor
                        child: QuillEditor.basic(
                          configurations: QuillEditorConfigurations(
                            controller: _answerController,
                            checkBoxReadOnly: true,
                              padding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                if (widget.isSession) ...[
                  const SizedBox(height: 20),
                  const Text("Rate your recall:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(6, (index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedRating = index;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: _selectedRating == index ? Colors.blue : Colors.grey),
                            color: _selectedRating == index ? Colors.blue.withOpacity(0.2) : Colors.transparent,
                          ),
                          child: Text(
                            "$index",
                            style: TextStyle(
                              fontSize: 16,
                              color: _selectedRating == index ? Colors.blue : Colors.black,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _selectedRating != null
                        ? () {
                      widget.onRatingSubmitted?.call(_selectedRating!);
                      Navigator.of(context).pop(); // Close the dialog
                    }
                        : null, // Disable button until a rating is selected
                    child: const Text("Submit Rating"),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
