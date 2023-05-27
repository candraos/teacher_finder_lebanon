import 'Student.dart';
import 'Teacher.dart';

class Session{
  late Student student;
  late Teacher teacher;
  int? id;
  String title = "";
  String description = "";
  late DateTime date,startTime,endTime;

  Session.fromJson(Map<String,dynamic> json){
    print(json);
    id = json['id'];
    title = json['title'];
    description = json['description'];
    date = DateTime.parse(json["date"]);
    startTime = DateTime.parse("${date.toString().split(" ")[0]} ${json['startTime']}");
    endTime = DateTime.parse("${date.toString().split(" ")[0]} ${json['endTime']}");
    student = Student.fromJson(json['Student']);
    teacher = Teacher.fromJson(json['Teacher']);
  }

  Map<String, dynamic> toJson() => {
    'studentID' : student.id,
    'teacherID' : teacher.id,
    if(id != null) 'id' : id,
    'title' : title,
    'description' : description,
    "startTime" : startTime.toString(),
    "endTime" : endTime.toString(),
    "date" : date.toString()
  };

  Session(
      {required this.title, required this.description, required this.date, required this.startTime, required this.endTime,required this.student,required this.teacher});
}