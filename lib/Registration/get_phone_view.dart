import 'package:flutter/material.dart';
import 'package:teacher_finder_lebanon/Registration/sms_code_view.dart';

class GetPhone extends StatefulWidget {
  const GetPhone({Key? key}) : super(key: key);

  @override
  _GetPhoneState createState() => _GetPhoneState();
}

class _GetPhoneState extends State<GetPhone> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text("Enter your phone number",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30,
            ),),

          Container(
            margin: EdgeInsets.symmetric(horizontal: 30),
            child: TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  hintText: "Phone Number",
                  prefixIcon: Icon(Icons.phone)
              ),
            ),
          ),

          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: ElevatedButton(
                onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => SMSCode()));
                },
                child: Text("Continue")
            ),
          ),
        ],
      ),
    );
  }
}
