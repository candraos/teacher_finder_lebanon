
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:teacher_finder_lebanon/Models/User.dart' as model;
import 'package:teacher_finder_lebanon/Providers/login_provider.dart';
import 'package:teacher_finder_lebanon/ViewModels/topic_vm.dart';

import '../Models/Student.dart';
import '../Models/Teacher.dart';

class SearchViewModel with ChangeNotifier{
  List<model.User> users = [];
  List<dynamic> images = [];
  List<ListTopicsViewModel> topics = [];
  final _supabase = Supabase.instance.client;
  Future<void> search(String keyword,BuildContext context) async{
    users = [];
    topics = [];
    if(keyword != null && keyword.isNotEmpty){
      var loggedin = context.read<LoginProvider>().user;
      String table = "";
      loggedin is Student? table = "Teacher" : table = "Student";
      final result = await _supabase.from(table).select("*")
                            .or("firstName.ilike.%$keyword%,lastName.ilike.%$keyword%");
      loggedin is Student?
      users = (result as List<dynamic>).map((userJson) => Teacher.fromJson(userJson)).toList()
      :  users = (result as List<dynamic>).map((userJson) => Student.fromJson(userJson)).toList();

    for(int index = 0;index < users.length; index = index+1){
      if(users[index].image != null)
      images.add(await _supabase
          .storage
          .from('tf-bucket')
          .download(users[index].image!));
      var list = ListTopicsViewModel();
      await list.fetchUserTopics(users[index].id);
      topics.add(list);
      // print("hi");
    }

    }else{
      users = [];
      topics= [];
    }
    notifyListeners();
  }
}