import 'package:flutter/material.dart';

class CurrentSTList extends StatelessWidget {
  const CurrentSTList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemBuilder: (_,index){
          return ListTile(
            title: Row(
              children: [
                Expanded(child: Text("John Doe")),
              ],
            ),
            // subtitle: Text("Maths Physics Biology"),
            leading: Image.asset("assets/profilepic.png",height: 50,width: 50,),
            trailing: Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              width: 100,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).errorColor
                  ),
                  onPressed: (){
                  },
                  child: Text("Remove",style: TextStyle(fontSize: 13),)
              ),
            ),
          );
        },
        separatorBuilder: (_, index) => Divider(thickness: 2,),
        itemCount: 30);
  }
}
