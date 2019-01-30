import 'package:wedetect/models/category.dart';
import 'package:wedetect/models/piece.dart';
import 'package:wedetect/models/receiver.dart';

class Alert {
  String title = "Un titre...";
  String content = "";
  String dateCreation="";
  Category category;
  List<Piece> pieces;
  List<Receiver> receivers;
  Alert();
  Alert.fromJson(Map<String, dynamic> json)
      : title = json['titre'],
        content = json['contenu'],
        dateCreation=json['date_de_creation'],
        category=Category.fromJson(json['categorie']);
}
