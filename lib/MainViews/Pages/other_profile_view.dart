import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:provider/provider.dart';
import 'package:image_picker_widget/image_picker_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:teacher_finder_lebanon/MainViews/Pages/EditProfile/change_topics_view.dart';
import 'package:teacher_finder_lebanon/MainViews/Pages/EditProfile/edit_profile_view.dart';
import 'package:teacher_finder_lebanon/MainViews/Pages/EditProfile/reviews_view.dart';
import 'package:teacher_finder_lebanon/MainViews/Pages/home_view.dart';
import 'package:teacher_finder_lebanon/Models/Notification.dart';
import 'package:teacher_finder_lebanon/Registration/login_view.dart';
import 'package:teacher_finder_lebanon/ViewModels/connection_view_model.dart';
import 'package:teacher_finder_lebanon/ViewModels/feedback_view_model.dart';
import 'package:teacher_finder_lebanon/ViewModels/topic_vm.dart';
import 'package:teacher_finder_lebanon/Widgets/review_widget.dart';
import 'package:teacher_finder_lebanon/Models/User.dart' as usermodel;
import '../../Models/Connection.dart';
import '../../Models/Student.dart';
import '../../Models/Teacher.dart';
import '../../Providers/login_provider.dart';
import '../../Providers/page_provider.dart';
import '../../Widgets/rating_bar_widget.dart';

class OtherProfile extends StatefulWidget {
  const OtherProfile({Key? key,required this.user, required this.showConnectBtn, required this.notificationId}) : super(key: key);

  final usermodel.User user;
  final bool showConnectBtn;
  final int? notificationId;

  @override
  _OtherProfileState createState() => _OtherProfileState();
}

class _OtherProfileState extends State<OtherProfile> {
  // ListTopicsViewModel _topicsViewModel = ListTopicsViewModel();
  var client = Supabase.instance.client;
  Uint8List? userImage;
  double latitude = 0,longitude = 0;
  _fetchTopics() async{


    if(widget.user.image != null)
     userImage = await client
         .storage
         .from('tf-bucket')
         .download(widget.user.image!);
     await context.read<ListTopicsViewModel>().fetchUserTopics(widget.user.id);

     String table = widget.user is Student ? "Student" : "Teacher";

     final query = await client.from(table).select("latitude,longitude").eq("customid", widget.user.id);

     latitude = query[0]["latitude"];
     longitude = query[0]["longitude"];

  }

@override
  void initState() {

    super.initState();
    _fetchTopics();

  }
  @override
  Widget build(BuildContext context) {
    var _topicsViewModel = context.read<ListTopicsViewModel>();
    return Scaffold(
      body:
           FutureBuilder(
            future: _fetchTopics(),
            builder: (context,snapshot){
              if(snapshot.connectionState == ConnectionState.waiting)
                      return Center(child: CircularProgressIndicator(),);
              else{
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 20,),

                      ImagePickerWidget(
                        diameter: 150,

                        initialImage:widget.user.image == null? Image(image: Svg("assets/profile-logo.svg"),).image : Image.memory(userImage!).image,
                        shape: ImagePickerWidgetShape.circle, // ImagePickerWidgetShape.square
                        isEditable: false,

                      ),

                      // SizedBox(height: 20,),

                      Text("${widget.user.firstName} ${widget.user.lastName}",textAlign: TextAlign.center,style: TextStyle(fontSize: 40),),

                      if(widget.user is Teacher && widget.user.rating != 0)
                        Rating(rating: widget.user.rating!),

                      if(widget.user is Teacher)
                        Text("${widget.user.price} ${widget.user.currency}/Session",textAlign: TextAlign.center,style: TextStyle(fontSize: 20,color: Colors.black.withOpacity(0.5)),),

                      Text("${widget.user.section} Section",textAlign: TextAlign.center,style: TextStyle(fontSize: 20,color: Colors.black.withOpacity(0.5)),),


                      // Text("My Topics >",textAlign: TextAlign.center,style: TextStyle(fontSize: 20,color: Theme.of(context).primaryColor),),

                      SizedBox(height: 20,),

                      Visibility(
                        visible: widget.showConnectBtn,
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          child: ElevatedButton(
                              onPressed: () async{
                                late Connection connection;
                                ConnectionViewModel _connectionViewModel = ConnectionViewModel();
                                usermodel.User user = context.read<LoginProvider>().user;
                                if(user is Student){
                                  connection = Connection.Send(user.id, widget.user.id);
                                }else{
                                  connection = Connection.Send(widget.user.id, user.id);
                                }
                                bool success = await _connectionViewModel.send(connection,context);
                                if(success){
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Connection sent to ${widget.user.firstName} ${widget.user.lastName}")));
                                }else{
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Connection could not be sent")));
                                }
                              },
                              child: Text("Connect")
                          ),
                        ),
                      ),

                      Visibility(
                        visible: !widget.showConnectBtn,
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              SizedBox(width: 10,),
                              Expanded(

                                child: ElevatedButton(
                                    onPressed: ()async{
                                      bool success = await ConnectionViewModel().Accept(widget.notificationId!);
                                      if(success){
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${widget.user.firstName} ${widget.user.lastName} is now your"
                                            "${widget.user is Student ? "Student"  : "Teacher"}"),action: SnackBarAction(
                                          label: "Dismiss",
                                          onPressed: () {
                                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                          },
                                        ),));
                                        context.read<PageProvider>().move(0, Home());
                                        Navigator.popUntil(context, (Route<dynamic> predicate) => predicate.isFirst);
                                      }else{
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error Occurred, please try again later"),action: SnackBarAction(
                                          label: "Dismiss",
                                          onPressed: () {
                                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                          },
                                        ),));

                                      }
                                    },
                                    child: Text("Accept")),
                              ),
                              SizedBox(width: 10,),
                              Expanded(

                                child: ElevatedButton(

                                  onPressed: () async{
                                    bool success = await ConnectionViewModel().Reject(widget.notificationId!);
                                    if(success){
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Connection Rejected"),action: SnackBarAction(
                                        label: "Dismiss",
                                        onPressed: () {
                                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                        },
                                      ),));
                                      context.read<PageProvider>().move(0, Home());
                                      Navigator.popUntil(context, (Route<dynamic> predicate) => predicate.isFirst);
                                    }else{
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error Occurred, please try again later"),action: SnackBarAction(
                                        label: "Dismiss",
                                        onPressed: () {
                                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                        },
                                      ),));

                                    }
                                  },
                                  child: Text("Reject"),
                                  style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).errorColor),),
                              ),
                              SizedBox(width: 10,),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 40,),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (widget.user is Teacher)
                              Text("Topics Teaching",style:TextStyle(fontSize: 25,fontWeight: FontWeight.bold)),
                            if (widget.user is Student)
                              Text("Topics Learning",style:TextStyle(fontSize: 25,fontWeight: FontWeight.bold)),


                          ],
                        ),
                      ),

                      SizedBox(height: 20,),

                      ListView.separated(
                          itemCount: context.watch<ListTopicsViewModel>().userTopics.length,
                          shrinkWrap: true,
                          // padding: EdgeInsets.only(left: 15,bottom: 10),
                          separatorBuilder: (_, index) => Divider(),
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (_,index){
                            print(_topicsViewModel.userTopics[index].topic!.name!);
                            // return Text(topics[index],style: TextStyle(fontSize: 18),);
                            return ListTile(

                              // selectedTileColor: Colors.grey,
                              dense:true,
                              // visualDensity: VisualDensity(horizontal: 0, vertical: -4),

                              title: Text(_topicsViewModel.userTopics[index].topic!.name!,style: TextStyle(fontSize: 20),),);
                          }
                      ),

                      SizedBox(height: 40,),
                      if(widget.user is Teacher)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Reviews",style:TextStyle(fontSize: 25,fontWeight: FontWeight.bold)),
                              GestureDetector(
                                onTap: (){
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => Reviews()));
                                },
                                child: Text("View All >",style: TextStyle(fontSize: 20,color: Theme.of(context).primaryColor),),
                              )
                            ],
                          ),
                        ),
                      if(widget.user is Teacher)
                        SizedBox(height: 20,),
                      if(widget.user is Teacher)
                        FutureBuilder(
                          future: context.read<ListFeedbackViewModel>().get(widget.user.id),
                          builder: (context, snapshot) {
                            if(snapshot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator(),);
                            if(context.read<ListFeedbackViewModel>().feedbacks.length > 0)
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0),
                              child: ReviewWidget(feedback: context.read<ListFeedbackViewModel>().feedbacks[0].feedback,),
                            );
                            return Container();
                          }
                        ),
                      if(widget.user is Teacher)
                        SizedBox(height: 20,),



                    ],
                  ),
                );
              }
            },

          )

    );
  }
}


