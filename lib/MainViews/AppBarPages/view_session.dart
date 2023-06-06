
import 'package:flutter/material.dart';
import 'package:teacher_finder_lebanon/Models/Session.dart';
import 'package:provider/provider.dart';
import 'package:teacher_finder_lebanon/Providers/login_provider.dart';
import 'package:teacher_finder_lebanon/Providers/session_provider.dart';

import '../../Models/Student.dart';

class ViewSession extends StatelessWidget {
  const ViewSession({Key? key, required this.session}) : super(key: key);

  final Session session;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Session"),
        actions: [IconButton(icon: Icon(Icons.delete), onPressed: () => {
          showDialog(
              context: context,
              builder: (_) =>
          AlertDialog(
            title: Text("Delete Session"),
            content: Text("Are you sure you want to delete the session?"),
            actions: [
              TextButton(
                  onPressed: () async{
                    print("running");
                    SessionProvider provider = SessionProvider();
                    bool success = await provider.removeSession(session.id!);
                    if(success){
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Session deleted"),action: SnackBarAction(
                        label: "Dismiss",
                        onPressed: () {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        },
                      ),));
                    }else{
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error occurred, please try again later"),action: SnackBarAction(
                        label: "Dismiss",
                        onPressed: () {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        },
                      ),));
                    }
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  child: Text("yes")),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("no")),
            ],
          )
            )
        },)],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [

            SizedBox(height: 20,),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  session.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold
                  ),
                ),

                Text(" with "
                    "${context.read<LoginProvider>().user is Student
                    ? "${session.teacher.firstName} ${session.teacher.lastName}"
                    : "${session.student.firstName} ${session.student.lastName}"}",
                style: TextStyle(fontSize: 20),)
              ],
            ),

            SizedBox(height: 20,),


            Text(
              session.date.toString().split(" ")[0],
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold
              ),
            ),


            Text("${session.startTime.toString().split(" ")[1].split(".")[0]} - ${session.endTime.toString().split(" ")[1].split(".")[0]}",
              style: TextStyle(fontSize: 20),
            ),

            SizedBox(height: 20,),

            Text(
              session.description,
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
