


import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:teacher_finder_lebanon/Classes/Services/message_service.dart';
import 'package:teacher_finder_lebanon/MainViews/Pages/home_view.dart';
import 'package:teacher_finder_lebanon/MainViews/navigation_view.dart';
import 'package:teacher_finder_lebanon/Providers/page_provider.dart';
import 'package:teacher_finder_lebanon/Providers/session_provider.dart';
import 'package:teacher_finder_lebanon/Registration/login_view.dart';
import 'package:teacher_finder_lebanon/ViewModels/feedback_view_model.dart';
import 'package:teacher_finder_lebanon/ViewModels/notification_view_model.dart';
import 'package:teacher_finder_lebanon/ViewModels/search_vm.dart';
import 'package:teacher_finder_lebanon/ViewModels/topic_vm.dart';
import 'Models/Student.dart';
import 'Models/Teacher.dart';
import 'Models/User.dart';
import 'Providers/login_provider.dart';
import 'Providers/user_provider.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'ViewModels/student_teacher_view_model.dart';

Future _initialise() async{
  await Future.delayed(Duration(seconds: 1));
  final _storage =  FlutterSecureStorage();
  String? email = await _storage.read(key: "email");

  var user;
  if(email != null){

    widget = Navigation();
  }else{
    widget = Login();
  }


  FlutterNativeSplash.remove();
}
late Widget widget;
Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://bhktfcasxylgulcpaecy.supabase.co',
    anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJoa3RmY2FzeHlsZ3VsY3BhZWN5Iiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY3ODcwODc4NSwiZXhwIjoxOTk0Mjg0Nzg1fQ.6_H0xAElo1HtvGcIqP4B12E9nWrQ1FVp7F8165V1f64"
    // anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJoa3RmY2FzeHlsZ3VsY3BhZWN5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2Nzg3MDg3ODUsImV4cCI6MTk5NDI4NDc4NX0.DKUoJvVidKFNKz22BEf0WSgBt_FEMoOU_S6WKgEcyOY',
  );

await _initialise();
  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ListFeedbackViewModel()),
          ChangeNotifierProvider(create: (_) => MessageService()),
          ChangeNotifierProvider(create: (_) => StudentTeacherViewModel()),
          ChangeNotifierProvider(create: (_) => ListNotificationsViewModel()),
          ChangeNotifierProvider(create: (_) => UserProvider()),
          ChangeNotifierProvider(create: (_) => SearchViewModel()),
          ChangeNotifierProvider(create: (_) => ListTopicsViewModel()),
          ChangeNotifierProvider(create: (_) => LoginProvider()),
          ChangeNotifierProvider(create: (_) => PageProvider()),
          ChangeNotifierProvider(create: (_) => SessionProvider())
        ],
          child: const MyApp()
      ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return CalendarControllerProvider(
      controller: EventController(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Teacher Finder Lebanon',
        theme: ThemeData(
          primaryColor: Color.fromRGBO(18, 94, 137, 1),
          backgroundColor: Colors.white,
          errorColor: Colors.red,
          appBarTheme: AppBarTheme(
            backgroundColor: Color.fromRGBO(18, 94, 137, 1)
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              textStyle: TextStyle(
                fontSize: 18
              ),
              backgroundColor:  Color.fromRGBO(18, 94, 137, 1),
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),

              ),
            )
          ),
          textTheme: GoogleFonts.baskervvilleTextTheme(
            Theme.of(context).textTheme.apply(
              bodyColor: Colors.black,
              displayColor: Colors.black
            )
          ),


        ),
        home: widget,
      ),
    );
  }
}

