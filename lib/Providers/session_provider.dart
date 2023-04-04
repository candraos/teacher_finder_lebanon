
import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';

import '../Models/Session.dart';

class SessionProvider with ChangeNotifier{
  EventController _controller = EventController();

  EventController get controller => _controller;

  void addSession(Session session){
    _controller.add(CalendarEventData(
        title: session.title,
        date: session.date,
      startTime: session.startTime,
      endTime: session.endTime,
      description: session.description
    ));
    notifyListeners();
  }
}