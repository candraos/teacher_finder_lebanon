import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'add_session_view.dart';

import '../../Providers/session_provider.dart';


class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {

 var _controller = EventController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: WeekView(
          controller: context.watch<SessionProvider>().controller,
          showLiveTimeLineInAllDays: true,
          // eventArranger: SideEventArranger(),
          // onCellTap: (events,Time){
          //   print("clicked events $events and time $Time");
          // },

        ),
      floatingActionButton: FloatingActionButton(
        onPressed: () { Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddSession())); },
        child: Icon(Icons.add_sharp),
      ),
    );
  }
}
