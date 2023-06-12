
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:teacher_finder_lebanon/Models/Student.dart';
import 'package:teacher_finder_lebanon/Widgets/current_st_list_widget.dart';
import 'package:expandable/expandable.dart';
import 'package:provider/provider.dart';

import '../../Models/Teacher.dart';
import '../../Providers/login_provider.dart';
import '../../Providers/session_provider.dart';
import '../../Widgets/previous_st_list_widget.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  initialise()async{
    if(context.read<LoginProvider>().user == null){
      final storage = FlutterSecureStorage();
      String? c = await storage.read(key: "currency");
      if(c != null){
        context.read<LoginProvider>().user = await Teacher().fromStorage();
      }else{
        context.read<LoginProvider>().user = await Student().fromStorage();

      }
    }
setState(() {

});
  }
@override
  void initState() {
    super.initState();
    initialise();
  }
  @override
  Widget build(BuildContext context) {
    var user = context.read<LoginProvider>().user;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: TabBar(
            labelColor: Theme.of(context).primaryColor,
              tabs: [
                Tab(text: "Current ${user is Student ? "Teachers" : "Students"}",),
                Tab(text: "Previous ${user is Student ? "Teachers" : "Students"}",)
              ]
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [

              Expanded(
                child: TabBarView(
                    children: [
                      CurrentSTList(),
                      PreviousSTList(),
                ]),
              )
              

            ],
          ),
        ),
      ),
    );
  }
}
