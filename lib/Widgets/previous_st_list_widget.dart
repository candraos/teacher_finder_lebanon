import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:image_picker_widget/image_picker_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:teacher_finder_lebanon/MainViews/Pages/feedback_view.dart';
import 'package:provider/provider.dart';
import 'package:teacher_finder_lebanon/Models/Teacher.dart';

import '../Models/Student.dart';
import '../Providers/login_provider.dart';
import '../ViewModels/student_teacher_view_model.dart';

class PreviousSTList extends StatefulWidget {
   PreviousSTList({Key? key}) : super(key: key);

  @override
  State<PreviousSTList> createState() => _PreviousSTListState();
}

class _PreviousSTListState extends State<PreviousSTList> {
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
    return StreamBuilder(
      stream: context.watch<StudentTeacherViewModel>().getPrevious(context),
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
                          Expanded(child: Text("${user["firstName"]} ${user["lastName"]}",
                            style: TextStyle(fontSize: 17),)),
                        ],
                      ),
                      leading: ImagePickerWidget(
                          diameter: 50,
                          initialImage:user["image"] == null? Image(image: Svg("assets/profile-logo.svg"),).image : Image.memory(images[index]).image,
                          shape: ImagePickerWidgetShape.circle, // ImagePickerWidgetShape.square
                          isEditable: false
                      ),
                      trailing:context.read<LoginProvider>().user is Student ? Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        width: 100,
                        child: ElevatedButton(

                            onPressed: (){

                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => SubmitFeedback(student: context.read<LoginProvider>().user as Student, teacher: Teacher.fromJson(user),)));
                            },
                            child: Text("Feedback",style: TextStyle(fontSize: 13),)
                        ),
                      )
                    : null,
                    );
                  }
              );
            },
            separatorBuilder:(context, index) => Divider(color: Colors.black),
            itemCount: snapshot.data != null ? snapshot.data!.length : 0
        );

        return Center(
          child: Text("You have no previous teachers",style: TextStyle(color: Colors.black),),
        );

      },
    );
  }
}
