import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:image_picker_widget/image_picker_widget.dart';
import "package:provider/provider.dart";
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:teacher_finder_lebanon/MainViews/AppBarPages/add_session_view.dart';
import 'package:teacher_finder_lebanon/Providers/login_provider.dart';
import 'package:teacher_finder_lebanon/ViewModels/student_teacher_view_model.dart';

import '../Models/Student.dart';
import '../Models/Teacher.dart';

class CurrentSTList extends StatefulWidget {
   CurrentSTList({Key? key}) : super(key: key);

  @override
  State<CurrentSTList> createState() => _CurrentSTListState();
}

class _CurrentSTListState extends State<CurrentSTList> {
List<dynamic> images = [];

getImages(String? path) async{
if(path != null){
  var img =  await Supabase.instance.client
      .storage
      .from('tf-bucket')
      .download(path);
  images.add(img);
}

}

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginProvider>(
      builder: (context, user, child) {
        return StreamBuilder(
          stream: context.watch<StudentTeacherViewModel>().getCurrent(context),
            builder: (_,snapshot) {
              if(snapshot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator(),);
              if (snapshot.data != null)
            return ListView.separated(
                itemBuilder: (BuildContext ctx, int index) {

                  var fetchedUser = snapshot.data?[index]["${user.user is Student ? "Teacher" : "Student"}"];

                  if(fetchedUser != null)
                    return FutureBuilder(
                        future: getImages( fetchedUser["image"]),
                        builder: (context,s) {
                          if(s.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator(),);

                          return ListTile(
                            onTap: (){
                              var s,t;
                              if(user is Student){
                                s = context.read<LoginProvider>().user;
                                t = Teacher.fromJson(fetchedUser);
                              }else{
                                t = user;
                                s = Student.fromJson(fetchedUser);
                              }
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddSession(student: s,teacher: t,)));
                            },
                            title: Row(
                              children: [
                                Expanded(child: Text("${fetchedUser["firstName"]} ${fetchedUser["lastName"]}",
                                style: TextStyle(fontSize: 17),)),
                              ],
                            ),
                            leading: ImagePickerWidget(
                                diameter: 50,
                                initialImage:fetchedUser["image"] == null? Image(image: Svg("assets/profile-logo.svg"),).image : Image.memory(images[index]).image,
                                shape: ImagePickerWidgetShape.circle, // ImagePickerWidgetShape.square
                                isEditable: false
                            ),
                            trailing: Container(
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              width: 100,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Theme.of(context).errorColor
                                  ),
                                  onPressed: () async{
                                    StudentTeacherViewModel vm = StudentTeacherViewModel();
                                    bool success = await vm.remove(snapshot.data[index]["id"]);
                                    if(success){
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${fetchedUser["firstName"]} ${fetchedUser["lastName"]} is no longer your ${
                                          context.read<LoginProvider>().user is Student? "teacher" : "student"
                                      }"),action: SnackBarAction(
                                        label: "Dismiss",
                                        onPressed: () {
                                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                        },
                                      ),));
                                      setState(() {

                                      });
                                    }else{
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error occurred, please try again later"),action: SnackBarAction(
                                        label: "Dismiss",
                                        onPressed: () {
                                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                        },
                                      ),));
                                    }
                                  },
                                  child: Text("Remove",style: TextStyle(fontSize: 13),)
                              ),
                            ),
                          );
                        }
                    );

                  return Center(
                    child: Text("You have no current ${user.user is Student ? "teachers" : "students"}",textAlign: TextAlign.center,style: TextStyle(color: Colors.black,fontSize: 20),),
                  );
                },
                separatorBuilder:(context, index) => Divider(color: Colors.black),
                itemCount: snapshot.data != null ? snapshot.data!.length : 0
            );

            return Center(
              child: Text("We couldn\'t get your ${user.user is Student ? "teachers" : "students"} at the moment",textAlign: TextAlign.center,style: TextStyle(color: Colors.black,fontSize: 20),),
            );

            },
            );

      }
    );
  }
}
