
import 'dart:convert';

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
      sessions = [];
      _controller.removeWhere((element) => true);
      String column = table == "Student" ? "studentID" : "teacherID";
      final result = await _client.from("Session").select("*,Student!inner(*),Teacher!inner(*)").eq(column, id);
      (result as List<dynamic>).map((sessionJson) => sessions.add(model.Session.fromJson(sessionJson))).toList();
      sessions.forEach((session) { _addToCalendar(session);});
    }catch(e){
      sessions = [];
    }
  }

  // model.Session getSession({required DateTime date, required DateTime start, required DateTime end}){
  //   return sessions.where((session) => session.date == date && session.startTime = start && session.endTime == end);
  // }

  Future<bool> addSession(model.Session session)async{
   try{


     await _client.from("Session").insert(session.toJson());
     _addToCalendar(session);


     return true;
   }catch(e){
     return false;
   }
  }
  
  Future<bool> removeSession(int id) async {
    try{
       await _client.from("Session").delete().eq("id", id).then((value) {
         _controller.removeWhere((event) => jsonDecode(jsonEncode(event.event))["id"]);
         notifyListeners();
         return true;
       });
       notifyListeners();
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
        description: session.description,
event: session.toJson()
    ));
    notifyListeners();
  }
}