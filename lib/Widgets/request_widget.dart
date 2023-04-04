import 'package:flutter/material.dart';

class RequestWidget extends StatelessWidget {
  const RequestWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: Image.asset("assets/profilepic.png",height: 50,width: 50,),
          title: Text("John Doe wants to be your teacher",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),

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
}
