import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedetect/models/alert.dart';

class Api {
  var BASE_URL = "https://wa.weflysoftware.com/";
  List<String> dogImages = new List();

//Do login Stuff
  void login(String username, String password) async {
    var credentials = {'username': username, 'password': password};
    SharedPreferences prefs = await SharedPreferences.getInstance();
    http.post('${BASE_URL}login/', body: json.encode(credentials)).then((data) {
      //Decoding json
      Map<String, dynamic> jsondata = json.decode(data.body);

      if (jsondata.containsKey("token")) {
//Store token to prefs
        prefs.setString("token", jsondata['token']);
        var credentials = {'username': username, 'password': password};
        prefs.setString("credentials", credentials.toString());
      }
      print('Response: ${data.body}');
      print('Token: ${prefs.getString("token")}');
      print('Credentials: ${prefs.getString("credentials")}');
      getAlertsReceived();
    });
  }

  Future<List<Alert>> getAlertsSent() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    var headers = {"Authorization": "JWT $token"};
    List<Alert> alerts = [];
    http
        .get('${BASE_URL}communications/api/alertes/', headers: headers)
        .then((data) {
      var res = json.decode(data.body)['results'];
      res.forEach((a) => alerts.add(Alert.fromJson(a)));
      print(json.decode(data.body).toString());
    });
    return alerts;
  }

  Future<List<Alert>> apiAlertSent() async {
    HttpClient httpClient = new HttpClient();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    List<Alert> alerts = [];

    HttpClientRequest request = await httpClient
        .getUrl(Uri.parse('${BASE_URL}communications/api/alertes/'));
    request.headers.set('Authorization', 'JWT $token');
    //request.add(utf8.encode(json.encode(jsonMap)));
    HttpClientResponse response = await request.close();
    // todo - you should check the response.statusCode
    String reply = await response.transform(utf8.decoder).join();

    var res = json.decode(reply)['results'];
    res.forEach((a) => alerts.add(Alert.fromJson(a)));
    //print(json.decode(res).toString());
    httpClient.close();
    return alerts;
  }

  Future<List<Alert>> apiAlertReceived() async {
    HttpClient httpClient = new HttpClient();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    List<Alert> alerts = [];

    HttpClientRequest request = await httpClient.getUrl(
        Uri.parse('${BASE_URL}communications/api/alerte-receive-status/'));
    request.headers.set('Authorization', 'JWT $token');
    //request.add(utf8.encode(json.encode(jsonMap)));
    HttpClientResponse response = await request.close();
    // todo - you should check the response.statusCode
    String reply = await response.transform(utf8.decoder).join();

    var res = json.decode(reply)['results'];
    res.forEach((a) => alerts.add(Alert.fromJson(a)));
    print(json.decode(reply));
    httpClient.close();
    return alerts;
  }

  Future<List<String>> fetchDog(List<String> data) async {
    final response = await http.get('https://dog.ceo/api/breeds/image/random');
    if (response.statusCode == 200) {
      data.add(json.decode(response.body)['message']);
    } else {
      throw Exception('Failed to load images');
    }
    return dogImages;
  }

  Future<List<Alert>> getAlertsReceived() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    var headers = {"Authorization": "JWT $token"};
    http
        .get('${BASE_URL}communications/api/alerte-receive-status/',
            headers: headers)
        .then((data) {
      print(json.decode(data.body).toString());
    });
  }

//Do Return the Token back
  Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }
}
