import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:teacher_finder_lebanon/Registration/ForgotPassword/change_password.dart';

import '../../ViewModels/user_vm.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({Key? key, required this.email}) : super(key: key);

  final String email;

  @override
  _VerifyEmailState createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {

  StreamController<ErrorAnimationType> errorController = StreamController<ErrorAnimationType>()..add(ErrorAnimationType.shake);


  bool _isVisible = false;
  bool _isErrorVisible = false;


  toggleVisibility(){
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  toggleError(){
    setState(() {
      _isErrorVisible = !_isErrorVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
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
                        visible: _isVisible,
                        child: CircularProgressIndicator()
                    ),
                    PinCodeTextField(
                      appContext: context,
                      errorAnimationController: errorController,
                      length: 6,
                      onChanged: (String value) {  },

                      onCompleted: (String code) async {
                        toggleVisibility();
                        setState(() {
                          _isErrorVisible = false;
                        });
                        try{
                          await UserViewModel().verifyChangePassword(widget.email, code);

                          toggleVisibility();
                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ChangePassword(email: widget.email)));
                        }catch( e){
                          setState(() {
                            _isErrorVisible = true;
                          });
                          toggleVisibility();

                          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error occured, please try again later")));
                        }
                        // toggleVisibility();

                      },
                    ),
                    Visibility(
                        visible: _isErrorVisible,
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
