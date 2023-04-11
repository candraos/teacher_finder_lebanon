import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:teacher_finder_lebanon/Models/Connection.dart';


class ConnectionViewModel {
  final _supabase = Supabase.instance.client;

  Future<bool> send(Connection connection) async{
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
          "isActive" : connection.isActive
        });
      }else return false;

      return true;
    }catch(e){
      return false;
    }
  }
}

