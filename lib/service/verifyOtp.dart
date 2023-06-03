import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../styles/common Color.dart';
import '../widgets/toaster.dart';

class OTPController extends GetConnect {
  String? service;
  Future<http.Response> otpApi(
      BuildContext context, String? email, String? otp) async {
    final prefs = await SharedPreferences.getInstance();
    service = prefs.getString('ip');
    final String _baseUrl = '${service}FPU9S3/';
    final ip = Uri.parse(_baseUrl);
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    };
    final json =
        '{"data":{"SecurityCode_int":"$otp","UserEmail_varchar":"$email","Password_varchar":""}}';
    final response =
        await http.post(ip, headers: headers, body: json.toString());
    final data = jsonDecode(response.body);
    String val = ('${data['Output']['status']['message']}');
    if (response.statusCode == 200) {
      toaster(context, val, trending8, Icons.check);
      return response;
    } else {
      toaster(context, val, red, Icons.error);
      throw Exception('Invalid Otp');
    }
  }
}
