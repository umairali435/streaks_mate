import 'dart:convert';

class Streak {
  int? _id;
  String? _title;
  int? _goal;
  int? _icon;
  List<String>? _dates;

  Streak(this._title, this._goal, this._dates, this._icon);
  Streak.withId(this._id, this._title, this._goal, this._dates, this._icon);

  int get id => _id!;

  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'title': _title,
      'goal': _goal,
      'icon': _icon,
      'dates': jsonEncode(_dates),
    };
  }

  String get title => _title!;

  int get goal => _goal!;

  set goal(int value) {
    _goal = value;
  }

  int get icon => _icon!;

  set icon(int value) {
    _icon = value;
  }

  set title(String value) {
    _title = value;
  }

  set id(int value) {
    _id = value;
  }

  List<String> get dates => _dates!;

  set dates(List<String> date) {
    _dates = date;
  }

  Streak.fromMap(Map<String, dynamic> map) {
    _id = map['id'];
    _title = map['title'];
    _goal = map['goal'];
    _icon = map['icon'];
    _dates = List<String>.from(jsonDecode(map['dates']));
  }
}
