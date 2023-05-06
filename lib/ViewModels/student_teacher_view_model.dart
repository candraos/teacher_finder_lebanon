import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';
import 'package:teacher_finder_lebanon/Models/Student.dart';
import 'package:teacher_finder_lebanon/Providers/login_provider.dart';

class StudentTeacherViewModel with ChangeNotifier{
  final _supabase = Supabase.instance.client;
  List<dynamic> images = [];


  Stream getCurrent(BuildContext context) {
    var user = context.read<LoginProvider>().user;
    String column = user is Student ? "studentID" : "teacherID";
    String table = user is Student ? "Teacher" : "Student";
    Stream stream = _supabase.from("StudentTeacher")
        .select("*,$table!inner(*)").match({
      column : user.id,
      "isActive" : true,
      // "$table.customid" : "StudentTeacher.$column"
    }).asStream();

    return stream;
  }

  Stream getPrevious(BuildContext context){
    var user = context.read<LoginProvider>().user;
    String column = user is Student ? "studentID" : "teacherID";
    String table = user is Student ? "Teacher" : "Student";
    Stream stream = _supabase.from("StudentTeacher")
        .select("*,$table!inner(*)").match({
      column : user.id,
      "isActive" : false,
      "isAccepted" : true,
    }).asStream();
    return stream;
  }

}