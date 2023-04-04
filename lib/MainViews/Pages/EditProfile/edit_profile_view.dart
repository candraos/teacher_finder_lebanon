import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:teacher_finder_lebanon/Providers/login_provider.dart';
import 'package:teacher_finder_lebanon/Providers/session_provider.dart';
import 'package:teacher_finder_lebanon/ViewModels/edit_profile_vm.dart';

import '../../../Models/Session.dart';
import '../../../Models/Student.dart';
import '../../../Models/Teacher.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}
final _formKey = GlobalKey<FormState>();

class _EditProfileState extends State<EditProfile> {
  bool _isVisible = false;
  List<String> _currencies = ["LL","USD"];
  String? section;
  bool isFrench = false;
  String currencySelected = "LL";
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _amountController = TextEditingController();

  toggleVisibility(){
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  @override
  void initState() {
    super.initState();
    var user = context.read<LoginProvider>().user;
    _firstNameController.text = user.firstName;
    _lastNameController.text = user.lastName;
    if(user is Teacher) _amountController.text = user.price.toString();
    section = user.section;
    isFrench = section == "French";
    setState(() {

    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text("Edit Profile"),),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Column(

                children: [
                  Spacer(),
                  Expanded(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          Center(
                            child: Visibility(
                              visible: _isVisible,
                                child: CircularProgressIndicator()
                            ),
                          ),

                          TextFormField(
                            controller: _firstNameController,
                            validator: (value){
                              if(value == "" || value == null){
                                return "Please enter your first name";
                              }
                              if (value.trim().length <2){
                                return "First name should be at least two characters long";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: "First Name"
                            ),
                          ),

                          TextFormField(
                            controller: _lastNameController,
                            validator: (value){
                              if(value == "" || value == null){
                                return "Please enter your last name";
                              }
                              if (value.trim().length <2){
                                return "Last name should be at least two characters long";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                hintText: "Last Name"
                            ),
                          ),
                          if(context.read<LoginProvider>().user is Teacher)
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                  padding: EdgeInsets.only(bottom: 15),
                                  child: TextFormField(
                                    controller: _amountController,
                                    validator: (value) {
                                      double price = 0;
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your price';
                                      }
                                      try{
                                        price = double.parse(value);
                                        if (price <= 0) {
                                          return 'Please enter a valid price';
                                        }
                                      }catch(e){
                                        return 'Please enter a valid price';
                                      }
                                      return null;
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      hintText: "Amount",
                                    ),
                                  ),
                                ),
                              ),

                              DropdownButton(
                                icon: const Icon(Icons.keyboard_arrow_down),
                                value: currencySelected,
                                items: _currencies.map((String items) {
                                  return DropdownMenuItem(
                                    value: items,
                                    child: Text(items),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    currencySelected = newValue!;
                                  });
                                },
                              )
                            ],
                          ),


                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Text("Teaching In:",style: TextStyle(fontSize: 20),),
                      Expanded(
                        child: Column(
                          children: [

                            RadioListTile(
                              title: Text("French Section",style: TextStyle(fontSize: 18),),
                              value: "French",
                              selected: isFrench,
                              groupValue: section,
                              onChanged: (value){
                                setState(() {
                                  section = value.toString();

                                });
                              },
                            ),
                            // SizedBox(height: 20,),
                            RadioListTile(
                              title: Text("English Section",style: TextStyle(fontSize: 18)),
                              value: "English",
                              selected: !isFrench,
                              groupValue: section,
                              onChanged: (value){
                                setState(() {
                                  section = value.toString();

                                });
                              },
                            ),


                          ],
                        ),
                      ),
                    ],
                  ),
                  Spacer(),

                  ElevatedButton(
                    onPressed: () async{
                      toggleVisibility();
                      String firstName = _firstNameController.text.trim();
                      String lastName = _lastNameController.text.trim();
                      double amount;
                      if(context.read<LoginProvider>().user is Student) amount = 0;
                      else amount = double.parse(_amountController.text.trim());
                      bool success = await EditProfileViewModel().updateProfile(firstName, lastName, section!, amount, context);
                      if(success){
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Profile updated successfully!"),action: SnackBarAction(
                          label: "Dismiss",
                          onPressed: () {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          },
                        ),));
                        Navigator.of(context).pop();
                      }else{
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error occured, please try again later"),action: SnackBarAction(
                          label: "Dismiss",
                          onPressed: () {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          },
                        ),));
                      }
                      toggleVisibility();
                    },
                    child: Text("Save"),
                  ),

                  SizedBox(height: 20,)
                ],
              ),
        ),



      ),
    );
  }
}
