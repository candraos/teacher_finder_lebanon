import 'package:flutter/material.dart';
import 'package:teacher_finder_lebanon/Registration/additional_information_view.dart';
import 'package:teacher_finder_lebanon/Registration/location_access_view.dart';
import 'package:provider/provider.dart';

import '../Providers/user_provider.dart';

class ChoosePrice extends StatefulWidget {
  const ChoosePrice({Key? key}) : super(key: key);

  @override
  State<ChoosePrice> createState() => _ChoosePriceState();
}
final _formKey = GlobalKey<FormState>();
class _ChoosePriceState extends State<ChoosePrice> {
  List<String> _currencies = ["LL","USD"];
  TextEditingController _controller = TextEditingController();
  String currencySelected = "LL";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text("How much will you charge per session?",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30,
            ),),

          Form(
            key: _formKey,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      padding: EdgeInsets.only(bottom: 15),
                      child: TextFormField(
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
                        controller: _controller,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            hintText: "Price",
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
            ),
          ),

          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: ElevatedButton(
                onPressed: (){
                  if (_formKey.currentState!.validate()){
                    context.read<UserProvider>().updatePrice(double.parse(_controller.text.trim()), currencySelected);
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => LocationAccess()));
                  }
                  
                },
                child: Text("Continue")
            ),
          ),
        ],
      ),
    );
  }
}
