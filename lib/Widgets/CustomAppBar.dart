import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:teacher_finder_lebanon/Providers/page_provider.dart';
import 'package:provider/provider.dart';
import 'package:teacher_finder_lebanon/ViewModels/notification_view_model.dart';

import '../MainViews/AppBarPages/calendar_view.dart';
import '../MainViews/AppBarPages/notifications_view.dart';


class CustomAppBar extends StatelessWidget implements PreferredSizeWidget{
  CustomAppBar({Key? key,required this.title,required this.calendarIcon, required this.notificationIcon}) : super(key: key);

  String title;
    IconData calendarIcon;
   IconData notificationIcon;
   @override
  Size get preferredSize => Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Text(title),

      actions: [
        IconButton(
          onPressed: () => context.read<PageProvider>().changePage(Calendar()),
            icon: Icon(calendarIcon)
        ),
        // SizedBox(width: 10,),

          Badge(
            badgeStyle: BadgeStyle(
              padding: EdgeInsets.all(5),
            ),
            position: BadgePosition.topEnd(top: 10, end: 12),
            badgeContent:context.watch<ListNotificationsViewModel>().newNotifications != 0 ? Text("${context.watch<ListNotificationsViewModel>().newNotifications}") : null,
            child: IconButton(
                onPressed: () => context.read<PageProvider>().changePage(Notifications()),
                icon: Icon(notificationIcon)
            ),
          ),

        SizedBox(width: 15,),
      ],

    );
  }
}
