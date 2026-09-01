import 'package:flutter/foundation.dart';

class CalendarStore extends ChangeNotifier {
  CalendarStore._();
  static final CalendarStore instance = CalendarStore._();

  final Map<String, List<String>> _events = {};

  Map<String, List<String>> get events => _events;

  void addEvent(DateTime date, String title) {
    final key = _dateKey(date);
    _events.putIfAbsent(key, () => []);
    if (!_events[key]!.contains(title)) {
      _events[key]!.add(title);
      notifyListeners();
    }
  }

  List<String> eventsFor(DateTime date) {
    return _events[_dateKey(date)] ?? [];
  }

  String _dateKey(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}