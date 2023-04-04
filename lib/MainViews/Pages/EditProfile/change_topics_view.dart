import 'package:flutter/material.dart';
import 'package:teacher_finder_lebanon/ViewModels/edit_profile_vm.dart';
import 'package:teacher_finder_lebanon/ViewModels/topic_vm.dart';

class ChangeTopics extends StatefulWidget {
   ChangeTopics({Key? key,required this.selectedItems}) : super(key: key);

  List<TopicViewModel> selectedItems;

  @override
  _ChangeTopicsState createState() => _ChangeTopicsState();
}

class _ChangeTopicsState extends State<ChangeTopics> {
  ListTopicsViewModel _topicsViewModel = ListTopicsViewModel();
  Color color = Colors.white;
  List<bool> _selected = [];

  _fetchTopics() async{
    await _topicsViewModel.fetchTopics();
     _selected = List.generate(_topicsViewModel.topics.length, (i) => false);
    _topicsViewModel.topics.forEach((topic) {
      widget.selectedItems.forEach((element) {
        if(element.topic!.id == topic.topic!.id){
          int index = _topicsViewModel.topicIndex(topic.topic!);
          setState(() {
            _selected[index] = true;
          });
        }
      });
    });
    print(_selected);
  }

  @override
  void initState() {
    super.initState();
    _fetchTopics();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [

          SizedBox(height: 40,),

          Text("Choose the topics you are teaching",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30,
            ),),

          SizedBox(height: 20,),

          Expanded(
            child: ListView.separated(
                itemCount: _topicsViewModel.topics.length,
                separatorBuilder: (_, index) => Divider(),
                itemBuilder: (_,index){
                  return ListTile(
                    selected: _selected[index],
                    trailing: _selected[index] ? Icon(Icons.check) : null,
                    dense:true,
                    onTap: (){
                      if(! _selected[index]){
                        setState(() {
                          _selected[index] = !_selected[index];
                          widget.selectedItems.add(_topicsViewModel.topics[index]);
                          widget.selectedItems.forEach((element) {print(element.topic!.name);});
                        });
                      }else{
                        setState(() {
                          _selected[index] = !_selected[index];
                          widget.selectedItems.removeWhere((val) => val.topic!.id == _topicsViewModel.topics[index].topic!.id);
                          widget.selectedItems.forEach((element) {print(element.topic!.name);});
                        });
                      }
                    },
                    title: Text(_topicsViewModel.topics[index].topic!.name!,style: TextStyle(fontSize: 20),),);
                }
            ),
          ),

          SizedBox(height: 20,),

          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: ElevatedButton(
                onPressed: () async{
                  if(!widget.selectedItems.isEmpty){
                    bool success = await EditProfileViewModel().updateTopics(widget.selectedItems, context);
                    if(success){
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Topics updated Successfully"),
                            action: SnackBarAction(
                              label: "Dismiss",
                              onPressed: () {
                                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                              },
                            ),)
                      );
                      Navigator.of(context).pop();
                    }else{
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Error occurred, please try again later"),
                            action: SnackBarAction(
                              label: "Dismiss",
                              onPressed: () {
                                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                              },
                            ),)
                      );
                    }

                  }else{
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Choose at least one topic to continue"),
                          action: SnackBarAction(
                            label: "Dismiss",
                            onPressed: () {
                              ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            },
                          ),)
                    );
                  }

                },
                child: Text("Save")
            ),
          ),

          SizedBox(height: 20,),
        ],
      ),
    );
  }
}
