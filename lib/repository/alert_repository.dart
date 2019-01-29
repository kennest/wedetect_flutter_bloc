import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:http/http.dart' as http;
import 'package:wedetect/models/alert.dart';
import 'package:wedetect/models/category.dart';
import 'package:wedetect/models/piece.dart';
import 'package:wedetect/repository/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AlertRepository {
  var userRepository = UserRepository();
  String next;
  List<Alert> alerts = new List();

  Future<List<Alert>> getAlerts(
      {String url =
          'https://wa.weflysoftware.com/communications/api/alertes/'}) async {
    var connectivityResult = await (new Connectivity().checkConnectivity());
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (await userRepository.hasToken()) {
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        // I am connected to a mobile network.
        http.get(url, headers: {
          'Authorization': await userRepository.getToken(),
        }).then((r) {
          print(json.decode(r.body)['results']['features'][0]['properties']);
          next = json.decode(r.body)['next'];
          print(next);
          List<dynamic> jsonData = json.decode(r.body)['results']['features'];
          prefs.setString('alerts', r.body);

          jsonData.forEach((n) {
            Alert a = Alert.fromJson(n['properties']);
            print(n['properties']['categorie']);
            Category c = Category.fromJson(n['properties']['categorie']);

            //Get Pieces from json
            List<Piece> pieces = new List();
            var piecesFromJson = n['properties']['piece_join_alerte'] as List;
            pieces =
                piecesFromJson.map<Piece>((g) => Piece.fromJson(g)).toList();
            print('Size:${pieces.length}');
            a.pieces = pieces;
            a.category = c;
            alerts.add(a);
          });
        });
      } else {
        String alertsString = prefs.getString('alerts');
        List<dynamic> jsonData =
            json.decode(alertsString)['results']['features'];
        print(json.decode(alertsString));
        jsonData.forEach((n) {
          Alert a = Alert.fromJson(n['properties']);
          print(n['properties']['categorie']);
          Category c = Category.fromJson(n['properties']['categorie']);
          a.category = c;
          alerts.add(a);
        });
      }
    }
    return alerts;
  }
}
