import 'dart:async';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:memora/components/common/height_spacer.dart';
import 'package:memora/models/SubjectModel.dart';
import 'package:memora/providers.dart';
import 'package:memora/screens/statistics_screen.dart';
import 'package:memora/screens/study_session_screen.dart';
import 'package:memora/services/repositories/preferences_repo.dart';
import 'package:memora/services/repositories/subject_repo.dart';
import 'package:memora/widgets/CustomSearchBar.dart';
import 'package:memora/widgets/DrawerMenu.dart';
import 'package:memora/widgets/SubjectContainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:memora/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:memora/models/SubjectModel.dart';
import 'package:memora/screens/home/flashcards_stats_blocks.dart';
import 'package:memora/screens/home/notes_block.dart';
import 'package:memora/screens/home/pomodoro_block.dart';
import 'package:memora/screens/home/subjects_block.dart';

import 'package:memora/screens/home/video_conferencing_block.dart';
import '../models/ChatUser.dart';
import '../services/repositories/user_repo.dart';
import '../widgets/InfoColumn.dart';
import '../widgets/PopularQuestionCard.dart';
import '../widgets/RecentItemWidget.dart';
import '../widgets/TopCreatorCard.dart';
import 'flashcards_screen.dart';


/*
*
*
* lama in statistics_screen.dart >>>
*
* I changed the names like this
*
* ReviewStatsApp >>> ReviewFullStatsApp
*
* ReviewStatsPage >>> ViewStatsPage
*
* also in the note taking block I used the image images/light.png
*
*
* */








class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});

  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ChatUser> topCreators = [];
  bool isLoadingg = true;



  void deleteSubject(String id) {
    setState(() {
      subjects.removeWhere((subject) => subject.id == id);
    });
  }

  late TextEditingController _controller;
  final scrollController = ScrollController();

  late StreamSubscription<bool> keyboardSubscription;
  bool isSearching = false;
  int offset = 0;
  int limit = 15;
  bool hasMore = true;
  bool isLoadingMore = false;
  int deleteCount = 0;

  final FocusNode _focusNode = FocusNode();

  bool isLoading = false;
  bool creatingSubject = false;
  List<SubjectModel> subjects = [];

  void setLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  Future<void> createSubject(SubjectModel subject) async {
    try {
      SubjectModel newSubject =
      await SubjectRepository().createSubject(subject);
      setState(() {
        subjects.add(newSubject);
      });
    } catch (e) {
      print(e);
      //exibe modal de erro
    }
  }

  bool isSubjectDuplicate(SubjectModel newSubject) {
    return subjects.any((subject) => subject.id == newSubject.id);
  }

  Future<void> getSubjects(
      {bool requestMore = false,
        bool isRefresh = false,
        String searchTerm = ""}) async {
    if (!isRefresh && (isLoading || isLoadingMore || !hasMore)) return;

    if (isRefresh) {
      setState(() {
        subjects.clear();
        offset = 0;
        limit = 15;
        hasMore = true;
      });
      setLoading(true);
    } else if (requestMore) {
      setState(() {
        isLoadingMore = true;
      });
    } else {
      setLoading(true);
    }

    try {
      List<SubjectModel>? newSubjects =
      await SubjectRepository().fetchSubjects(offset, limit, searchTerm);

      if (newSubjects != null && newSubjects.isNotEmpty) {
        setState(() {
          subjects.addAll(newSubjects
              .where((newSubject) => !isSubjectDuplicate(newSubject))
              .toList());
          offset += limit;
        });

        if (newSubjects.length < limit) {
          setState(() => hasMore = false);
        }
      } else {
        setState(() => hasMore = false);
      }
    } catch (e) {
    } finally {
      setLoading(false);
      setState(() {
        isLoadingMore = false;
      });
    }
  }

  Future<void> showConfirmModal() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).dialogTheme.backgroundColor,
          content: SizedBox(
            width: MediaQuery.of(context).size.width * .95,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Icon(Icons.warning_amber_rounded,
                      color: Colors.orangeAccent, size: 100),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Do you want to save the action?",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyMedium!.color,
                          fontSize: 20,
                        )),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: Text('Cancel',
                  style: TextStyle(
                      color: Theme.of(context).textTheme.bodyMedium!.color,
                      fontSize: 16)),
              onPressed: () {
                setState(() {
                  _controller.text = "";
                  creatingSubject = false;
                });
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: Text("Save",
                  style: TextStyle(
                      color: Theme.of(context).textTheme.bodyMedium!.color,
                      fontSize: 16)),
              onPressed: () async {
                createSubject(SubjectModel(subjectName: _controller.text))
                    .then((_) {
                  setState(() {
                    _controller.text = "";
                    creatingSubject = false;
                  });
                  Navigator.of(context).pop();
                });
              },
            ),
          ],
        );
      },
    );
  }

  void scrollToEndAndFocus() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController
          .animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      )
          .then((_) => FocusScope.of(context).requestFocus(_focusNode));
    });
  }


  Future<void> _fetchTopCreators() async {
    try {
      List<ChatUser> users = await UserRepository().fetchUsersWithHighestGrades();
      print(users);
      setState(() {
        topCreators = users;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Handle error if needed
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchTopCreators();
    _controller = TextEditingController();
    KeyboardVisibilityController().onChange.listen((bool visible) {
      if (creatingSubject && !visible) {
        if (_controller.text == "") {
          setState(() {
            _controller.text = "";
            creatingSubject = false;
          });
        } else {
          showConfirmModal();
        }
      }
    });
    getSubjects();
  }


  @override
  void dispose() {
    _controller.dispose();
    scrollController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
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
          title: SvgPicture.asset('assets/images/logo-v1.svg',
              height: 35, width: 35),
          centerTitle: true,
        ),
        drawer: const DrawerMenu(),

        body: SingleChildScrollView(  // Make sure the body is scrollable if needed

          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/memora.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    height: MediaQuery.of(context).size.height * .2,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "Welcome to Memora! This app is designed to help you create, organize, and study flashcards efficiently. Whether you're preparing for exams or just building your knowledge, Memora is your go-to tool for personalized learning.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).textTheme.bodyMedium!.color,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start, // Aligns items to the start (left)
                    children: [
                      Expanded(
                        child: CustomSearchBar(
                          onSearchChanged: (value) {
                            getSubjects(isRefresh: true, searchTerm: value);
                          },
                        ),
                      ),
                      SizedBox(width: 10), // Optional: Add some space between the search bar and button
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFA580A6), // Button color
                        ),
                        onPressed: () {
                          // Your button action here
                        },
                        child: Text("Search"),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),
                /*
                FlashcardStatsBlock(
                  totalReviewed: 20,
                  correctAnswers: 10,
                  incorrectAnswers: 10,
                  dueForReview: 10,
                ),*/



                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Recents",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.bodyMedium!.color,
                      ),
                    ),
                  ),
                ),
                // Ensure GridView does not conflict with scroll
                Container(
                  height: 200, // Set a fixed height for the GridView
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 8,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      RecentItemWidget(
                        title: "POM Chapt 1",
                        terms: 58,
                        author: "harley_mariner",
                      ),
                      RecentItemWidget(
                        title: "Chapter 1",
                        terms: 61,
                        author: "mackieldioslaki",
                      ),
                      RecentItemWidget(
                        title: "MHR 301 FINAL",
                        terms: 114,
                        author: "roanne_paguyo",
                      ),
                      RecentItemWidget(
                        title: "Practice Exam 2",
                        terms: 13,
                        author: "braceybarnettt",
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Subjects",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.bodyMedium!.color,
                      ),
                    ),
                  ),
                ),

                // Apply visibility check here
                Visibility(
                  visible: !isLoading && (subjects.isNotEmpty || creatingSubject),
                  replacement: Center(
                    child: Visibility(
                      visible: isLoading,
                      replacement: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: SvgPicture.asset(
                              "assets/images/no-content.svg",
                              width: MediaQuery.of(context).size.width * .4,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              "No subjects yet",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 22,
                                  color: Theme.of(context).textTheme.bodyMedium!.color),
                            ),
                          ),
                        ],
                      ),
                      child: SizedBox(
                        width: 60,
                        height: 60,
                        child: CircularProgressIndicator(
                          color: Theme.of(context).textTheme.bodyMedium!.color,
                        ),
                      ),
                    ),
                  ),
                  child: NotificationListener<ScrollEndNotification>(
                    onNotification: (notification) {
                      if (notification.metrics.pixels == notification.metrics.maxScrollExtent) {
                        if (!creatingSubject) {
                          getSubjects(requestMore: true);
                        }
                      }
                      return false;
                    },
                    child: RefreshIndicator(
                      color: Colors.black,
                      backgroundColor: Colors.white,
                      onRefresh: () async {
                        await getSubjects(isRefresh: true);
                      },
                      child: Container(  // Limit the space for subjects
                        height: 400,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color(0xFF4F3466),  // Set your custom color
                            width: 4.0,                // Border width
                          ),
                          borderRadius: BorderRadius.circular(10), // Optional: to round the corners
                        ),                  child: Scrollbar(  // Add the scrollbar here around the ListView
                        controller: scrollController,  // Ensure the scrollbar is connected to the scroll controller
                        child: ListView.builder(
                          physics: const ScrollPhysics(
                              parent: AlwaysScrollableScrollPhysics()),
                          shrinkWrap: true,
                          controller: scrollController,
                          itemCount: subjects.length + 1,
                          itemBuilder: (context, index) {
                            if (index == subjects.length) {
                              return isLoadingMore
                                  ? Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: SizedBox(
                                    width: 30,
                                    height: 30,
                                    child: CircularProgressIndicator(
                                      color: Theme.of(context).textTheme.bodyMedium!.color,
                                    ),
                                  ),
                                ),
                              )
                                  : Visibility(
                                visible: creatingSubject,
                                replacement: const SizedBox(height: 40),
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Container(
                                    height: 65,
                                    margin: const EdgeInsets.only(top: 10),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .floatingActionButtonTheme
                                          .backgroundColor,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 20),
                                        child: TextField(
                                          cursorColor: Theme.of(context).hintColor,
                                          onSubmitted: (value) async {
                                            setState(() {
                                              creatingSubject = false;
                                              _controller.text = "";
                                            });
                                            await createSubject(SubjectModel(subjectName: value));
                                          },
                                          autofocus: creatingSubject,
                                          maxLength: 50,
                                          controller: _controller,
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Theme.of(context).textTheme.bodyMedium!.color),
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
                                          focusNode: _focusNode,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }

                            final subject = subjects[index];

                            return SubjectContainer(
                              subject: subject,
                              onDelete: (id) {
                                setState(() {
                                  subjects = List.from(subjects)..removeWhere((s) => s.id == id);
                                });
                              },
                            );
                          },
                        ),
                      ),
                      ),
                    ),
                  ),),
                const SizedBox(height: 80),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Popular Questions",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.bodyMedium!.color,
                      ),
                    ),
                  ),
                ),


                Container(
                  height: 260, // Set a fixed height for the GridView
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 3,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 2,
                    ),
                    itemBuilder: (context, index) {
                      return PopularQuestionCard(
                        title: "How does memory allocation work in operating systems?",
                        terms: 5,
                        author: "John Doe",
                      );
                    },
                  ),
                ),

                const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Top Creators",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.bodyMedium!.color,
                    ),
                  ),
                  const SizedBox(height: 10),
                  isLoading
                      ? Center(child: CircularProgressIndicator())
                      : Container(
                    height: 260,
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: topCreators.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 2,
                      ),
                      itemBuilder: (context, index) {
                        print(topCreators.length);
                        final creator = topCreators[index];
                        print(creator);
                        return TopCreatorCard(creator: creator); // Pass the creator object
                      },

                    ),
                  ),
                ],
              ),
            ),
                const SizedBox(height: 40),
                PomodoroCard(),
                SizedBox(height: 40),
                //const SizedBox(height: 40),
                QuickNoteWidget(),
                SizedBox(height: 40),


              ],
            ),
          ),
        ),


        floatingActionButton: Visibility(
            visible: !creatingSubject,
            child: Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(15),
                  gradient: Styles.linearGradient,
                ),
                child: FloatingActionButton(
                  backgroundColor: Theme.of(context)
                      .floatingActionButtonTheme
                      .backgroundColor,
                  onPressed: () {
                    setState(() {
                      creatingSubject = true;
                    });
                    scrollToEndAndFocus();
                  },
                  tooltip: 'Create new subject',
                  child: Icon(Icons.add,
                      color: Theme.of(context).textTheme.bodyMedium!.color),
                ))));
  }

}
