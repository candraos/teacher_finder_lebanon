import 'package:flutter/material.dart';
import 'package:teacher_finder_lebanon/MainViews/Pages/search_view.dart';
import 'package:teacher_finder_lebanon/ViewModels/topic_vm.dart';

import '../Models/Teacher.dart';
import '../Models/User.dart';

class SearchList extends StatefulWidget {
   SearchList({Key? key,required this.users,required this.topics}) : super(key: key);

  List<User> users = [];
  List<ListTopicsViewModel> topics;

  @override
  State<SearchList> createState() => _SearchListState();
}

class _SearchListState extends State<SearchList> {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        children: List.generate(widget.users.length,(i){
          String userTopics = "";
          widget.topics.forEach((element) {
            element.userTopics.forEach((topic) {
              if(!userTopics.contains(topic.topic!.name!))
              userTopics = userTopics + topic.topic!.name! + " ";
            });

          });
          return Card(
            elevation: 5,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Image.asset("assets/profilepic.png",height: 70,width: 70,),
                  Text("${widget.users[i].firstName} ${widget.users[i].lastName}",style: TextStyle(fontSize: 20),),
                  // for(int index = 0;index < topics.length; index++)
                  Text(userTopics,textAlign: TextAlign.center,style: TextStyle(fontSize: 16),),
                  if(widget.users[i] is Teacher) Text("${widget.users[i].price} ${widget.users[i].currency}/session",style: TextStyle(fontSize: 16,color: Colors.black.withOpacity(0.5)),),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize: Size.fromHeight(30)
                        ),
                        onPressed: (){},
                        child: Text("connect")
                    ),
                  )
                ],
              ),
            ),
          );
        })
    );
  }
}
