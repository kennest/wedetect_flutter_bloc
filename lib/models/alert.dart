import 'package:scoped_model/scoped_model.dart';

class Alert extends Model {
  String title = "Un titre...";
  String contenu = "";
  Alert();
  Alert.fromJson(Map<String, dynamic> json)
      : title = json['titre'],
        contenu = json['contenu'];

  void changeTitle(String title) {
    this.title = title;
    notifyListeners();
  }
}
