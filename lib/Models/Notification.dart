import 'User.dart';
import 'Student.dart';
class Notification{
  String title = "";
  String description = "";
  String type = "";
  late User user;

  Notification(this.title, this.description, this.type, this.user);
}

class NotificationFactory{
  static Notification connectionNotification(User user){
    return Notification(
    "${user.firstName} ${user.lastName} wants to be your ${user is Student? "student" : "teacher"}",
        "",
        "Connection",
        user);
  }
}