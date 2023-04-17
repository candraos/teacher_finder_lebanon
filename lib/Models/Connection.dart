import 'User.dart';

class Connection{
  bool isAccepted = false;
  bool isActive = false;
  late String studentID;
  late String TeacherID;
  int id = 0;
  User? user;

  Connection.Response(
      this.isAccepted, this.isActive, this.studentID, this.TeacherID);

  Connection.Send(this.studentID, this.TeacherID);

  Connection.all(
      this.id, this.isAccepted, this.isActive, this.studentID, this.TeacherID);
Connection();
  Connection.fromJson(Map<String,dynamic> json){
    id = json["id"];
    isAccepted = json["isAccepted"];
    isActive = json["isActive"];
    studentID = json["studentID"];
    TeacherID = json["teacherID"];

  }
}