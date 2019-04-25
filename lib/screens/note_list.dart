import "package:flutter/material.dart";
import "note_edit.dart";
import "package:note_keeper_lecture/utils/db_helper.dart";
import "package:note_keeper_lecture/models/Note.dart";

class NoteList extends StatefulWidget {
  @override
  State<NoteList> createState() {
    return _NoteListState();
  }
}

class _NoteListState extends State<NoteList> {
  List<Note> _noteList = [];
  int _noteCount = 0;

  @override
  void initState() {
    super.initState();
    updateNoteList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notes"),
      ),
      body: getNoteListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateToEditPage("New Note");
        },
        child: Icon(Icons.add),
      ),
    );
  }

  ListView getNoteListView() {
    return ListView.builder(
      itemCount: _noteCount,
      itemBuilder: (BuildContext context, int position) {
        if (_noteList.length > 0) {
          Note note = _noteList[position];
          return createNoteTile(note);
        }
      }
    );
  }

  void navigateToEditPage(String title, [String noteTitle = "", String noteSubtitle = "", int id = -1]) async {
    bool refresh = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NoteEdit(title, id, noteTitle, noteSubtitle)),
    );

    if (refresh) {
      updateNoteList();
    }
  }

  void updateNoteList() async {
    List<Map<String, dynamic>> newList = await DatabaseHelper().getNoteMapList();
    setState(() {
      _noteList.clear();
      for (Map<String, dynamic> map in newList) {
        _noteList.add(Note.fromMap(map));
      }
      _noteCount = _noteList.length;
    });
  }

  Widget createNoteTile(Note note) {
    Color backgroundColor;
    if (note.priority == 0) {
      backgroundColor = Colors.red;
    } else if (note.priority == 1) {
      backgroundColor = Colors.yellow;
    } else {
      backgroundColor = Colors.blue;
    }
    return Card(
      color: Colors.white,
      elevation: 2.0,
      child: ListTile(
          leading: CircleAvatar(
            backgroundColor: backgroundColor,
            child: Icon(Icons.keyboard_arrow_right),
          ),
          title: Text(note.title, style: Theme.of(context).textTheme.title),
          subtitle: Text(note.description),
          trailing: IconButton(
            icon: Icon(Icons.delete, color: Colors.grey),
            onPressed: () async {
              await DatabaseHelper().deleteNote(note.id);
              updateNoteList();
            },
          ),
          onTap: () {
            navigateToEditPage("Edit Note", note.title, note.description, note.id);
          }
      ),
    );
  }
}
