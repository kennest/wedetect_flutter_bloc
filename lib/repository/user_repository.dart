import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity/connectivity.dart';

class UserRepository {
  var dio = Dio();
  var token = '';

  Future<String> authenticate({
    @required String username,
    @required String password,
  }) async {
    await Future.delayed(Duration(seconds: 1));
    var connectivityResult = await (new Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.mobile) {
      http
          .post(
        "https://wa.weflysoftware.com/login/",
        body: json.encode({'username': username, 'password': password}),
      )
          .then((r) {
        Map<String, dynamic> jsondata = json.decode(r.body);
        if (jsondata.containsKey("token")) {
          token = jsondata['token'];
        }
      });
    }
    return token;
  }

  Future<void> deleteToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.setString('token', null);
    print('token deleted');
    await Future.delayed(Duration(seconds: 1));
  }

  Future<void> persistToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (token != null) {
      prefs.setString('token', 'JWT $token');
      print('token persisted');
    }
    await Future.delayed(Duration(seconds: 1));
  }

  Future<bool> hasToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    await Future.delayed(Duration(seconds: 1));
    if (token != null) {
      print('token existed');
      return true;
    } else {
      print('token null');
      return false;
    }
  }

  Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}
