class Receiver{
int id;
String photo;
User user;
Receiver.fromJson(Map<String,dynamic> json):id=json['id'],photo=json['photo'],user=User.fromJson(json['user']);
}

class User{
  String firstname;
  String lastname;
  String email;

  User.fromJson(Map<String,dynamic> json):firstname=json['first_name'],lastname=json['last_name'],email=json['email'];
}