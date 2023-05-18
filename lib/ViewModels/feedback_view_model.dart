import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:teacher_finder_lebanon/Models/Feedback.dart';



class ListFeedbackViewModel with ChangeNotifier{
  List<FeedbackViewModel> feedbacks = [];
  final client = Supabase.instance.client;


  Future<void> get(String id) async{
    try{
      final result = await client.from("Feedback").select("*,Student!inner(*),Teacher!inner(*)").eq("teacherID", id);
      feedbacks = (result as List<dynamic>).map((feedbackJson) => FeedbackViewModel(FeedbackModel.fromJson(feedbackJson))).toList();
    }catch(e){
      print("Exception $e");
      feedbacks = [];
    }
  }
  
}


class FeedbackViewModel{
  final client = Supabase.instance.client;
  late FeedbackModel feedback;

  setRating(double rating){
    feedback.rating = rating;
  }

  FeedbackViewModel(this.feedback);
  
  Future<bool> add() async{
    try{
      await client.from("Feedback").insert(feedback.toJson());
      return true;
    }catch(e){
      return false;
    }
  }
}