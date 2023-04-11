import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';
import 'package:teacher_finder_lebanon/Providers/login_provider.dart';
import 'package:teacher_finder_lebanon/ViewModels/topic_vm.dart';

import '../Models/Student.dart';

class EditProfileViewModel{
  final _supabase = Supabase.instance.client;

  Future<bool> updateProfile(String firstName,String lastName, String section,double amount,BuildContext context) async{
    try{
      String table = "";
      var user = context.read<LoginProvider>().user;
      user is Student? table = "Student" : table = "Teacher";
      final response = await _supabase.from(table).update({
        "firstName" : firstName,
        "lastName" : lastName,
        "section" : section,
        if(amount != 0)
          "price" : amount
      }).match({
        "customid": user.id
      });
      user.firstName = firstName;
      user.lastName = lastName;
      user.section = section;
      if(amount != 0) user.price = amount;
      context.read<LoginProvider>().update(user);
      return true;
    }catch(e){
      print(e);
      return false;
    }
  }

  Future<bool> updateTopics(List<TopicViewModel> topics,BuildContext context) async{
    try{
      var user = context.read<LoginProvider>().user;
      List<Map<String,dynamic>> data = [];
      topics.forEach((topic) {
        data.add({
          "userID" : user.id,
          "topicID" : topic.topic!.id
        });
      });
      final response = await _supabase.from("UserTopic").delete().match({
        "userID" : user.id
      });
      await _supabase.from("UserTopic").insert(data);
      await context.read<ListTopicsViewModel>().fetchUserTopics(user.id);
      return true;
    }catch(e){
      print(e);
      return false;
    }
  }
}