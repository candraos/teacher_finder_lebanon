import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
    var temp = _supabase.from("StudentTeacher")
        .select("*,$table!inner(*)").match({
      column : user?.id,
      "isActive" : true,
    });
    Stream stream = _supabase.from("StudentTeacher")
        .select("*,$table!inner(*)").match({
      column : user?.id,
      "isActive" : true,
    }).asStream();

    return stream;
  }

  Stream getPrevious(BuildContext context){
    var user = context.read<LoginProvider>().user;
    String column = user is Student ? "studentID" : "teacherID";
    String table = user is Student ? "Teacher" : "Student";
    Stream stream = _supabase.from("StudentTeacher")
        .select("*,$table!inner(*)").match({
      column : user?.id,
      "isActive" : false,
      "isAccepted" : true,
    }).asStream();
    return stream;
  }

  Future<bool> remove(int id) async{
    try{
      await _supabase.from("StudentTeacher").update({
        "isActive" : false,
      }).eq("id", id);
      return true;
    }catch(e){
      return false;
    }
  }

}