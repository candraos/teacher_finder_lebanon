import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:teacher_finder_lebanon/Classes/password_validator.dart';
import 'package:teacher_finder_lebanon/Providers/user_provider.dart';
import 'package:teacher_finder_lebanon/Registration/email_code_view.dart';
import 'package:email_validator/email_validator.dart';
import 'package:provider/provider.dart';
import 'package:teacher_finder_lebanon/ViewModels/user_vm.dart';

import '../Models/Student.dart';
class AdditionalInformation extends StatefulWidget {
  const AdditionalInformation({Key? key}) : super(key: key);

  @override
  _AdditionalInformationState createState() => _AdditionalInformationState();
}
final _formKey = GlobalKey<FormState>();
bool _isVisible = false;

class _AdditionalInformationState extends State<AdditionalInformation> {

  toggleVisibility(){
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 30,),
            Text("Please enter additional information",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
              ),),

            Visibility(
              visible: _isVisible,
              child: CircularProgressIndicator(),
            ),

            Container(
              margin: EdgeInsets.symmetric(horizontal: 30,vertical: 40),
              child: Form(
                key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (value){
                          if(value == "" || value == null){
                            return "Please enter your first name";
                          }
                          if (value.trim().length <2){
                            return "First name should be at least two characters long";
                          }
                          return null;
                        },
                        controller: _firstNameController,
                        decoration: InputDecoration(
                            hintText: "First Name",
                            prefixIcon: Icon(Icons.input)
                        ),
                      ),
                      SizedBox(height: 20,),
                      TextFormField(
                        validator: (value){
                          if(value == "" || value == null){
                            return "Please enter your last name";
                          }
                          if (value.trim().length <2){
                            return "Last name should be at least two characters long";
                          }
                          return null;
                        },
                        controller: _lastNameController,
                        decoration: InputDecoration(
                            hintText: "Last Name",
                            prefixIcon: Icon(Icons.input)
                        ),
                      ),
                      SizedBox(height: 20,),
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
                      SizedBox(height: 20,),
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
                    ],
                  )
              ),
            ),

            Container(
              margin: EdgeInsets.symmetric(horizontal: 10,vertical: 30),
              child: ElevatedButton(
                  onPressed: () async{
                    toggleVisibility();
                    if (_formKey.currentState!.validate()){
                      String firstName = _firstNameController.text.trim();
                      String lastName = _lastNameController.text.trim();
                      String email = _emailController.text.trim();
                      String password = _passwordController.text.trim();


                      if(await UserViewModel().emailExists(email)){
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Email Already in use"),action: SnackBarAction(
                          label: "Dismiss",
                          onPressed: () {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          },
                        ),));
                        toggleVisibility();
                        return;
                      }
                      context.read<UserProvider>().updateInfo(
                          firstName,
                          lastName,
                          email,
                          password);


                      bool success = await UserViewModel().register(context, email, password);
                      toggleVisibility();
                      if(success)
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => EmailCode()));
                      else
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error occured, please try again later"),action: SnackBarAction(
                          label: "Dismiss",
                          onPressed: () {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          },
                        ),));
                    }
                    toggleVisibility();
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
