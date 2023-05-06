import 'package:flutter/material.dart';
import 'package:teacher_finder_lebanon/Classes/database_helper.dart';

import '../Models/Notification.dart' as NotificationModel;

class ListNotificationsViewModel with ChangeNotifier{
  List<NotificationViewModel> notifications = [];
  int _newNotifications  = 0;
  int get newNotifications => _newNotifications;
  // NotificationModel.NotificationFactory _notificationFactory = NotificationModel.NotificationFactory();


  Future getNotifications() async{
    notifications.clear();
    var notificationsList = await DatabaseHelper.instance.getNotifications();
    notificationsList.forEach((n) { notifications.add(NotificationViewModel(n));});
  }

  removeNotification(int id){
    notifications.removeWhere((n) => n.notification.id == id);
    notifyListeners();
  }

  Future addNotification(NotificationViewModel notificationViewModel) async{
    try{
      DatabaseHelper helper = DatabaseHelper.instance;
      await helper.addNotification(notificationViewModel.notification).then((value)  {
        notifications.add(notificationViewModel);
        _newNotifications = _newNotifications + 1;
        notifyListeners();
      });

    }catch(e){
      print("Exception in notifications: $e");
    }

  }


}

class NotificationViewModel{
  late NotificationModel.Notification notification;

  NotificationViewModel(this.notification);


}