import "package:flutter/material.dart";
import "package:note_keeper_lecture/models/Note.dart";
import "package:note_keeper_lecture/utils/db_helper.dart";

class NoteEdit extends StatefulWidget {
  final int _id;
  final String _title;
  final String _noteTitle;
  final String _noteSubtitle;

  NoteEdit(this._title, [this._id = -1, this._noteTitle = "", this._noteSubtitle = ""]);
  NoteEdit.withNote(String title, Note note) : this(title, note.id, note.title, note.description);

  @override
  State<NoteEdit> createState() {
    return _NoteEditState(_title, _id, _noteTitle, _noteSubtitle);
  }
}

class _NoteEditState extends State<NoteEdit> {
  final String _title;
  int _id;
  String _noteTitle;
  String _noteSubtitle;
  bool _isEditing;

  List<String> _priority = ["High", "Medium", "Low"];
  int _selectedPriority;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  _NoteEditState(this._title, this._id, this._noteTitle, this._noteSubtitle) {
    _titleController.text = _noteTitle;
    _descriptionController.text = _noteSubtitle;
    if (_id == -1) {
      _isEditing = false;
    } else {
      _isEditing = true;
    }
  }

  @override
  void initState() {
    super.initState();
    _selectedPriority = 1;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        onBackPressed(false);
      },
      child: Scaffold(
        resizeToAvoidBottomPadding: true,
        appBar: AppBar(
          title: Text(_title),
        ),
        body: Padding(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                ListTile(
                  title: DropdownButton<String>(
                    items: _priority.map((string) {
                      return DropdownMenuItem<String> (
                        value: string,
                        child: Text(string),
                      );
                    }).toList(),
                    value: _priority[_selectedPriority],
                    onChanged: (string) {
                      setState(() {
                        _selectedPriority = _priority.indexOf(string);
                      });
                    },
                  ),
                ),
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: "Title",
                    hintText: "Title of note",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(0.5),
                    ),
                  ),
                  validator: (string) {
                    if (string.isEmpty) {
                      return "Title cannot be empty";
                    }
                  },
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: "Description",
                    hintText: "Details of note",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(0.5),
                    ),
                  ),
                  validator: (string) {
                    if (string.isEmpty) {
                      return "Description cannot be empty";
                    }
                  },
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: RaisedButton(
                        child: Text("Save"),
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            debugPrint("save clicked");
                            var now = DateTime.now();
                            if (_isEditing) {
                              Note note = Note.withId(
                                _id,
                                _titleController.text,
                                now.toString(),
                                _selectedPriority,
                                _descriptionController.text,
                              );
                              DatabaseHelper().updateNote(note);
                            } else {
                              Note note = Note(
                                _titleController.text,
                                now.toString(),
                                _selectedPriority,
                                _descriptionController.text,
                              );
                              DatabaseHelper().insertNote(note);
                            }
                            onBackPressed(true);
                          }
                        },
                      ),
                    ),
                    Container(width: 5.0,),
                    Expanded(
                      child: RaisedButton(
                        child: Text("Delete"),
                        onPressed: () {
                          if (_id != -1) {
                            DatabaseHelper().deleteNote(_id);
                            onBackPressed(true);
                          } else {
                            onBackPressed(false);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            )
          ),
        ),
      ),
    );
  }

  void onBackPressed(bool onEdit) {
    Navigator.pop(context, onEdit);
  }
}