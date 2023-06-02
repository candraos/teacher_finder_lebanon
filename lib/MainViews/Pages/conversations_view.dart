import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:image_picker_widget/image_picker_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:teacher_finder_lebanon/Classes/Services/message_service.dart';
import 'package:provider/provider.dart';
import 'package:teacher_finder_lebanon/Providers/login_provider.dart';
import 'package:teacher_finder_lebanon/ViewModels/student_teacher_view_model.dart';
import 'package:teacher_finder_lebanon/Widgets/chat_bubble.dart';
import 'package:teacher_finder_lebanon/Widgets/chat_widget.dart';
import '../../Models/Student.dart';
import '../../Models/Teacher.dart';
import '../../Models/message.dart';
class Conversations extends StatefulWidget {
  const Conversations({Key? key}) : super(key: key);

  @override
  _ConversationsState createState() => _ConversationsState();
}

class _ConversationsState extends State<Conversations> {
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
   return Scaffold(
     body: Consumer<LoginProvider>(
       builder: (context, user, child){
         return StreamBuilder(
           stream: context.watch<StudentTeacherViewModel>().getCurrent(context),
             builder: (context, snapshot) {
             if(snapshot.connectionState != ConnectionState.waiting)
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
                                 Navigator.of(context).push(MaterialPageRoute(builder: (context) => Chat(
                                   userToId: fetchedUser["customid"],
                                   firstName: fetchedUser["firstName"],
                                   lastName: fetchedUser["lastName"],
                                   image: fetchedUser["image"] == null? Image(image: Svg("assets/profile-logo.svg"),).image : Image.memory(images[index]).image,
                                 )
                                 ));
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

                             );
                           }
                       );

                     return Container();
                   },
                   separatorBuilder:(context, index) => Divider(color: Colors.black),
                   itemCount: snapshot.data != null ? snapshot.data!.length : 0
               );

             return Center(child: CircularProgressIndicator(),);
             }
             );

       },
     ),
   );
  }
}
