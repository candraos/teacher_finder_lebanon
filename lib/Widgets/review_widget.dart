import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:image_picker_widget/image_picker_widget.dart';
import 'package:readmore/readmore.dart';
import 'package:teacher_finder_lebanon/Models/Feedback.dart';
import 'package:teacher_finder_lebanon/Widgets/rating_bar_widget.dart';


class ReviewWidget extends StatelessWidget {
   ReviewWidget({Key? key,required this.feedback}) : super(key: key);

  FeedbackModel feedback;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row( //contains name and picture of user and date of review
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row( // name and picture of user
              children: [
                ImagePickerWidget(
                  diameter: 50,

                  initialImage: Image(image: Svg("assets/profile-logo.svg"),).image,
                  shape: ImagePickerWidgetShape.circle, // ImagePickerWidgetShape.square
                  isEditable: false,

                ),
                SizedBox(width: 10,),
                Text("${feedback.student.firstName} ${feedback.student.lastName}", style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),)
              ],
            ),
            Text(feedback.date, style: TextStyle(fontSize: 17,color: Colors.black.withOpacity(0.5)),)
          ],
        ),
        SizedBox(height: 10,),
        Rating(rating: 3),
        SizedBox(height: 10,),
        ReadMoreText(feedback.description,
          trimLines: 5,
          trimMode: TrimMode.Line,
          trimCollapsedText: 'Read more',
          trimExpandedText: 'Read less',
          style: TextStyle(fontSize: 17),)
      ],
    );
  }
}
