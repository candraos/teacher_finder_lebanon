import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:teacher_finder_lebanon/ViewModels/feedback_view_model.dart';


class Rating extends StatelessWidget {
   Rating({Key? key, this.static = true, required this.rating,  this.updateRating}) : super(key: key);

  bool static;
  double rating;
  Function(double rating)? updateRating = (rating){

  };

  @override
  Widget build(BuildContext context) {
    return RatingBar.builder(
      initialRating: rating,
      minRating: 0.5,
      ignoreGestures: static,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemCount: 5,
      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (context, _) => Icon(
        Icons.star,
        color: Colors.amber,
      ),
      onRatingUpdate: updateRating != null? updateRating! : (rating){

      },
    );
  }
}
