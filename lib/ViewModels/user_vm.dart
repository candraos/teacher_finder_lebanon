import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';
import 'package:teacher_finder_lebanon/ViewModels/topic_vm.dart';
import '../Models/Student.dart';
import '../Models/Teacher.dart';
import '../Models/Topic.dart';
import '../Providers/login_provider.dart';
import '../Providers/user_provider.dart';

class UserViewModel{

  final supabase = Supabase.instance.client;
  Future<bool> emailExists(String email) async{
    final  emailVerifydata = await supabase
        .from('Student')
        .select("email")
        .eq('email', email);
    print(emailVerifydata);
    if((emailVerifydata as List<dynamic>).isEmpty){
      final  emailVerifydataTeacher = await supabase
          .from('Teacher')
          .select("email")
          .eq('email', email);
      print(emailVerifydataTeacher);
      return !(emailVerifydataTeacher as List<dynamic>).isEmpty;
    }
    return true;
  }

  Future<bool> register(BuildContext context,String email,String password) async{
    try{
      var user = context.read<UserProvider>().user;
      Map<String,dynamic> data = {};
      if(user is Student)
        data = {
          // "id" : user.id,
          "role": "Student",
          "firstName": context.read<UserProvider>().user.firstName,
          "lastName": context.read<UserProvider>().user.lastName,
          "section" : context.read<UserProvider>().user.section,
          "latitude" : context.read<UserProvider>().user.latitude,
          "longitude" : context.read<UserProvider>().user.longitude
        };
      else{
        data = {
          // "id" : user.id,
          "latitude" : context.read<UserProvider>().user.latitude,
          "longitude" : context.read<UserProvider>().user.longitude,
          "role": "Teacher",
          "firstName": context.read<UserProvider>().user.firstName,
          "lastName": context.read<UserProvider>().user.lastName,
          "section" : context.read<UserProvider>().user.section,
          "rating" : 0,
          "price" : context.read<UserProvider>().price,
          "currency" : context.read<UserProvider>().currency,

        };
      }
      final  res = await supabase.auth.signUp(
          email: email,
          password: password,
          data: data
      );
      return true;
    }catch(e){
      print("Exception while registering: $e");
      return false;
    }
    return false;
  }


  Future<void> verifyChangePassword(String email, String code) async{
    await supabase.auth.verifyOTP(token: code, type: OtpType.recovery, email: email);

  }

  Future<void> verify(BuildContext context,String code) async{
    final AuthResponse res = await supabase.auth.verifyOTP(token: code, type: OtpType.signup,email: context.read<UserProvider>().user.email);
    var topics = context.read<UserProvider>().topics;
    final User? user = res.user;
    await ListTopicsViewModel().addTopicsToUser(user!.id, topics);

    var currentuser = context.read<UserProvider>().user;
    final AuthResponse loginres = await supabase.auth.signInWithPassword(
      email: currentuser.email,
      password: currentuser.password,
    );
    currentuser.id = loginres.user!.id;
    String role = '';
    var data;
    if(currentuser is Student) {
      role = "Student";
      data = {
        "customid" : user.id,
        "firstName" : currentuser.firstName,
        "lastName" : currentuser.lastName,
        "email": currentuser.email,
        "section" : currentuser.section,
        "latitude" : currentuser.latitude,
        "longitude" : currentuser.longitude

      };
    } else if(currentuser is Teacher) {
      role = "Teacher";
      data = {
        "customid" : user.id,
        "firstName" : currentuser.firstName,
        "lastName" : currentuser.lastName,
        "email": currentuser.email,
        "section" : currentuser.section,
        "latitude" : currentuser.latitude,
        "longitude" : currentuser.longitude,
        "rating" : 0,
        "price" : context.read<UserProvider>().price,
        "currency" : context.read<UserProvider>().currency,
      };
    }
    currentuser.toStorage();
    await supabase
        .from(role)
        .insert(data);

  }

  Future<void> login(String email,String password,BuildContext context) async{
    final AuthResponse loginres = await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );

    var user;
    var userData = loginres.user!.userMetadata;

    if(userData!["role"] == "Teacher"){
      user = Teacher();
      user.price = double.parse(userData!["price"].toString());
      user.rating = double.parse(userData!["rating"].toString());
      user.currency = userData["currency"];
    }else{
      user = Student();
    }
    user.firstName = userData["firstName"];
    user.lastName = userData["lastName"];
    user.section = userData["section"];
    user.image = userData["image"];

    user.email = loginres.user!.email;
    user.id = loginres.user!.id;
    await user.toStorage();
    context.read<LoginProvider>().update(user);
  }

  Future<dynamic> fetchUser(String id,String table) async{
    final response = await supabase.from(table).select().eq("customid", id);
    if(table == "Student"){
      return Student.fromJson(response[0]);
    }else{
      return Teacher.fromJson(response[0]);
    }
    // return user;
  }

}