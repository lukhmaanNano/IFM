import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../styles/common Color.dart';
import '../widgets/snackBar.dart';
import '../widgets/toaster.dart';

class ChangePasswordController extends GetConnect {
  late int userId;
  late String password;
  String? service;
  Future<http.Response> changePasswordApi(
      BuildContext context, String? newPass, String? confirmPass) async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('UserID')!;
    password = prefs.getString('Password')!;
    service = prefs.getString('ip');
    final String _baseUrl = '${service}FPU8S3/';
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String pass1 = stringToBase64.encode(newPass.toString());
    String pass2 = stringToBase64.encode(confirmPass.toString()); //--
    final ip = Uri.parse(_baseUrl);
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    };
    final json =
        '{"data": {"UserID": "$userId","OldPassword": "$password","NewPassword": "$pass1","ConfirmPassword": "$pass2"}}';
    final response =
        await http.post(ip, headers: headers, body: json.toString());
    final data = jsonDecode(response.body);
    String val = ('${data['Output']['status']['message']}');
    if (response.statusCode == 200) {
      String error = ('${data['Output']['status']['code']}');
      if (error == "400") {
        String err = ('Password Does' 't change');
        toaster(context, err, red, Icons.error);
      } else {
        // toaster(context, val, trending8, Icons.check);
        StackDialog.show(val, 'Now you can access our application',
            Icons.verified_outlined, trending4);
      }

      return response;
    } else {
      toaster(context, val, red, Icons.error);
      throw Exception('Invalid Otp');
    }
  }
}
