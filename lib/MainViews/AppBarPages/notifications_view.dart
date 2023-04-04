import 'package:flutter/material.dart';

import '../../Widgets/request_widget.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.separated(
        shrinkWrap: true,

          itemBuilder: (_, index){
            if(index == 0){
              return RequestWidget();
            }
            return ListTile(
              title: Text("Notification number $index",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
              subtitle: Text("this is the description of the notification notification notification notification",style: TextStyle(fontSize: 20),),
            );
          },
          separatorBuilder: (_, index) => Divider(thickness: 2,),
          itemCount: 40)
    );
  }
}
