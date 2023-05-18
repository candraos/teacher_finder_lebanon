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
import 'package:teacher_finder_lebanon/Providers/login_provider.dart';
import 'package:teacher_finder_lebanon/Registration/login_view.dart';
import 'package:teacher_finder_lebanon/ViewModels/feedback_view_model.dart';
import 'package:teacher_finder_lebanon/ViewModels/topic_vm.dart';
import 'package:teacher_finder_lebanon/Widgets/review_widget.dart';

import '../../Models/Student.dart';
import '../../Models/Teacher.dart';
import '../../Widgets/rating_bar_widget.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  ListTopicsViewModel _topicsViewModel = ListTopicsViewModel();
  var client = Supabase.instance.client;
  Uint8List? userImage;
  var user;
  _fetchTopics() async{
     user = context.read<LoginProvider>().user;
     print(user.image);
    if(user.image != null)
     userImage = await client
         .storage
         .from('tf-bucket')
         .download(user.image);
     await _topicsViewModel.fetchUserTopics(context.read<LoginProvider>().user.id);

  }

@override
  void initState() {

    super.initState();
    _fetchTopics();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
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

                    initialImage:context.watch<LoginProvider>().user.image == null? Image(image: Svg("assets/profile-logo.svg"),).image : Image.memory(userImage!).image,
                    shape: ImagePickerWidgetShape.circle, // ImagePickerWidgetShape.square
                    isEditable: true,
                    onChange: (File file) async{

                      try{
                        await client.storage
                            .from("tf-bucket")
                            .upload(file.path.split("/").last, file)
                            .then((value) async {
                          value = value.split("/").last;
                          String table = "";
                          user is Student? table = "Student" : table = "Teacher";
                          await client.from(table)
                              .update({"image" : value})
                              .match({ "customid" : user.id });
                          final UserResponse res = await client.auth.updateUser(
                            UserAttributes(
                                data: {
                                  "image" : value
                                }
                            ),
                          );
                          user.image = value;
                          userImage = await client
                              .storage
                              .from('tf-bucket')
                              .download(user.image);

                          context.read<LoginProvider>().update(user);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Profile Updated Successfully!"),action: SnackBarAction(
                            label: "Dismiss",
                            onPressed: () {
                              ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            },
                          ),));
                        });
                        setState(() {

                        });
                      }catch(e){
                        print(e);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Couldn\'t update your profile at the moment, please try again later"),action: SnackBarAction(
                          label: "Dismiss",
                          onPressed: () {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          },
                        ),));
                      }
                      print("I changed the file to: ${file.path}");
                    },
                  ),

                  // SizedBox(height: 20,),

                  Text("${context.watch<LoginProvider>().user.firstName} ${context.watch<LoginProvider>().user.lastName}",textAlign: TextAlign.center,style: TextStyle(fontSize: 40),),

                  if(context.read<LoginProvider>().user is Teacher && context.read<LoginProvider>().user.rating != 0)
                    Rating(rating: context.watch<LoginProvider>().user.rating!),

                  if(context.read<LoginProvider>().user is Teacher)
                    Text("${context.watch<LoginProvider>().user.price} ${context.watch<LoginProvider>().user.currency}/Session",textAlign: TextAlign.center,style: TextStyle(fontSize: 20,color: Colors.black.withOpacity(0.5)),),

                  Text("${context.watch<LoginProvider>().user.section} Section",textAlign: TextAlign.center,style: TextStyle(fontSize: 20,color: Colors.black.withOpacity(0.5)),),


                  // Text("My Topics >",textAlign: TextAlign.center,style: TextStyle(fontSize: 20,color: Theme.of(context).primaryColor),),

                  SizedBox(height: 20,),

                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: ElevatedButton(
                        onPressed: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditProfile()));
                        },
                        child: Text("Edit Profile")
                    ),
                  ),

                  SizedBox(height: 10,),

                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).errorColor
                        ),
                        onPressed: () async{

                          showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: Text("Logout?"),
                                content: Text("Are you sure you want to logout?"),
                                actions: [
                                  TextButton(
                                      onPressed: () async{
                                        final supabase = Supabase.instance.client;
                                        await supabase.auth.signOut();
                                        final _storage =  FlutterSecureStorage();
                                        await _storage.deleteAll();
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Logged out successfully"),action: SnackBarAction(
                                          label: "Dismiss",
                                          onPressed: () {
                                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                          },
                                        ),));
                                        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Login()),(r) => false);

                                      },
                                      child: Text("yes")),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("no")),
                                ],
                              )
                          );

                        },
                        child: Text("Logout")
                    ),
                  ),

                  SizedBox(height: 40,),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (context.watch<LoginProvider>().user is Teacher)
                          Text("Topics Teaching",style:TextStyle(fontSize: 25,fontWeight: FontWeight.bold)),
                        if (context.watch<LoginProvider>().user is Student)
                          Text("Topics Learning",style:TextStyle(fontSize: 25,fontWeight: FontWeight.bold)),

                        GestureDetector(
                          onTap: (){
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChangeTopics(selectedItems: _topicsViewModel.userTopics,)));
                          },
                          child: Text("Edit >",style: TextStyle(fontSize: 20,color: Theme.of(context).primaryColor),),
                        )
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
                        // return Text(topics[index],style: TextStyle(fontSize: 18),);
                        return ListTile(

                          // selectedTileColor: Colors.grey,
                          dense:true,
                          // visualDensity: VisualDensity(horizontal: 0, vertical: -4),

                          title: Text(_topicsViewModel.userTopics[index].topic!.name!,style: TextStyle(fontSize: 20),),);
                      }
                  ),

                  SizedBox(height: 40,),
                  if(context.read<LoginProvider>().user is Teacher)
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
                  if(context.read<LoginProvider>().user is Teacher)
                    SizedBox(height: 20,),
                  if(context.read<LoginProvider>().user is Teacher)
                    FutureBuilder(
                      future: context.read<ListFeedbackViewModel>().get(context.read<LoginProvider>().user.id),
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
                  if(context.read<LoginProvider>().user is Teacher)
                    SizedBox(height: 20,),
                ],
              ),
            );
          }
        },

      ),
    );
  }
}


