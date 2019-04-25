class Note {
  int _id;
  String _title;
  String _description;
  String _date;
  int _priority;

  Note(this._title, this._date, this._priority, [this._description]);
  Note.withId(this._id, this._title, this._date, this._priority, [this._description]);

  int get id => _id;
  String get title => _title;
  String get description => _description;
  String get date => _date;
  int get priority => _priority;

  set title(String newTitle) {
    if (newTitle.isNotEmpty) {
      this._title = newTitle;
    }
  }

  set description(String description) {
    if(description.isNotEmpty) {
      this._description = description;
    }
  }

  set date(String date) {
    this._date = date;
  }

  set priority(int priority) {
    if (priority >= 0 && priority <= 2) {
      this._priority = priority;
    }
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    if (id != null) {
      map["id"] = _id;
    }
    map["title"] = _title;
    map["description"] = _description;
    map["priority"] = _priority;
    map["date"] = _date;

    return map;
  }

  Note.fromMap(Map<String, dynamic> map) {
    _id = map["id"];
    _title = map["title"];
    _description = map["description"];
    _priority = map["priority"];
    _date = map["date"];
  }
}