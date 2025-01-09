import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flip_card/flip_card.dart';
import 'package:memora/models/FlashcardModel.dart';
import 'package:memora/models/StudySessionModel.dart';
import 'package:memora/services/repositories/flashcard_repo.dart';
import 'package:memora/services/repositories/StudySessionRepository.dart';
import 'package:memora/utils/constants.dart';

class StudySession extends StatefulWidget {
  final String subjectId;
  final String topicId;
  final String? topicName;
  final List<FlashcardModel>? flashcardList;

  const StudySession({
    super.key,
    this.flashcardList,
    required this.subjectId,
    required this.topicId,
    this.topicName,
  });

  @override
  State<StudySession> createState() => _StudySessionState();
}

class _StudySessionState extends State<StudySession> {
  GlobalKey<FlipCardState> flipCardKey = GlobalKey<FlipCardState>();

  int currentIndex = 0;
  double progress = 0.0;
  bool sessionCompleted = false;

  int correctAnswerCount = 0;
  int incorrectAnswerCount = 0;
  int correctEasy = 0;
  int correctMedium = 0;
  int correctHard = 0;
  int? responseQuality;

  QuillController? _questionController;
  QuillController? _answerController;

  // Method to save study session with parameters
  void saveStudySession({
    required String subjectId,
    required String topicName,
    required String topicId,
    required int correctAnswerCount,
    required int incorrectAnswerCount,
    required int totalQuestions,
    required String totalTimeSpent,
    required int easyQuestionCount,
    required int mediumQuestionCount,
    required int hardQuestionCount,
    required List<FlashcardModel> easyQuestions,
    required List<FlashcardModel> mediumQuestions,
    required List<FlashcardModel> hardQuestions,
  }) async {
    StudySessionModel studySession = StudySessionModel(
      subjectId: subjectId,
      topicName: topicName,
      topicId: topicId,
      correctAnswerCount: correctAnswerCount,
      incorrectAnswerCount: incorrectAnswerCount,
      totalQuestions: totalQuestions,
      totalTimeSpent: totalTimeSpent,
      easyQuestionCount: easyQuestionCount,
      mediumQuestionCount: mediumQuestionCount,
      hardQuestionCount: hardQuestionCount,
      easyQuestions: easyQuestions,
      mediumQuestions: mediumQuestions,
      hardQuestions: hardQuestions,
    );

    print('Saving Study Session with parameters:');
    print('Subject ID: $subjectId');
    print('Topic Name: $topicName');
    print('Topic ID: $topicId');
    print('Correct Answer Count: $correctAnswerCount');
    print('Incorrect Answer Count: $incorrectAnswerCount');
    print('Total Questions: $totalQuestions');
    print('Total Time Spent: $totalTimeSpent');
    print('Easy Question Count: $easyQuestionCount');
    print('Medium Question Count: $mediumQuestionCount');
    print('Hard Question Count: $hardQuestionCount');
    print('Easy Questions: ${easyQuestions.length}');
    print('Medium Questions: ${mediumQuestions.length}');
    print('Hard Questions: ${hardQuestions.length}');

    // Call the repository to save the study session
    await StudySessionRepository().createStudySession(studySession);
  }

  void updateProgress() {
    double percent = 1 / widget.flashcardList!.length;
    if (progress + percent < 1) {
      progress += percent;
    }
  }

  late Timer _timer;
  int _secondsElapsed = 0;
  String get timerText =>
      '${(_secondsElapsed ~/ 3600).toString().padLeft(2, '0')}:' +
          '${((_secondsElapsed % 3600) ~/ 60).toString().padLeft(2, '0')}:' +
          '${(_secondsElapsed % 60).toString().padLeft(2, '0')}';

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _secondsElapsed++;
      });
    });
  }

  void _stopTimer() {
    _timer.cancel();
  }

  @override
  void initState() {
    super.initState();
    _startTimer();
    if (widget.flashcardList != null && widget.flashcardList!.isNotEmpty) {
      loadFlashcardContent(currentIndex);
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void loadFlashcardContent(int index) {
    final flashcard = widget.flashcardList![index];
    final questionJson = flashcard.question != null && flashcard.question!.isNotEmpty
        ? jsonDecode(flashcard.question!)
        : [{"insert": ""}];
    final answerJson = flashcard.answer != null && flashcard.answer!.isNotEmpty
        ? jsonDecode(flashcard.answer!)
        : [{"insert": ""}];

    _questionController = QuillController(
      document: Document.fromJson(questionJson),
      selection: TextSelection.collapsed(offset: 0),
    );
    _answerController = QuillController(
      document: Document.fromJson(answerJson),
      selection: TextSelection.collapsed(offset: 0),
    );
  }

  void updateFlashcardRatingAndStatus(bool isCorrect, String subjectId, String topicId) async {
    if (responseQuality != null) {
      int ratingValue = responseQuality!;

      FlashcardModel flashcard = widget.flashcardList![currentIndex];
      FlashcardModel updatedFlashcard = await FlashcardRepository().updateFlashcard(flashcard, ratingValue);

      setState(() {
        widget.flashcardList![currentIndex] = updatedFlashcard;
      });

      if (isCorrect) {
        correctAnswerCount += 1;

        if (flashcard.difficulty == 0) {
          correctEasy += 1;
        } else if (flashcard.difficulty == 1) {
          correctMedium += 1;
        } else if (flashcard.difficulty == 2) {
          correctHard += 1;
        }
      } else {
        incorrectAnswerCount += 1;
      }

      if (currentIndex < widget.flashcardList!.length - 1) {
        setState(() {
          currentIndex++;
        });

        loadFlashcardContent(currentIndex);
        flipCardKey.currentState?.toggleCardWithoutAnimation();
      } else {
        _stopTimer();
        sessionCompleted = true;

        // Collect questions for each difficulty level
        List<FlashcardModel> easyQuestions = [];
        List<FlashcardModel> mediumQuestions = [];
        List<FlashcardModel> hardQuestions = [];

        for (var flashcard in widget.flashcardList!) {
          // Only consider answered questions (lastResponse is not null)
          if (flashcard.lastResponse != null) {
            switch (flashcard.difficulty) {
              case 0: // Easy
                easyQuestions.add(flashcard);
                break;
              case 1: // Medium
                mediumQuestions.add(flashcard);
                break;
              case 2: // Hard
                hardQuestions.add(flashcard);
                break;
              default:
                break;
            }
          }
        }

        saveStudySession(
          subjectId: widget.subjectId,
          topicName: widget.topicName ?? '',
          topicId: widget.topicId,
          correctAnswerCount: correctAnswerCount,
          incorrectAnswerCount: incorrectAnswerCount,
          totalQuestions: widget.flashcardList!.length,
          totalTimeSpent: timerText, // Or you can pass the elapsed time in another format
          easyQuestionCount: easyQuestions.length,
          mediumQuestionCount: mediumQuestions.length,
          hardQuestionCount: hardQuestions.length,
          easyQuestions: easyQuestions,
          mediumQuestions: mediumQuestions,
          hardQuestions: hardQuestions,
        );
      }
      updateProgress();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(170, 0, 0, 0),
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(seconds: 1),
                curve: Curves.easeInOut,
                alignment: Alignment.bottomCenter,
                transform: Matrix4.translationValues(0.0, sessionCompleted ? 0.0 : MediaQuery.of(context).size.height, 0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text("Feedback", style: TextStyle(fontSize: 35, color: Colors.white)),
                    const SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("🎯 Score: $correctAnswerCount/${widget.flashcardList!.length}", style: const TextStyle(fontSize: 20, color: Colors.white)),
                        Text("⌛ Time: $timerText", style: const TextStyle(fontSize: 20, color: Colors.white)),
                        Text("🥱 Easy: $correctEasy/${widget.flashcardList!.where((fc) => fc.difficulty == 0).length}", style: TextStyle(fontSize: 20, color: Styles.greenEasy)),
                        Text("😐 Medium: $correctMedium/${widget.flashcardList!.where((fc) => fc.difficulty == 1).length}", style: TextStyle(fontSize: 20, color: Styles.blueNeutral)),
                        Text("😡 Hard: $correctHard/${widget.flashcardList!.where((fc) => fc.difficulty == 2).length}", style: TextStyle(fontSize: 20, color: Styles.redHard)),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
          Visibility(
            visible: !sessionCompleted,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(timerText, style: const TextStyle(fontSize: 22, color: Colors.white)),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.45,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: FlipCard(
                    key: flipCardKey,
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
                            child: Text("Question:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 18),
                              child: QuillEditor.basic(
                                configurations: QuillEditorConfigurations(
                                  controller: _questionController!,
                                  checkBoxReadOnly: true,
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
                            child: Text("Answer:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 18),
                              child: QuillEditor.basic(
                                configurations: QuillEditorConfigurations(
                                  controller: _answerController!,
                                  checkBoxReadOnly: true,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(5, (index) {
                              return IconButton(
                                icon: Icon(
                                  index < (responseQuality ?? 0) ? Icons.star : Icons.star_border,
                                  color: index < (responseQuality ?? 0) ? Colors.amber : Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    responseQuality = index + 1;
                                    print("Updated response quality: $responseQuality");
                                  });
                                },
                              );
                            }),
                          ),
                          const SizedBox(height: 30),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .5,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      updateFlashcardRatingAndStatus(true, widget.subjectId, widget.topicId);
                                    });
                                  },
                                  child: Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        border: Border.all(
                                            color: Colors.green,
                                            width: 2
                                        )
                                    ),
                                    child: const Icon(Icons.check, color: Colors.green),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      updateFlashcardRatingAndStatus(false,widget.subjectId, widget.topicId);
                                    });
                                  },
                                  child: Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        border: Border.all(
                                            color: Colors.red,
                                            width: 2
                                        )
                                    ),
                                    child: const Icon(Icons.close, color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
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
