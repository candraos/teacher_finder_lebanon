import 'package:flutter/material.dart';
import 'package:teacher_finder_lebanon/Registration/choose_topics_view.dart';
import 'package:provider/provider.dart';

import '../Providers/user_provider.dart';

class ChooseSection extends StatefulWidget {
   ChooseSection({Key? key}) : super(key: key);

  @override
  State<ChooseSection> createState() => _ChooseSectionState();
}

class _ChooseSectionState extends State<ChooseSection> {
  String? section;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Choose the section you are teaching in",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
              ),),

            Column(
              children: [

                RadioListTile(
                  title: Text("French Section",style: TextStyle(fontSize: 18),),
                  value: "French",
                  groupValue: section,
                  onChanged: (value){
                    setState(() {
                      section = value.toString();
                    });
                  },
                ),

                RadioListTile(
                  title: Text("English Section",style: TextStyle(fontSize: 18)),
                  value: "English",
                  groupValue: section,
                  onChanged: (value){
                    setState(() {
                      section = value.toString();
                    });
                  },
                ),


              ],
            ),

            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: ElevatedButton(
                  onPressed: (){
                    if(section != null){
                      context.read<UserProvider>().updateSection(section!);
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChooseTopics()));
                    }else{
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Choose a section to continue"),
                        action: SnackBarAction(
                          label: "Dismiss",
                          onPressed: () {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          },
                        ),)
                      );
                    }
                  },
                  child: Text("Continue")
              ),
            ),
          ],
        ),
      ),
    );
  }
}
