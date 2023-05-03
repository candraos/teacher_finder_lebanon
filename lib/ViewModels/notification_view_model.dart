import 'package:flutter/material.dart';
import 'package:teacher_finder_lebanon/Classes/database_helper.dart';

import '../Models/Notification.dart' as NotificationModel;

class ListNotificationsViewModel with ChangeNotifier{
  List<NotificationViewModel> notifications = [];
  int _newNotifications  = 0;
  int get newNotifications => _newNotifications;
  // NotificationModel.NotificationFactory _notificationFactory = NotificationModel.NotificationFactory();

  void addNotification(NotificationViewModel notificationViewModel){
    try{
      DatabaseHelper helper = DatabaseHelper.instance;
      helper.addNotification(notificationViewModel.notification).then((value)  {
        notifications.add(notificationViewModel);
        _newNotifications = _newNotifications + 1;
        print("_new $_newNotifications");
        print("new $newNotifications");
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