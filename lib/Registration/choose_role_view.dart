import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:teacher_finder_lebanon/Registration/choose_section_view.dart';
import 'package:provider/provider.dart';

import 'package:teacher_finder_lebanon/Registration/choose_topics_view.dart';

import '../Providers/user_provider.dart';

class ChooseRole extends StatelessWidget {
  const ChooseRole({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        margin: EdgeInsets.symmetric(vertical: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Are you learning or teaching?",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 25
            ),),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  ElevatedButton(
                      onPressed: (){
                        context.read<UserProvider>().initialise("Student");
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChooseSection()));
                      },
                      child: Text("I am learning")
                  ),
                  ElevatedButton(
                      onPressed: (){
                        context.read<UserProvider>().initialise("Teacher");
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChooseSection()));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(66, 66, 66, 1)
                      ),
                      child: Text("I am teaching")
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
