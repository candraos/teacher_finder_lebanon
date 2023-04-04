import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class SMSCode extends StatefulWidget {
  const SMSCode({Key? key}) : super(key: key);

  @override
  _SMSCodeState createState() => _SMSCodeState();
}
StreamController<ErrorAnimationType> errorController = StreamController<ErrorAnimationType>()..add(ErrorAnimationType.shake);

class _SMSCodeState extends State<SMSCode> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text("Please enter the verification code we sent you by SMS",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30,
            ),),

          Container(
            margin: EdgeInsets.symmetric(horizontal: 30),
            child: PinCodeTextField(
              appContext: context,
              errorAnimationController: errorController,
              length: 6,
              onChanged: (String value) {  },
              onCompleted: (String value){
                // Navigator.of(context).push(MaterialPageRoute(builder: (context) => GetPhone()));
              },
            ),
          ),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
                text: "Didn't receive the code? ",
                style: TextStyle(color: Colors.black54, fontSize: 15),
                children: [
                  TextSpan(
                      text: " RESEND",
                      // recognizer: onTapRecognizer,
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16))
                ]),
          ),

        ],
      ),
    );
  }
}
