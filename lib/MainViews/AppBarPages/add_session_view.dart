import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:teacher_finder_lebanon/Providers/session_provider.dart';

import '../../Models/Session.dart';
import '../../Models/Student.dart';
import '../../Models/Teacher.dart';

class AddSession extends StatefulWidget {
  const AddSession({Key? key, required this.student,required this.teacher}) : super(key: key);

  final Student student;
  final Teacher teacher;

  @override
  _AddSessionState createState() => _AddSessionState();
}
final _formKey = GlobalKey<FormState>();
class _AddSessionState extends State<AddSession> {

  TextEditingController _titleController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _startTimeController = TextEditingController();
  TextEditingController _endTimeController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  late DateTime date,start,end;
  final now = new DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text("Schedule a Session"),),
      body: Container(
        height: MediaQuery.of(context).size.height,
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Spacer(),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          hintText: "Title"
                        ),
                        validator: (value){
                          if(value == "" || value == null){
                            return "Please enter the session title";
                          }
                          return null;
                        },
                      ),

                      TextFormField(
                        readOnly: true,
                        controller: _dateController,
                        keyboardType: TextInputType.datetime,
                        validator: (value){
                          if(value == "" || value == null){
                            return "Please enter the session date";
                          }
                          return null;
                        },
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2100));

                          if (pickedDate != null) {
                            date = pickedDate;
                            String formattedDate =
                            DateFormat('dd/MM/yyyy').format(pickedDate);

                            setState(() {
                              _dateController.text =
                                  formattedDate; //set output date to TextField value.

                            });
                          }
                        },
                        decoration: InputDecoration(
                            hintText: "Date"
                        ),
                      ),

                     Row(
                       children: [
                         Expanded(
                           child: TextFormField(
                             readOnly: true,
                             controller: _startTimeController,
                             validator: (value){
                               if(value == "" || value == null){
                                 return "Please enter the session start time";
                               }
                               return null;
                             },
                             onTap: () async{
                               TimeOfDay? pickedTime =  await showTimePicker(
                                 initialTime: TimeOfDay.now(),
                                 context: context, //context of current state
                               );

                               if(pickedTime != null ){
                                 start = DateTime(now.year, now.month, now.day, pickedTime.hour, pickedTime.minute);
                                 // start = pickedTime;
                                 _startTimeController.text = pickedTime.format(context).toString();
                                 }
                             },
                             decoration: InputDecoration(
                                 hintText: "Start Time"
                             ),
                           ),
                         ),

                         SizedBox(width: 20,),

                         Expanded(
                           child: TextFormField(
                             readOnly: true,
                             controller: _endTimeController,
                             validator: (value){
                               if(value == "" || value == null){
                                 return "Please enter the session end time";
                               }
                               return null;
                             },
                             onTap: () async{
                               TimeOfDay? pickedTime =  await showTimePicker(
                                 initialTime: TimeOfDay.now(),
                                 context: context, //context of current state
                               );

                               if(pickedTime != null ){
                                 end = DateTime(now.year, now.month, now.day, pickedTime.hour, pickedTime.minute);
                                 print(pickedTime.format(context));//output 10:51 PM
                                 _endTimeController.text = pickedTime.format(context);
                               }
                             },
                             decoration: InputDecoration(
                                 hintText: "End Time"
                             ),
                           ),
                         ),
                       ],
                     ),

                      TextFormField(
                        controller: _descriptionController,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                            hintText: "Description (optional)"
                        ),
                      ),
                    ],
                  ),
                ),

                // Spacer(),
                SizedBox(height: 20,),
                ElevatedButton(
                  onPressed: () async{

                    if(_formKey.currentState!.validate()){
                      if(start.isAfter(end) || start.isAtSameMomentAs(end)){
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Invalid Time Range"),action: SnackBarAction(
                          label: "Dismiss",
                          onPressed: () {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          },
                        ),));
                        return;
                      }
                      Session session = Session(
                          title: _titleController.text.trim(),
                          description: _descriptionController.text,
                          date: date,
                          startTime: start,
                          endTime: end,
                          student: widget.student,
                          teacher: widget.teacher
                      );
                      bool success = await context.read<SessionProvider>().addSession(session
                      );
                      String message = success ? "Session scheduled successfully" : "Error occurred, please try again later";
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message),action: SnackBarAction(
                        label: "Dismiss",
                        onPressed: () {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        },
                      ),));
                      if(success)
                      Navigator.of(context).pop();
                    }

                  },
                  child: Text("Schedule"),
                ),


              ],
            ),



      ),
    );
  }
}
