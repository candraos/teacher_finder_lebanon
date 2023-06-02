import 'package:flutter/material.dart';
import 'package:image_picker_widget/image_picker_widget.dart';
import 'package:provider/provider.dart';
import '../Classes/Services/message_service.dart';
import '../Models/message.dart';
import 'chat_bubble.dart';

class Chat extends StatefulWidget {
   Chat({Key? key, required this.userToId, required this.firstName, required this.lastName,required this.image}) : super(key: key);

  final String userToId;
  final String firstName;
  final String lastName;
  var image;

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {

  final _key = GlobalKey<FormState>();
  final _controller = TextEditingController();


  Future<void> _submit(MessageService service) async{
    final text = _controller.text.trim();

    if(text.isEmpty) return;

    if(_key.currentState!.validate()){
      _key.currentState!.save();

      service.saveMessage(text, widget.userToId, context);

      _controller.text= '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MessageService _service = context.read<MessageService>();
    return Scaffold(
      body: StreamBuilder<List<dynamic>>(
        stream: _service.getMessages(context),
        builder: (context,snapshot){
          print(snapshot.data);
          if(snapshot.connectionState != ConnectionState.waiting && snapshot.hasData){
            final messages = snapshot.data!;
            return Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                children: [
                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ImagePickerWidget(
                          diameter: 50,
                          initialImage:widget.image,
                          shape: ImagePickerWidgetShape.circle, // ImagePickerWidgetShape.square
                          isEditable: false
                      ),

                      SizedBox(width: 10,),

                      Text("${widget.firstName} ${widget.lastName}",
                      style: TextStyle(
                        fontSize: 25
                      ),)
                    ],
                  ),

                  Expanded(
                      child: ListView.builder(
                          reverse: true,
                          itemCount: messages.length,
                          itemBuilder: (context,index){
                            final message = messages[index];
                            return ChatBubble(message: message);
                          }
                      )
                  ),

                  SafeArea(
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Form(
                          key: _key,
                          child: TextFormField(
                            controller: _controller,
                            decoration: InputDecoration(labelText: "message...",
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    Icons.send_rounded,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () => _submit(_service),
                                )),
                          ),
                        ),
                      )
                  ),

                  const SizedBox(height: 20,)
                ],
              ),
            );
          }

          return Center(child: CircularProgressIndicator(),);
        },
      ),
    );
  }
}
