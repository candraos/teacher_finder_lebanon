import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:image_picker_widget/image_picker_widget.dart';
import 'package:teacher_finder_lebanon/MainViews/Pages/search_view.dart';
import 'package:teacher_finder_lebanon/Models/Connection.dart';
import 'package:teacher_finder_lebanon/Providers/login_provider.dart';
import 'package:teacher_finder_lebanon/ViewModels/connection_view_model.dart';
import 'package:teacher_finder_lebanon/ViewModels/search_vm.dart';
import 'package:teacher_finder_lebanon/ViewModels/topic_vm.dart';
import 'package:provider/provider.dart';

import '../Models/Student.dart';
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
  final ConnectionViewModel _connectionViewModel = ConnectionViewModel();
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
                  if(context.watch<SearchViewModel>().images.isNotEmpty)
                  ImagePickerWidget(
                    diameter: 70,

                    initialImage:context.watch<SearchViewModel>().images[i] == null? Image(image: Svg("assets/profile-logo.svg"),).image : Image.memory(context.watch<SearchViewModel>().images[i]).image,
                    shape: ImagePickerWidgetShape.circle, // ImagePickerWidgetShape.square
                    isEditable: false,

                  )
                  else
                  ImagePickerWidget(
                  diameter: 70,

                  initialImage:Image(image: Svg("assets/profile-logo.svg"),).image,
                  shape: ImagePickerWidgetShape.circle, // ImagePickerWidgetShape.square
                  isEditable: false,

                  ),
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
                        onPressed: () async{
                          late Connection connection;
                          User user = context.read<LoginProvider>().user;
                          if(user is Student){
                            connection = Connection.Send(user.id, widget.users[i].id);
                          }else{
                            connection = Connection.Send(widget.users[i].id, user.id);
                          }
                          bool success = await _connectionViewModel.send(connection,context);
                          if(success){
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Connection sent to ${widget.users[i].firstName} ${widget.users[i].lastName}")));
                          }else{
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Connection could not be sent")));
                          }
                        },
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
