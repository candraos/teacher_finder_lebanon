import 'package:flutter/material.dart';
import 'package:teacher_finder_lebanon/Widgets/review_widget.dart';

class Reviews extends StatelessWidget {
  const Reviews({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Reviews"),),
      body: SingleChildScrollView(
        child: Column(
          children: [
            for(int i=0;i<10;i++)
              Container(
                margin: EdgeInsets.symmetric(vertical: 10,horizontal: 15),
                  child: ReviewWidget())
          ],
        ),
      ),
    );
  }
}
