import 'package:flutter/material.dart';
import 'package:teacher_finder_lebanon/Models/message.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({Key? key, required this.message}) : super(key: key);

  final Message message;

  @override
  Widget build(BuildContext context) {
    print(message.createdAt.toString());
    final chatContents = [
      SizedBox(width: 12,),

      Flexible(child: Container(
        padding: EdgeInsets.symmetric(vertical: 8,horizontal: 12),
        decoration: BoxDecoration(
          color: message.isMine ? Colors.grey[600] : Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(8)
        ),
        child: Text(message.content,style: TextStyle(color: Colors.white),),)),

      SizedBox(width: 12,),

      Text(message.createdAt.toString().split(".")[0],
      style: TextStyle(
        color: Colors.grey,
        fontSize: 15
      ),),


      SizedBox(width: 60,),
    ];
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 18,horizontal: 8),
      child: Row(
        mainAxisAlignment: message.isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: chatContents,
      ),
    );
  }
}
