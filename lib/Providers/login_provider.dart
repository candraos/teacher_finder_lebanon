import 'package:flutter/material.dart';
import 'package:teacher_finder_lebanon/Models/Topic.dart';

import '../Models/User.dart';

class LoginProvider with ChangeNotifier{
  late User user;
  List<Topic> topics = [];

  void update(User user){
    this.user = user;
    notifyListeners();
  }
}