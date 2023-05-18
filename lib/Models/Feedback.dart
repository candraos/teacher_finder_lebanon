
import 'package:teacher_finder_lebanon/Models/Student.dart';
import 'package:teacher_finder_lebanon/Models/Teacher.dart';
import 'package:teacher_finder_lebanon/Models/User.dart';

class FeedbackModel{
  late User student;
  late User teacher;
  int? id;
  double rating = 0;
  String description = '';
  String date = '';

  FeedbackModel({
    required this.teacher,
    required this.student,
    this.id,
    required this.rating,
    required this.description,
    this.date = ''

});

  FeedbackModel.fromJson(Map<String,dynamic> json){
    id = json['id'];
    rating = json['rating'];
    description = json['description'];
    date = json['created_at'];
    date = date.split('T')[0];
    student = Student.fromJson(json['Student']);
    teacher = Teacher.fromJson(json['Teacher']);

  }

  Map<String, dynamic> toJson() => {
      'studentID' : student.id,
      'teacherID' : teacher.id,
       if(id != null) 'id' : id,
      'rating' : rating,
      'description' : description
    };
  }


