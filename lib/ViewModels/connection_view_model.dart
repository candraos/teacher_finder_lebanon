import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:teacher_finder_lebanon/Classes/database_helper.dart';
import 'package:teacher_finder_lebanon/Models/Connection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teacher_finder_lebanon/Models/Student.dart';
import 'package:teacher_finder_lebanon/Models/Teacher.dart';
import 'package:teacher_finder_lebanon/Providers/login_provider.dart';
import 'package:teacher_finder_lebanon/Models/Notification.dart' as NotificationModel;
import 'notification_view_model.dart';
class ConnectionViewModel with ChangeNotifier{
  final _supabase = Supabase.instance.client;
  ListNotificationsViewModel _listNotificationsViewModel = ListNotificationsViewModel();
  List<Connection> myConnections = [];
  Future<bool> send(Connection connection,BuildContext context) async{
    var user = context.read<LoginProvider>().user;
    String role = '';
    user is Student ? role = "student" : role = "teacher";

    try{
      final  check = await _supabase
          .from('StudentTeacher')
          .select("studentID,teacherID")
          .match({
        "studentID" : connection.studentID,
        "teacherID" : connection.TeacherID,
      });
      if((check as List<dynamic>).isEmpty){
        await _supabase.from("StudentTeacher").insert({
          "studentID" : connection.studentID,
          "teacherID" : connection.TeacherID,
          "isAccepted" : connection.isAccepted,
          "isActive" : connection.isActive,
          "role" : role
        });
      }else return false;

      return true;
    }catch(e){
      return false;
    }
  }

  Future<void> fetch(BuildContext context) async{
    var user = context.read<LoginProvider>().user;
    String column = '',table = '';
    user is Student ? column = "studentID" : column = "teacherID";
    user is Student ? table = "teacherID" : table = "studentID";
    try{

      final query = await _supabase.from("StudentTeacher").select("*").eq(column, user.id).match(
          {
            column: user.id,
            "role" : user is Student? "teacher" : "student",
          });
      myConnections = (query as List<dynamic>).map((connectionJSon) => Connection.fromJson(connectionJSon)).cast<Connection>().toList();
      myConnections.forEach((connection) {
        final userQuery =  _supabase.from(user is Student ? "Teacher" : "Student").select().eq("customid", user is Student ? connection.TeacherID : connection.studentID).then((value) {

          user is Student ?  connection.user = Teacher.fromJson(value[0]) : connection.user = Student.fromJson(value[0]);
          DatabaseHelper.instance.deleteConnectionNotifications().then((value) {
            _listNotificationsViewModel.addNotification(NotificationViewModel(NotificationModel.Notification(
                null,
                "${connection.user?.firstName} ${connection.user?.lastName} wants to be your ${connection.user is Student ? "Student" : "Teacher"}",
                "",
                NotificationModel.Type.Connection,
                connection.user!
            )));
          }

          );

        });
      });
    }catch(e){
    }
  }
}

