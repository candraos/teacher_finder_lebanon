import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:teacher_finder_lebanon/Providers/user_provider.dart';
import 'package:teacher_finder_lebanon/Registration/get_phone_view.dart';
import 'package:provider/provider.dart';
import 'package:teacher_finder_lebanon/ViewModels/user_vm.dart';
import 'package:teacher_finder_lebanon/ViewModels/topic_vm.dart';

import '../MainViews/navigation_view.dart';
import '../Models/Student.dart';
import '../Models/Teacher.dart';


class EmailCode extends StatefulWidget {
  const EmailCode({Key? key}) : super(key: key);

  @override
  _EmailCodeState createState() => _EmailCodeState();
}
StreamController<ErrorAnimationType> errorController = StreamController<ErrorAnimationType>()..add(ErrorAnimationType.shake);
bool isVisible = false;
bool isCircularVisible = false;
class _EmailCodeState extends State<EmailCode> {

  toggleVisibility(){
    setState(() {
      isCircularVisible = !isCircularVisible;
    });
  }

  @override
  void initState() {
    super.initState();


  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async =>  false,
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text("Please enter the verification code we sent you by email",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
              ),),

            Container(
              margin: EdgeInsets.symmetric(horizontal: 30),
              child: Form(
                child: Column(
                  children: [
                    Visibility(
                      visible: isCircularVisible,
                        child: CircularProgressIndicator()
                    ),
                    PinCodeTextField(
                      appContext: context,
                      errorAnimationController: errorController,
                      length: 6,
                      onChanged: (String value) {  },

                      onCompleted: (String code) async {
                        toggleVisibility();
                        try{
                         await UserViewModel().verify(context, code);
                          setState(() {
                            isVisible = false;
                          });

                          toggleVisibility();
                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Navigation()));
                        }catch( e){
                          toggleVisibility();
                          print(e);
                          setState(() {
                            isVisible = true;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error occured, please try again later")));
                        }
                        // toggleVisibility();

                      },
                    ),
                    Visibility(
                      visible: isVisible,
                        child: Text("Verification Code not recognised",style: TextStyle(color: Theme.of(context).errorColor,fontSize: 20),)),

                  ],
                ),
              ),
            ),
            // RichText(
            //   textAlign: TextAlign.center,
            //   text: TextSpan(
            //       text: "Didn't receive the code? ",
            //       style: TextStyle(color: Colors.black54, fontSize: 15),
            //       children: [
            //         TextSpan(
            //             text: " RESEND",
            //             recognizer: TapGestureRecognizer()..onTap = () async{
            //               final supabase = Supabase.instance.client;
            //               final AuthResponse res = await supabase.
            //               setState(() {
            //                 isVisible = false;
            //               });
            //             },
            //             style: TextStyle(
            //                 color: Theme.of(context).primaryColor,
            //                 fontWeight: FontWeight.bold,
            //                 fontSize: 16))
            //       ]),
            // ),

          ],
        ),
      ),
    );
  }
}
