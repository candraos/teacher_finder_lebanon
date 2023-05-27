import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:teacher_finder_lebanon/Providers/page_provider.dart';
import 'package:teacher_finder_lebanon/Widgets/CustomAppBar.dart';

import 'package:provider/provider.dart';
import '../Models/Student.dart';
import '../Providers/login_provider.dart';
import '../Providers/session_provider.dart';



class Navigation extends StatefulWidget {
   Navigation({Key? key}) : super(key: key);
  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {



  @override
  void initState() {
    super.initState();


  }

  double iconSize = 35;

  @override
  Widget build(BuildContext context) {



    return Scaffold(

      appBar: CustomAppBar(
        title: "Teacher Finder",
        calendarIcon: Icons.calendar_today_outlined,
        notificationIcon: Icons.notifications,
      ),

        body: context.watch<PageProvider>().page,

      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Theme.of(context).primaryColor
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          // backgroundColor: Theme.of(context).primaryColor,
          currentIndex: context.watch<PageProvider>().currentIndex,
          unselectedItemColor: Colors.white,
          selectedItemColor: Colors.white,
          showUnselectedLabels: false,
          onTap: (value) {
            context.read<PageProvider>().changeIndex(value);
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home,size: iconSize),
              label: "Home"
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.search,size: iconSize),
                label: "Search"
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.chat_outlined,size: iconSize),
                label: "Conversations"
            ),
            BottomNavigationBarItem(
                icon: SvgPicture.asset("assets/profile-logo.svg",width: iconSize,height: iconSize,),
                label: "Profile"
            ),
          ],
        ),
      ),
    );
  }
}
