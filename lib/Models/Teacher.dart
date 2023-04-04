import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:teacher_finder_lebanon/Models/User.dart';

class Teacher extends User{


  final _storage =  FlutterSecureStorage();
  @override
  Future<void> toStorage() async{
    await _storage.write(key: "firstName", value: this.firstName);
    await _storage.write(key: "lastName", value: this.lastName);
    await _storage.write(key: "email", value: this.email);
    await _storage.write(key: "image", value: this.image);
    await _storage.write(key: "section", value: this.section);
    await _storage.write(key: "latitude", value: this.latitude.toString());
    await _storage.write(key: "longitude", value: this.longitude.toString());
    await _storage.write(key: "id", value: this.id);
    await _storage.write(key: "price", value: this.price.toString());
    await _storage.write(key: "currency", value: this.currency);
    await _storage.write(key: "rating", value: this.rating.toString());
  }

   Future<User> fromStorage() async{
    final _storage =  FlutterSecureStorage();
    User user = Teacher();
    Map<String,String> data = await _storage.readAll();
    user.id = data["id"]!;
    user.firstName = data["firstName"]!;
    user.lastName = data["lastName"]!;
    user.email = data["email"]!;
    user.image = data["image"];
    user.section = data["section"]!;
    user.latitude = double.parse(data["latitude"]!);
    user.longitude = double.parse(data["longitude"]!);
    user.currency = data["currency"]!;
    user.price = double.parse(data["price"]!);
    user.rating = double.parse(data["rating"]!);
    return user;
  }

  Teacher.fromJson(Map<String,dynamic> json){
    id = json["customid"];
    firstName = json["firstName"];
    lastName = json["lastName"];
    email = json["email"];
    section = json["section"];
    latitude = json["latitude"];
    longitude = json["longitude"];
    image = json["image"];
    currency = json["currency"];
    price = json["price"];
    rating = json["rating"];
  }
  Teacher();
}