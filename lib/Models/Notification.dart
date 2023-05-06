
import 'package:teacher_finder_lebanon/ViewModels/user_vm.dart';
import 'package:provider/provider.dart';
import 'Teacher.dart';
import 'User.dart';
import 'Student.dart';

enum Type {Connection}

class Notification{
   int? id;
  String title = "";
  String description = "";
  late Type type;
  bool seen = false;
  bool clicked = false;
  late User user;

  Notification(this.id, this.title, this.description, this.type, this.user);

 factory Notification.fromMap(Map<String,dynamic> json) {

   late Type type;
   switch (json["type"]){
     case "Type.Connection" : type = Type.Connection; break;
   }
   late User user;
   json["role"] == "Student" ? user = Student() : user = Teacher();
   user.firstName = json["firstName"];
   user.lastName = json["lastName"];
   user.image = json["image"];

   return Notification(
     json["id"],
     json["title"],
     json["description"],
     type,
     user,
   );
 }

  Map<String,dynamic> toMap(){
    return {
      "id" : id,
      'title':title,
      'description':description,
      'type':type.toString(),
      'user':user.id,
      "firstName" : user.firstName,
      "lastName" : user.lastName,
      "image" : user.image,
      "role" : user is Student ? "Student" : "Teacher"
    };
  }
}

// class NotificationFactory{
//   static Notification connectionNotification(User user){
//     return Notification(
//     "${user.firstName} ${user.lastName} wants to be your ${user is Student? "student" : "teacher"}",
//         "",
//         Type.Connection,
//         user);
//   }
// }