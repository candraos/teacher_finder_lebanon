import 'package:flutter/material.dart';
import 'package:flutter_launcher_icons/utils.dart';
import 'package:geolocator/geolocator.dart';
import 'package:teacher_finder_lebanon/Providers/user_provider.dart';
import 'package:teacher_finder_lebanon/Registration/additional_information_view.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
class LocationAccess extends StatelessWidget {
  const LocationAccess({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 20,horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            Column(
              children: [
                Text("We need access to your location",
                  style: TextStyle(
                      fontSize: 30,fontWeight: FontWeight.bold
                  ),),
                Text("We will use your location to recommend teachers near you",
                  style: TextStyle(
                      fontSize: 20
                  ),),
              ],
            ),
            Spacer(),
            ElevatedButton(
                onPressed: () async{
                  if(await Permission.location.serviceStatus.isEnabled){
                    print("Enabled");

                    var status = await Permission.location.status;
                    if(status.isGranted){
                      print("Granted");
                      var position = await Geolocator.getCurrentPosition();
                      context.read<UserProvider>().updateLocation(position.latitude, position.longitude);
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => AdditionalInformation()));
                    }else{

                      print("Requesting");
                      PermissionStatus locationPermission = await Permission.location.request();
                      if(locationPermission.isGranted){
                        var position = await Geolocator.getCurrentPosition();
                        context.read<UserProvider>().updateLocation(position.latitude, position.longitude);
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => AdditionalInformation()));

                      }
                      else if(locationPermission.isPermanentlyDenied)
                        openAppSettings();
                    }
                  }else {
                    print("Disabled");
                  }
                },
                child: Text("Continue"))
          ],
        ),
      ),
    );
  }
}
