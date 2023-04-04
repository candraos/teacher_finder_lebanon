abstract class User{
  double? price;
  double? rating;
  String? currency;
  String? image;
  String id = '';
  String role = "";
  String firstName = "";
  String lastName = "";
  String email = "";
  String password = "";
  String section = "";
  double latitude = 0;
  double longitude = 0;
  Future<void> toStorage();
   Future<User> fromStorage();

  User.fromJson(Map<String,dynamic> json);
  User();
}