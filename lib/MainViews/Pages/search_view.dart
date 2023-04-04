import 'package:flutter/material.dart';
import 'package:teacher_finder_lebanon/ViewModels/search_vm.dart';
import 'package:teacher_finder_lebanon/Widgets/search_list_widget.dart';
import 'package:provider/provider.dart';
import '../../Models/User.dart';
import '../../ViewModels/topic_vm.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}
List<TopicViewModel> topics = [];
Map<String,bool> topicsCheckBox = Map();
List<Widget> checkboxListTiles = [];
class _SearchState extends State<Search> {
ListTopicsViewModel _listTopicsViewModel = ListTopicsViewModel();
bool _isvisible = false;
List<User> users = [];
TextEditingController _searchController = TextEditingController();
  Future<void> initialise() async{
    Map<String,bool> temp = Map();
     await _listTopicsViewModel.fetchTopics();
     topics = context.read<ListTopicsViewModel>().topics;
     topics.forEach((topic) { topicsCheckBox[topic.topic!.name!] = false; });
    setState(() {
    });

  }
  toggleVisibility(){
    setState(() {
      _isvisible = !_isvisible;
    });
  }
  @override
  void initState() {
    super.initState();
    initialise();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: Drawer(
        child: ListView.builder(
          itemCount: context.watch<ListTopicsViewModel>().topics.length,
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          itemBuilder: (BuildContext context, int index) {
            print(index);
            if(index != context.watch<ListTopicsViewModel>().topics.length)
            return CheckboxListTile(
              title: Text(context.watch<ListTopicsViewModel>().topics[index].topic!.name!),
              value: topicsCheckBox[context.watch<ListTopicsViewModel>().topics[index].topic!.name!],
              controlAffinity: ListTileControlAffinity.leading,
              onChanged: (bool? value) { setState(() {
                topicsCheckBox[context.watch<ListTopicsViewModel>().topics[index].topic!.name!] = value!;
              }); },
            );

            return  Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton(
                  onPressed: (){},
                  child: Text("Apply")
              ),
            );
          },

        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 15,),

          TextField(
            controller: _searchController,
            onChanged: (keyword)async{
              toggleVisibility();
             await context.read<SearchViewModel>().search(keyword, context);
              toggleVisibility();
            },
            decoration: InputDecoration(
                hintText: "Search",
                prefixIcon: Icon(Icons.search),
              suffixIcon: Builder(
                builder: (context) {
                  return IconButton(
                    onPressed: (){
                      Scaffold.of(context).openEndDrawer();
                    },
                      icon: Icon(Icons.filter_vintage));
                }
              )
            ),
          ),

          SizedBox(height: 20,),

          Visibility(
            visible: _isvisible,
              child: Center(child: CircularProgressIndicator(),)
          ),

          Expanded(
            child: SearchList(users: context.watch<SearchViewModel>().users,topics: context.watch<SearchViewModel>().topics),
          )
        ],
      ),
    );
  }
}
