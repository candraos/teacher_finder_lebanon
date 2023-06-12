import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:teacher_finder_lebanon/Registration/ForgotPassword/verify_email.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

  TextEditingController _emailController = TextEditingController();

  bool _isVisible = false;
  final _formKey = GlobalKey<FormState>();

  toggleVisibility(){
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Visibility(
                visible: _isVisible,
                child: CircularProgressIndicator()
            ),
            TextFormField(
              validator: (value) {
                if(value == "" || value == null){
                  return "Please enter your email address";
                }
                if(!EmailValidator.validate(value.trim())){
                  return "Please enter a valid email address";
                }

                return null;
              },
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  hintText: "Email",
                  prefixIcon: Icon(Icons.email_outlined)
              ),
            ),

            Container(
              margin: EdgeInsets.symmetric(horizontal: 10,vertical: 30),
              child: ElevatedButton(
                child: Text("Continue"),
                onPressed: () async{
                  if(_formKey.currentState!.validate()){
                    toggleVisibility();
                    await Supabase.instance.client.auth.resetPasswordForEmail(_emailController.text.trim());
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => VerifyEmail(email: _emailController.text.trim())));
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
