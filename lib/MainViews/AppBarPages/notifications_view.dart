import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teacher_finder_lebanon/MainViews/Pages/other_profile_view.dart';
import '../../Classes/database_helper.dart';
import '../../ViewModels/notification_view_model.dart';
import '../../Widgets/request_widget.dart';
import 'package:teacher_finder_lebanon/Models/Notification.dart' as NotificationModel;

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {

  // ListNotificationsViewModel _listNotificationsViewModel = ListNotificationsViewModel();
  // List<NotificationModel.Notification> _notifications = [];
  //
  refresh() {
    setState(() {});
  }
  initialise() async{
    await context.read<ListNotificationsViewModel>().getNotifications();
    setState(() {

    });
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance
        .addPostFrameCallback((_) => initialise());

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: ListView.separated(
        shrinkWrap: true,

          itemBuilder: (_, index){
          var vm = context.watch<ListNotificationsViewModel>();
          NotificationModel.Notification notification = vm.notifications[index].notification;
            if(notification.type == NotificationModel.Type.Connection){
              return GestureDetector(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => OtherProfile(user: notification.user)));
                },
                  child: RequestWidget(notification: notification,notifyParent: refresh,));
            }
            return ListTile(
              title: Text("Notification number $index",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
              subtitle: Text("this is the description of the notification notification notification notification",style: TextStyle(fontSize: 20),),
            );
          },
          separatorBuilder: (_, index) => Divider(thickness: 2,),
          itemCount: context.watch<ListNotificationsViewModel>().notifications.length)
    );
  }
}
