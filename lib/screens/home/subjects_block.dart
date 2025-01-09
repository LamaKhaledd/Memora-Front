
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:memora/models/SubjectModel.dart';

class SubjectCreationWidget extends StatelessWidget {
  final bool creatingSubject;
  final Function(String) onCreateSubject; // Callback to create a subject
  final Function() onToggleCreatingSubject; // Callback to toggle visibility

  SubjectCreationWidget({
    required this.creatingSubject,
    required this.onCreateSubject,
    required this.onToggleCreatingSubject,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Visibility(
        visible: creatingSubject,
        replacement: const SizedBox(height: 40),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Container(
            height: 65,
            margin: const EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).floatingActionButtonTheme.backgroundColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  cursorColor: Theme.of(context).hintColor,
                  onSubmitted: (value) async {
                    onToggleCreatingSubject(); // Hide TextField after submitting
                    onCreateSubject(value); // Create the subject
                  },
                  autofocus: creatingSubject,
                  maxLength: 50,
                  controller: TextEditingController(),
                  style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).textTheme.bodyMedium!.color,
                  ),
                  decoration: InputDecoration(
                    hintText: "Add a subject",
                    hintStyle: TextStyle(color: Theme.of(context).hintColor),
                    counterText: "",
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).hintColor),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
class SubjectListWidget extends StatelessWidget {
  final List<SubjectModel> subjects;
  final Function(String) onDelete;

  SubjectListWidget({
    required this.subjects,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    // Initialize a local ScrollController for the Scrollbar
    final ScrollController subjectScrollController = ScrollController();

    return Container(
      height: 300, // Fixed height for the subject list
      child: Scrollbar(
        controller: subjectScrollController, // Attach the ScrollController
        thumbVisibility: true, // Make the scrollbar thumb always visible
        child: ListView.builder(
          controller: subjectScrollController, // Attach the ScrollController
          itemCount: subjects.length,
          itemBuilder: (context, index) {
            final subject = subjects[index];

            return Dismissible(
              key: Key(subject.id ?? ""),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) {
                onDelete(subject.id ?? "");
              },
              child: ListTile(
                title: Text(subject.subjectName ?? ""),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    onDelete(subject.id ?? "");
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
