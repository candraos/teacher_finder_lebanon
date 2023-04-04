import 'package:teacher_finder_lebanon/Models/Topic.dart';
import 'package:teacher_finder_lebanon/Models/User.dart';

import 'Teacher.dart';

class SearchResult{
  late User user;
  List<Topic> topics = [];

  SearchResult.fromJson(Map<String,dynamic> json){
    user.id = json["customid"];
    user.firstName = json["firstName"];
    user.lastName = json["lastName"];
    user.email = json["email"];
    user.section = json["section"];
    user.latitude = json["latitude"];
    user.longitude = json["longitude"];
    user.image = json["image"];
    if(user is Teacher){
      user.currency = json["currency"];
      user.price = json["price"];
      user.rating = json["rating"];
    }

  }
}