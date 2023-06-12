import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../Classes/password_validator.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key, required this.email}) : super(key: key);

  final String email;

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {


  final _formKey = GlobalKey<FormState>();
  bool _isVisible = false;

  toggleVisibility(){
    setState(() {
      _isVisible = !_isVisible;
    });
  }
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

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
              child: CircularProgressIndicator(),
            ),
            TextFormField(
              validator: (val){
                if(val == null || val.isEmpty)
                  return 'Please enter your password';
                if(val.trim() != _confirmPasswordController.text.trim())
                  return 'Passwords do not match';
                if(!PasswordValidator.validate(val.trim())){
                  return "Password must contain more than six characters with one uppercase letter";
                }
                return null;
              },
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: "Password",
                prefixIcon: Icon(Icons.password),
              ),
            ),
            SizedBox(height: 20,),
            TextFormField(
              validator: (val){
                if(val == null || val.isEmpty)
                  return 'Please confirm your password';
                if(val.trim() != _passwordController.text.trim())
                  return 'Passwords do not match';
                if(!PasswordValidator.validate(val.trim())){
                  return "Password must contain more than six characters with one uppercase letter";
                }
                return null;
              },
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: "Confirm Password",
                prefixIcon: Icon(Icons.password),
              ),
            ),

            Container(
              margin: EdgeInsets.symmetric(horizontal: 10,vertical: 30),
              child: ElevatedButton(
                child: Text("Reset Password"),
                onPressed: ()async{
                 if(_formKey.currentState!.validate()){
                   toggleVisibility();
                   try{
                     await Supabase.instance.client.auth.updateUser(UserAttributes(

                         email : widget.email,
                         password: _passwordController.text.trim()

                     ));
                     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Your password has been reset successfully")));

                     Navigator.of(context).popUntil((route) => route.isFirst);
                   }catch(e){
                     toggleVisibility();
                     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error occured, please try again later")));

                   }
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
