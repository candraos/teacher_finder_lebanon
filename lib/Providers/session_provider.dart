
import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:teacher_finder_lebanon/Models/User.dart';

import '../Models/Session.dart' as model;



class SessionProvider with ChangeNotifier{
  EventController _controller = EventController();
  final _client = Supabase.instance.client;
  EventController get controller => _controller;
  List<model.Session> sessions = [];


  Future FetchSessions(String id,String table) async{
    try{
      String column = table == "Student" ? "studentID" : "teacherID";
      final result = await _client.from("Session").select("*,Student!inner(*),Teacher!inner(*)").eq(column, id);
      (result as List<dynamic>).map((sessionJson) => sessions.add(model.Session.fromJson(sessionJson))).toList();
      sessions.forEach((session) { _addToCalendar(session);});
    }catch(e){
      sessions = [];
    }
  }

  Future<bool> addSession(model.Session session)async{
   try{


     await _client.from("Session").insert(session.toJson());
     _addToCalendar(session);


     return true;
   }catch(e){
     return false;
   }
  }

  _addToCalendar(model.Session session){
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