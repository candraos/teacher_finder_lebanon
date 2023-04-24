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

 factory Notification.fromMap(Map<String,dynamic> json) =>  Notification(
   json["id"],
     json["title"],
     json["description"],
     json["type"],
     json["user"],
);

  Map<String,dynamic> toMap(){
    return {

      'title':title,
      'description':description,
      'type':type.toString(),
      'user':user.id,

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