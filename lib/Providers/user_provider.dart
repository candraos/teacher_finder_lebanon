import 'package:flutter/material.dart';
import 'package:teacher_finder_lebanon/Models/Student.dart';
import 'package:teacher_finder_lebanon/Models/Teacher.dart';

import '../Models/User.dart';

class UserProvider with ChangeNotifier{
  late User user;
  double price = 0;
  String currency = "";
  List<int> topics = [];

  void update(User user){
    this.user = user;
    notifyListeners();
  }
  void initialise(String role){
    if(role == "Student") {
      user =  Student();
    } else if (role == "Teacher") {
      user =  Teacher();
    }
    notifyListeners();
  }

  void updateSection(String section){
    user.section = section;
    notifyListeners();
  }

  void updateTopics(List<int> topics){
    this.topics = topics;
    notifyListeners();
  }

  void updatePrice(double price,String currency){
    this.price = price;
    this.currency = currency;
    notifyListeners();
  }

  void updateLocation(double latitude, double longitude){
    user.latitude = latitude;
    user.longitude = longitude;
    notifyListeners();
  }

  void updateInfo(String firstName,String lastName, String email, String password){
    user.firstName = firstName;
    user.lastName = lastName;
    user.email = email;
    user.password = password;
    notifyListeners();
  }
}