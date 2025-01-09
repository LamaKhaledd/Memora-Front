import 'package:memora/widgets/DrawerMenu.dart';
import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

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
          title: Text("About", style: TextStyle(color: Theme.of(context).textTheme.bodyMedium!.color)),
          centerTitle: true
      ),
      drawer: const DrawerMenu(),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            margin: const EdgeInsets.only(top: 25),
            width: MediaQuery.of(context).size.width * .88,
            child: const Column(
                children: [
                  Row(
                    children: [
                      Text("About Memora -This page must be moved-", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text("    Ideal for those who want to optimize their studies in an organized and intelligent way, with Flashcard Forge you can create personalized flashcards and use artificial intelligence to generate questions and answers from large volumes of text. Study efficiently, wherever and whenever you want, with a tool designed to adapt to your needs.", style: TextStyle(fontSize: 16.5)),
                  SizedBox(height: 20),

                  Row(
                    children: [
                      Text("Minimalist", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text("    Memora features a clean and simple design, reducing visual stimuli to help you focus on studying. The intuitive interface eliminates distractions, providing a more focused and efficient learning experience.", style: TextStyle(fontSize: 16.5)),
                  SizedBox(height: 20),

                  Row(
                    children: [
                      Text("Custom Organization", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text("    Create manual flashcards and adapt them to your specific study needs. Separate your content by subjects and topics, ensuring that you always have the right materials at hand, organized in the way that suits you best.", style: TextStyle(fontSize: 16.5)),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Text("AI-Powered Learning", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text("    Take advantage of artificial intelligence to automatically generate flashcards. Simply provide large volumes of text, either by pasting it directly into the app or uploading files, and our advanced AI will turn this information into optimized questions and answers, making exam preparation or content review even easier.", style: TextStyle(fontSize: 16.5)),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Text("Flexibility and Convenience", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text("    Memora is designed to be used wherever you are, offering flexibility and convenience whether you're commuting, at home, or during breaks between classes. With an intuitive and easy-to-use interface, the focus is always on what truly matters: learning.", style: TextStyle(fontSize: 16.5)),
                  SizedBox(height: 20)
                ]
            ),
          ),
        ),
      ),
    );
  }
}
