import 'package:flutter/material.dart';
import 'package:teacher_finder_lebanon/MainViews/Pages/feedback_view.dart';

class PreviousSTList extends StatelessWidget {
  const PreviousSTList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemBuilder: (_,index){
          return ListTile(
            title: Row(
              children: [
                Expanded(child: Text("John Doe")),
              ],
            ),
            // subtitle: Text("Maths Physics Biology"),
            leading: Image.asset("assets/profilepic.png",height: 50,width: 50,),
            trailing: Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              width: 100,
              child: ElevatedButton(

                  onPressed: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => SubmitFeedback()));
                  },
                  child: Text("Feedback",style: TextStyle(fontSize: 13),)
              ),
            ),
          );
        },
        separatorBuilder: (_, index) => Divider(thickness: 2,),
        itemCount: 30);
  }
}
