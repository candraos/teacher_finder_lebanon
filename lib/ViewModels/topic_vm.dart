import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:teacher_finder_lebanon/Models/Topic.dart';
import 'package:flutter/material.dart';

class ListTopicsViewModel with ChangeNotifier{
  List<TopicViewModel> topics = [];
  List<TopicViewModel> userTopics = [];
  final supabase = Supabase.instance.client;
  
  Future<void> fetchTopics() async{

    var data = await supabase
        .from('Topic')
        .select("id,name");
    topics = (data as List<dynamic>).map((topicJson) => TopicViewModel(Topic.fromJson(topicJson))).toList();
    topics.sort((a, b) => a.topic!.name!.compareTo(b.topic!.name!));
    notifyListeners();
  }
int topicIndex(Topic topic){
    for(int i=0;i<topics.length;i++) {
      if(topics[i].topic!.id == topic.id){
        return i;
      }
    }
return -1;
}
  Future<void> fetchUserTopics(String userid) async{

    var data = await supabase
        .from('Topic')
        .select("id,name,UserTopic!inner(*)")
    .eq("UserTopic.userID", userid);

    userTopics = (data as List<dynamic>).map((topicJson) => TopicViewModel(Topic.fromJson(topicJson))).toList();
    notifyListeners();
  }
  
  Future<void> addTopicsToUser(var userID,List<int> topics) async{
    topics.forEach((topic) async {
      await supabase
          .from('UserTopic')
          .insert({'topicID': topic, 'userID': userID});
    });

  }
}

class TopicViewModel {
  Topic? topic;

  TopicViewModel(this.topic);
}