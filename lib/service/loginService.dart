import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../config.dart';
import '../styles/common Color.dart';
import '../widgets/snackBar.dart';

class LoginController extends GetConnect {
  String? service;
  RxInt loggedID = 0.obs;
  Future<http.Response> loginApi(
      BuildContext context, String? userName, String? password) async {
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String name = stringToBase64.encode(userName.toString());
    String pass = stringToBase64.encode(password.toString());
    final prefs = await SharedPreferences.getInstance();
    // service = prefs.getString('ip');
    service = ApiConfig.service;
    String api = ApiConfig.loginService;
    // final url = Uri.parse('$service$api');
    final url = Uri.parse('$service$api');
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    };
    final json =
        '{"data": {"username": "$name","password": "$pass","type": "WebPortal","ServcerIP": "","AppCategoryID": "1","LoginType": "login"}}';
    final response =
        await http.post(url, headers: headers, body: json.toString());
    final value = jsonDecode(response.body);
    if (response.statusCode == 400) {
      String err = 'something went wrong!';
      StackDialog.show(err, 'Please check the network', Icons.error, red);
    }
    if ('${value['Output']['status']['code']}' == '400') {
      String error = ('Invalid UserName are Password');
      StackDialog.show(error, 'Please check', Icons.error, red);
    }
    if ('${value['Output']['status']['message']}' == 'User already logged in') {
      loggedID = (value['Output']['error']['data']);
    }
    if (response.statusCode == 200) {
      String name = ('${value['Output']['data']['username']}');
      String password = ('${value['Output']['data']['password']}');
      int userID = (value['Output']['data']['userid']);
      int userGroupID = (value['Output']['data']['UserGroupID']);
      int sessionId = (value['Output']['data']['sessionid']);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('UserName', name);
      await prefs.setString('Password', password);
      await prefs.setInt('UserID', userID);
      await prefs.setInt('UserGroupID', userGroupID);
      await prefs.setInt('SessionId', sessionId);
      return response;
    } else {
      throw Exception('Error');
    }
  }
}
