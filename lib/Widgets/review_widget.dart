import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:image_picker_widget/image_picker_widget.dart';
import 'package:readmore/readmore.dart';
import 'package:teacher_finder_lebanon/Widgets/rating_bar_widget.dart';


class ReviewWidget extends StatelessWidget {
  const ReviewWidget({Key? key}) : super(key: key);

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
                Text("Alex Something", style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),)
              ],
            ),
            Text("17/05/2022", style: TextStyle(fontSize: 17,color: Colors.black.withOpacity(0.5)),)
          ],
        ),
        SizedBox(height: 10,),
        Rating(rating: 3),
        SizedBox(height: 10,),
        ReadMoreText("Lorem Ipsum is simply dummy text of the printing and typesetting industry. "
            "Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, "
            "when an unknown printer took a galley of type and scrambled it to make a type "
            "specimen book. It has survived not only five centuries, but also the leap into "
            "electronic typesetting, remaining essentially unchanged. It was popularised in the "
            "1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more "
            "recently with desktop "
            "publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
          trimLines: 5,
          trimMode: TrimMode.Line,
          trimCollapsedText: 'Read more',
          trimExpandedText: 'Read less',
          style: TextStyle(fontSize: 17),)
      ],
    );
  }
}
