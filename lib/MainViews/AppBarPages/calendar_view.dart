import 'dart:convert';

import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teacher_finder_lebanon/MainViews/AppBarPages/view_session.dart';
import 'package:teacher_finder_lebanon/Models/Session.dart';
import 'package:teacher_finder_lebanon/Providers/login_provider.dart';
import 'package:teacher_finder_lebanon/ViewModels/user_vm.dart';
import '../../Models/Student.dart';
import '../../Models/Teacher.dart';
import 'add_session_view.dart';

import '../../Providers/session_provider.dart';


class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {




@override
  void initState() {
    super.initState();

    context.read<SessionProvider>().FetchSessions(
  context.read<LoginProvider>().user.id,
        context.read<LoginProvider>().user is Student ? "Student" : "Teacher");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: WeekView(
          controller: context.watch<SessionProvider>().controller,
          showLiveTimeLineInAllDays: true,
          onEventTap: (events,time) async{

            var event = events[0];

            UserViewModel userViewModel = UserViewModel();
            Student student = await userViewModel.fetchUser(jsonDecode(jsonEncode(event.event))["studentID"], "Student");
            Teacher teacher = await userViewModel.fetchUser(jsonDecode(jsonEncode(event.event))["teacherID"], "Teacher");


            Session session = Session(
              title: event.title,
              description: event.description,
              startTime: event.startTime!,
              endTime: event.endTime!,
              date: event.date,
              student:student,
              teacher:teacher

            );

            Navigator.of(context).push(MaterialPageRoute(builder: (context) => ViewSession(session: session)));
          },


        ),

    );
  }
}
