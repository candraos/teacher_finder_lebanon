import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:teacher_finder_lebanon/Classes/database_helper.dart';
import 'package:teacher_finder_lebanon/Models/Connection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teacher_finder_lebanon/Models/Student.dart';
import 'package:teacher_finder_lebanon/Models/Teacher.dart';
import 'package:teacher_finder_lebanon/Models/User.dart';
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

  Future<int> fetch(BuildContext context) async{
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
      await DatabaseHelper.instance.deleteConnectionNotifications();
      await Future.wait(myConnections.map((connection) async{
        await _getUser(connection, user);
      }));

      return myConnections.length;
    }catch(e){
      print(e);
      return 0;
    }
  }


  Future<void> _getUser(Connection connection, dynamic user) async{
    final userQuery = await _supabase.from(user is Student ? "Teacher" : "Student").select().eq("customid", user is Student ? connection.TeacherID : connection.studentID).then((value) async{

      user is Student ?  connection.user = Teacher.fromJson(value[0]) : connection.user = Student.fromJson(value[0]);

      var notificationToAdd = NotificationViewModel(NotificationModel.Notification(
          connection.id,
          "${connection.user?.firstName} ${connection.user?.lastName} wants to be your ${connection.user is Student ? "Student" : "Teacher"}",
          "",
          NotificationModel.Type.Connection,
          connection.user!
      ));

      await _listNotificationsViewModel.addNotification(notificationToAdd);
    });
  }

  Future<bool> Accept(int id) async{
    try{
      final result = await _supabase.from("StudentTeacher").update({
        "isActive" : true,
        "isAccepted" : true
      }).eq("id", id);
      await DatabaseHelper.instance.deleteConnectionNotificationWithId(id);
      ListNotificationsViewModel().removeNotification(id);
      return true;
    }catch(e) {

      return false;
    };
  }

  Future<bool> Reject(int id) async{
    try{
      final result = await _supabase.from("StudentTeacher").delete().eq("id", id);
      await DatabaseHelper.instance.deleteConnectionNotificationWithId(id);
      ListNotificationsViewModel().removeNotification(id);
      return true;
    }catch(e) {

      return false;
    };
  }

}



