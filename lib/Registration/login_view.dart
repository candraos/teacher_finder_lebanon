import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:teacher_finder_lebanon/MainViews/navigation_view.dart';
import 'package:teacher_finder_lebanon/Models/Teacher.dart';
import 'package:teacher_finder_lebanon/Providers/login_provider.dart';
import 'package:teacher_finder_lebanon/Registration/choose_role_view.dart';
import 'package:provider/provider.dart';
import 'package:teacher_finder_lebanon/Registration/ForgotPassword/forgot_password.dart';
import '../Models/Student.dart';
import '../Providers/user_provider.dart';
import '../ViewModels/user_vm.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _isVisible = false;



  void toggleVisibility(){
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  @override
  void initState() {
    super.initState();


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(

        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [

            RichText(
                text: TextSpan(
                  children: [
                    TextSpan(text: "Welcome to\n\n",style: TextStyle(color: Colors.black,fontSize: 20)),
                    TextSpan(text: "Teacher Finder Lebanon",style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 30)),
                  ]
                )
            ),

            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                  child: Column(
                    children: [
                      Visibility(
                        visible: _isVisible,
                          child: CircularProgressIndicator()),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: "Email",
                          prefixIcon: Icon(Icons.email_outlined)
                        ),
                      ),
                      SizedBox(height: 30,),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                            hintText: "Password",
                            prefixIcon: Icon(Icons.password),
                        ),
                      ),
                      SizedBox(height: 10,),
                      GestureDetector(
                        onTap: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => ForgotPassword()));
                        },
                        child: Align(
                          alignment: Alignment.centerRight,
                            child: Text("Forgot Password?",style: TextStyle(color:Theme.of(context).primaryColor,fontSize: 15),)),
                      )
                    ],
                  ),
              ),
            ),

            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  ElevatedButton(
                      onPressed: () async{
                        toggleVisibility();
                        try{
                          await UserViewModel().login(_emailController.text.trim(),_passwordController.text.trim(),context);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Logged in successfully"),action: SnackBarAction(
                            label: "Dismiss",
                            onPressed: () {
                              ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            },
                          ),));
                          toggleVisibility();
                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Navigation()));
                          
                        }catch(e){
                          toggleVisibility();
                          print(e);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Invalid email or password"),action: SnackBarAction(
                            label: "Dismiss",
                            onPressed: () {
                              ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            },
                          ),));
                        }


                      },
                      child: Text("Sign In")),
                  RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(text: "Don\'t have an account? ",style: TextStyle(color: Colors.black,fontSize: 20)),
                            TextSpan(
                                recognizer:  TapGestureRecognizer()..onTap = () => Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ChooseRole())),

                                text: "Sign Up",style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 20)),
                          ]
                      )
                  )
                ],
              ),
            ),

            Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  // Text("Or sign up using",style: TextStyle(fontSize: 20),),
                  // SizedBox(height: 20,),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     SvgPicture.asset(
                  //         "assets/social/facebook-logo.svg",
                  //         semanticsLabel: 'Facebook Logo',
                  //       width: 60,
                  //       height: 60,
                  //     ),
                  //     SizedBox(width: 20,),
                  //     SvgPicture.asset(
                  //         "assets/social/google-logo.svg",
                  //         semanticsLabel: 'Google Logo',
                  //       width: 50,
                  //       height: 50,
                  //     ),
                  //   ],
                  // )
                ],
              ),
            ),



          ],
        ),
      ),
    );
  }
}
