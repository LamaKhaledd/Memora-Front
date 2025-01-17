import 'package:flutter/material.dart';
import 'package:memora/widgets/DrawerMenu.dart';
import 'package:memora/widgets/StudySessionCard.dart';
import 'package:memora/widgets/CustomSearchBar.dart'; // Import CustomSearchBar
import 'package:memora/models/StudySessionModel.dart';

import '../services/repositories/StudySessionRepository.dart';

class StudyHistoryScreen extends StatefulWidget {
  const StudyHistoryScreen({super.key});

  @override
  State<StudyHistoryScreen> createState() => _StudyHistoryScreenState();
}

class _StudyHistoryScreenState extends State<StudyHistoryScreen> {
  bool _isSearching = false;
  bool _isLoading = true;
  bool _hasError = false;
  List<StudySessionModel> _studySessions = [];
  final StudySessionRepository _studySessionRepo = StudySessionRepository();

  @override
  void initState() {
    super.initState();
    _fetchStudySessions();
  }

  Future<void> _fetchStudySessions() async {
    try {
      final sessions = await _studySessionRepo.fetchAllStudySessions();
      setState(() {
        _studySessions = sessions;
        _isLoading = false;
        _hasError = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
    });
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
        title: Text("Study History", style: TextStyle(color: Theme.of(context).textTheme.bodyMedium!.color)),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: _toggleSearch,
              icon: Icon(Icons.search, size: 25, color: Theme.of(context).textTheme.bodyMedium!.color)
          )
        ],
      ),
      drawer: const DrawerMenu(),
      body: Column(
        children: [
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: _isSearching
                ? SizedBox(
              width: MediaQuery.of(context).size.width * .9,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: CustomSearchBar(
                  label: "Search a topic",
                  onSearchChanged: (value) {
                    print(value);
                  },
                ),
              ),
            )
                : const SizedBox.shrink(),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _hasError
                ? const Center(child: Text('Failed to load study sessions.'))
                : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _studySessions.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Visibility(
                    visible: !_isSearching,
                    child: const Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Text(
                        "Past study sessions",
                        style: TextStyle(fontSize: 19),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                } else {
                  final studySession = _studySessions[index - 1];

                  BorderRadius borderRadius;
                  Border border;

                  if (index == 1) {
                    borderRadius = const BorderRadius.vertical(top: Radius.circular(10));
                    border = Border.all(color: Colors.blueGrey, width: 0.5);
                  } else if (index == _studySessions.length) {
                    borderRadius = const BorderRadius.vertical(bottom: Radius.circular(10));
                    border = const Border(
                      left: BorderSide(color: Colors.blueGrey, width: 0.5),
                      right: BorderSide(color: Colors.blueGrey, width: 0.5),
                      bottom: BorderSide(color: Colors.blueGrey, width: 0.5),
                    );
                  } else {
                    borderRadius = BorderRadius.zero;
                    border = const Border(
                      left: BorderSide(color: Colors.blueGrey, width: 0.5),
                      right: BorderSide(color: Colors.blueGrey, width: 0.5),
                      bottom: BorderSide(color: Colors.blueGrey, width: 0.5),
                    );
                  }

                  return Container(
                    decoration: BoxDecoration(
                      border: border,
                      borderRadius: borderRadius,
                    ),
                    child: StudySessionCard(session: studySession),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
