import 'package:flutter/material.dart';
import 'package:teacher_finder_lebanon/Models/Feedback.dart';
import 'package:teacher_finder_lebanon/ViewModels/feedback_view_model.dart';

import '../../Models/Student.dart';
import '../../Models/Teacher.dart';
import '../../Widgets/rating_bar_widget.dart';

class SubmitFeedback extends StatefulWidget {
   SubmitFeedback({Key? key,required this.student,required this.teacher}) : super(key: key);

  Student student;
  Teacher teacher;

  @override
  _SubmitFeedbackState createState() => _SubmitFeedbackState();
}
final _formKey = GlobalKey<FormState>();

class _SubmitFeedbackState extends State<SubmitFeedback> {
  TextEditingController _descriptionController = TextEditingController();
  double rating = 0.5;
  bool isVisible = false;

  toggle(){
    setState(() {
      isVisible = !isVisible;
    });
  }

  updateRating(rating){
    this.rating = rating;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Leave a Feedback"),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Rating(rating: 0.5,static: false,updateRating: updateRating),
                  Visibility(visible: isVisible,child: Center(child: CircularProgressIndicator(),)),
                  TextFormField(
                    validator: (value){
                      if(value == "" || value == null){
                        return "Please describe your experience";
                      }
                      return null;
                    },
                    controller: _descriptionController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    minLines: 5,
                    decoration: InputDecoration(
                        hintText: "Describe your experience with this teacher"
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20,),
            ElevatedButton(
              onPressed: () async{
                if(_formKey.currentState!.validate()){
                  toggle();
                  FeedbackViewModel vm = FeedbackViewModel(FeedbackModel(
                      student: widget.student,
                      teacher: widget.teacher,
                      rating: rating,
                      description: _descriptionController.text));
                  bool success = await vm.add();
                  String message = success ? "Feedback submitted successfully" : "Error occurred, please try again later";
                   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message),action: SnackBarAction(
                    label: "Dismiss",
                    onPressed: () {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    },
                  ),));
                   toggle();
                  Navigator.of(context).pop();
                }
              },
              child: Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}
