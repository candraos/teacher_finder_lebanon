import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:image_picker_widget/image_picker_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:teacher_finder_lebanon/Models/Notification.dart' as NotificationModel;

class RequestWidget extends StatefulWidget {
   RequestWidget({Key? key,required this.notification}) : super(key: key);

  NotificationModel.Notification notification;

  @override
  State<RequestWidget> createState() => _RequestWidgetState();
}

class _RequestWidgetState extends State<RequestWidget> {

  Uint8List? userImage;

  _fetchImage() async{
    var client = Supabase.instance.client;
    if(widget.notification.user.image != null)
      userImage = await client
          .storage
          .from('tf-bucket')
          .download(widget.notification.user.image!);
  }
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _fetchImage(),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting) return Container();
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading:  ImagePickerWidget(
                diameter: 50,
                initialImage:widget.notification.user.image == null? Image(image: Svg("assets/profile-logo.svg"),).image : Image.memory(userImage!).image,
                shape: ImagePickerWidgetShape.circle, // ImagePickerWidgetShape.square
                isEditable: false,

              ),
              title: Text("${this.widget.notification.title}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),

            ),
            Row(
              children: [
                SizedBox(width: 10,),
                Expanded(

                  child: ElevatedButton(
                      onPressed: (){},
                      child: Text("Accept")),
                ),
                SizedBox(width: 10,),
                Expanded(

                  child: ElevatedButton(

                    onPressed: (){},
                    child: Text("Reject"),
                    style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).errorColor),),
                ),
                SizedBox(width: 10,),
              ],
            )
          ],
        );
      }
    );
  }
}
