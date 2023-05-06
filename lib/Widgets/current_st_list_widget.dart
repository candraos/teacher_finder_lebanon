import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:image_picker_widget/image_picker_widget.dart';
import "package:provider/provider.dart";
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:teacher_finder_lebanon/Providers/login_provider.dart';
import 'package:teacher_finder_lebanon/ViewModels/student_teacher_view_model.dart';

import '../Models/Student.dart';

class CurrentSTList extends StatefulWidget {
   CurrentSTList({Key? key}) : super(key: key);

  @override
  State<CurrentSTList> createState() => _CurrentSTListState();
}

class _CurrentSTListState extends State<CurrentSTList> {
List<dynamic> images = [];

getImages(String path) async{

    var img =  await Supabase.instance.client
        .storage
        .from('tf-bucket')
        .download(path);
images.add(img);
}

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: context.watch<StudentTeacherViewModel>().getCurrent(context),
        builder: (_,snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator(),);
          if (snapshot.data != null)
        return ListView.separated(
            itemBuilder: (BuildContext ctx, int index) {
              var user = snapshot.data?[index]["${context.read<LoginProvider>().user is Student ? "Teacher" : "Student"}"];


              return FutureBuilder(
                future: getImages( user["image"]),
                builder: (context,s) {
                  if(s.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator(),);

                  return ListTile(
                    title: Row(
                      children: [
                        Expanded(child: Text("${user["firstName"]} ${user["lastName"]}")),
                      ],
                    ),
                    leading: ImagePickerWidget(
                        diameter: 50,
                        initialImage:user["image"] == null? Image(image: Svg("assets/profile-logo.svg"),).image : Image.memory(images[index]).image,
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
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${user["firstName"]} ${user["lastName"]} is no longer your ${
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
            },
            separatorBuilder:(context, index) => Divider(color: Colors.black),
            itemCount: snapshot.data != null ? snapshot.data!.length : 0
        );

        return Center(
          child: Text("You have no current teachers",style: TextStyle(color: Colors.black),),
        );

        },
        );
  }
}
