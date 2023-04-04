
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:teacher_finder_lebanon/Widgets/current_st_list_widget.dart';
import 'package:expandable/expandable.dart';

import '../../Widgets/previous_st_list_widget.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: TabBar(
            labelColor: Theme.of(context).primaryColor,
              tabs: [
                Tab(text: "Current Teachers",),
                Tab(text: "Previous Teachers",)
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
