import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:teacher_finder_lebanon/Classes/database_helper.dart';

import '../Models/Notification.dart' as NotificationModel;
import 'package:provider/provider.dart';

class ListNotificationsViewModel with ChangeNotifier{
  List<NotificationViewModel> notifications = [];
  int newNotifications  = 0;
  // NotificationModel.NotificationFactory _notificationFactory = NotificationModel.NotificationFactory();

  void addNotification(NotificationViewModel notificationViewModel){
    DatabaseHelper helper = DatabaseHelper.instance;
    helper.addNotification(notificationViewModel.notification);
    notifications.add(notificationViewModel);
    newNotifications = newNotifications + 1;
    notifyListeners();
  }


}

class NotificationViewModel{
  late NotificationModel.Notification notification;

  NotificationViewModel(this.notification);


}