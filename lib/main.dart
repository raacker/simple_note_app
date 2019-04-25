import "package:flutter/material.dart";
import "screens/note_list.dart";

void main() => runApp(Main());

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "NoteKeeper",
      debugShowCheckedModeBanner: false,
      home: NoteList(),
    );
  }
}