import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:teacher_finder_lebanon/Providers/page_provider.dart';
import 'package:provider/provider.dart';
import 'package:teacher_finder_lebanon/ViewModels/notification_view_model.dart';

import '../MainViews/AppBarPages/calendar_view.dart';
import '../MainViews/AppBarPages/notifications_view.dart';
import '../Models/Student.dart';
import '../Models/Teacher.dart';
import '../Providers/login_provider.dart';
import '../ViewModels/connection_view_model.dart';
import '../ViewModels/topic_vm.dart';


class CustomAppBar extends StatefulWidget implements PreferredSizeWidget{
  CustomAppBar({Key? key,required this.title,required this.calendarIcon, required this.notificationIcon}) : super(key: key);

  String title;
    IconData calendarIcon;
   IconData notificationIcon;

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(60);
}
int newNotifications = 0;
class _CustomAppBarState extends State<CustomAppBar> {



  initialise() async{
    final _storage =  FlutterSecureStorage();
    ConnectionViewModel _connectionViewModel = ConnectionViewModel();
    String? currency = await _storage.read(key: "currency");
    var user;
    if(currency != null){
      Teacher teacher = Teacher();
      user = await teacher.fromStorage();
    }else{
      Student student = Student();
      user = await student.fromStorage();
    }
    context.read<LoginProvider>().update(user);
    await context.read<ListTopicsViewModel>().fetchUserTopics(user.id);
    int notifications = await _connectionViewModel.fetch(context);
    setState(() {
      newNotifications = notifications;
    });

  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance
        .addPostFrameCallback((_) => initialise());

    // WidgetsFlutterBinding.ensureInitialized();
    // initialise();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Text(widget.title),

      actions: [
        IconButton(
          onPressed: () => context.read<PageProvider>().changePage(Calendar()),
            icon: Icon(widget.calendarIcon)
        ),
        // SizedBox(width: 10,),

          IconButton(
              onPressed: () => context.read<PageProvider>().changePage(Notifications()),
              icon: Badge(
                  showBadge: context.watch<ListNotificationsViewModel>().newNotifications != 0,
                  position: BadgePosition.topEnd(top: 0, end: 7),
                  badgeContent:Text("${context.watch<ListNotificationsViewModel>().newNotifications}",style: TextStyle(color: Colors.white),),
                  child: Icon(widget.notificationIcon,))
          ),

        SizedBox(width: 15,),
      ],

    );
  }
}
