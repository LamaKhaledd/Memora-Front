import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:image_picker/image_picker.dart';
import 'package:memora/models/FlashcardModel.dart';
import 'package:memora/services/repositories/flashcard_repo.dart';

class FlashcardForm extends StatefulWidget {
  const FlashcardForm({super.key, this.subjectId, this.topicId, this.flashcard});
  final String? subjectId;
  final String? topicId;
  final FlashcardModel? flashcard;

  @override
  State<FlashcardForm> createState() => _FlashcardFormState();
}

class _FlashcardFormState extends State<FlashcardForm> {
  QuillController _questionController = QuillController.basic();
  QuillController _answerController = QuillController.basic();
  bool editing = false;
  FlashcardModel? flashcard;
  XFile? _image;

  @override
  void initState() {
    super.initState();
    if (widget.flashcard != null) {
      editing = true;
      flashcard = widget.flashcard;

      // Ensure that question and answer are valid JSON objects
      final questionJson = flashcard?.question != null && flashcard!.question!.isNotEmpty
          ? jsonDecode(flashcard!.question!)
          : [{"insert": ""}];  // Default to an empty document structure if no valid data
      final answerJson = flashcard?.answer != null && flashcard!.answer!.isNotEmpty
          ? jsonDecode(flashcard!.answer!)
          : [{"insert": ""}];  // Default to an empty document structure if no valid data

      // Convert to Delta format (List<dynamic>)
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
    }
  }

  Future<FlashcardModel?> createFlashcard(
      FlashcardModel flashcard, String subjectId, String topicId) async {
    flashcard.subjectId = subjectId;
    flashcard.topicId = topicId;
    flashcard.question =
        jsonEncode(_questionController.document.toDelta().toJson());
    flashcard.answer =
        jsonEncode(_answerController.document.toDelta().toJson());
    try {
      return await FlashcardRepository()
          .createFlashcard(flashcard, subjectId, topicId);
    } catch (error) {
      print("Error creating flashcard: $error");
      return null;
    }
  }

  Future<void> updateFlashcard(FlashcardModel flashcard) async {
    flashcard.question =
        jsonEncode(_questionController.document.toDelta().toJson());
    flashcard.answer =
        jsonEncode(_answerController.document.toDelta().toJson());
    try {
      FlashcardModel? updatedFlashcard =
      await FlashcardRepository().updateFlashcardById(flashcard);
      if (updatedFlashcard != null && mounted) {
        Navigator.of(context).pop(updatedFlashcard);
      } else {
        print("Failed to update flashcard");
      }
    } catch (error) {
      print("Error updating flashcard: $error");
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile =
    await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = pickedFile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).dialogTheme.backgroundColor,
      title: Text(
        widget.flashcard != null ? "Edit flashcard" : "Create flashcard",
        style: TextStyle(color: Theme.of(context).textTheme.bodyMedium!.color),
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            QuillToolbar.simple(
              configurations: QuillSimpleToolbarConfigurations(
                controller: _questionController,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 200,
              child: QuillEditor.basic(
                configurations: QuillEditorConfigurations(
                  controller: _questionController,
                  checkBoxReadOnly: false,
                ),
              ),
            ),
            const SizedBox(height: 20),
            QuillToolbar.simple(
              configurations: QuillSimpleToolbarConfigurations(
                controller: _answerController,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 200,
              child: QuillEditor.basic(
                configurations: QuillEditorConfigurations(
                  controller: _answerController,
                  checkBoxReadOnly: false,
                ),
              ),
            ),
            const SizedBox(height: 10),
            if (_image != null)
              Image.file(
                File(_image!.path),
                height: 150,
                width: 150,
                fit: BoxFit.cover,
              ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          style: TextButton.styleFrom(
            textStyle: Theme.of(context).textTheme.labelLarge,
          ),
          child: Text(
            'Cancel',
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyMedium!.color,
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          style: TextButton.styleFrom(
            textStyle: Theme.of(context).textTheme.labelLarge,
          ),
          child: Text(
            editing ? "Save" : "Create",
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyMedium!.color,
            ),
          ),
          onPressed: () async {
            if (mounted) {
              setState(() {
                if (editing) {
                  updateFlashcard(flashcard!);
                } else {
                  createFlashcard(
                    flashcard!,
                    widget.subjectId!,
                    widget.topicId!,
                  ).then((flashcard) {
                    if (flashcard != null && mounted) {
                      Navigator.of(context).pop(flashcard);
                    }
                  });
                }
              });
            }
          },
        ),
      ],
    );
  }
}
