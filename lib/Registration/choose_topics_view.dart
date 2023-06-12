import 'package:flutter/material.dart';
import 'package:teacher_finder_lebanon/Models/Student.dart';
import 'package:teacher_finder_lebanon/Registration/choose_price_view.dart';
import 'package:provider/provider.dart';
import 'package:teacher_finder_lebanon/ViewModels/topic_vm.dart';

import '../Models/Teacher.dart';
import '../Models/User.dart';
import '../Providers/user_provider.dart';
import 'location_access_view.dart';

class ChooseTopics extends StatefulWidget {
  const ChooseTopics({Key? key}) : super(key: key);

  @override
  _ChooseTopicsState createState() => _ChooseTopicsState();
}

class _ChooseTopicsState extends State<ChooseTopics> {
  ListTopicsViewModel topicsViewModel = ListTopicsViewModel();
  List<int> _selectedItems = <int>[];
  Color color = Colors.white;
  List<bool> _selected = [];

  void initialise() async{
    await topicsViewModel.fetchTopics();
    _selected = List.generate(topicsViewModel.topics.length, (i) => false);
setState(() {

});
  }

  @override
  void initState() {
    initialise();
    super.initState();

    }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Column(
        children: [

          SizedBox(height: 30,),

          Text("Choose the topics you ${context.read<UserProvider>().user  is Student ? "need help with" : "are teaching"}",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 30,
            ),),



          // SizedBox(height: 10,),

          if(topicsViewModel.topics.isEmpty) Expanded(child: Center(child: CircularProgressIndicator(),))
          else
          Expanded(child: ListView.separated(
              itemCount: topicsViewModel.topics.length,

              // padding: EdgeInsets.only(left: 15,bottom: 10),
              separatorBuilder: (_, index) => Divider(),
              itemBuilder: (_,index){
                // return Text(topics[index],style: TextStyle(fontSize: 18),);
                return ListTile(
                  selected: _selected[index],
                  trailing: _selected[index] ? Icon(Icons.check) : null,
                  // selectedTileColor: Colors.grey,
                  dense:true,
                  // visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                  onTap: (){
                    if(! _selectedItems.contains(topicsViewModel.topics[index].topic!.id!)){

                      setState(() {
                        _selected[index] = !_selected[index];
                        _selectedItems.add(topicsViewModel.topics[index].topic!.id!);

                      });

                    }else{
                      setState(() {
                        _selected[index] = !_selected[index];
                        _selectedItems.removeWhere((val) => val == topicsViewModel.topics[index].topic!.id!);

                      });
                    }
                  },
                  title: Text(topicsViewModel.topics[index].topic!.name!,style: TextStyle(fontSize: 20),),);
              }
          )),




          SizedBox(height: 20,),

          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: ElevatedButton(
                onPressed: (){
                  if(!_selectedItems.isEmpty){
                    context.read<UserProvider>().updateTopics(_selectedItems);
                    User user = context.read<UserProvider>().user;
                    if(user is Teacher)
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChoosePrice()));
                    else
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => LocationAccess()));
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
                child: Text("Continue")
            ),
          ),

          SizedBox(height: 20,),
        ],
      ),
    );
  }
}
