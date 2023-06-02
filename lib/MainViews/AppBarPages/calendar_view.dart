import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teacher_finder_lebanon/Providers/login_provider.dart';
import '../../Models/Student.dart';
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


        ),

    );
  }
}
