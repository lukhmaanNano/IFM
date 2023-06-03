import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../styles/common Color.dart';
import '../widgets/snackBar.dart';

class EmailController extends GetConnect {
  String? service;
  Future<http.Response> emailApi(BuildContext context, String? email) async {
    final prefs = await SharedPreferences.getInstance();
    service = prefs.getString('ip');
    final String _baseUrl = '${service}FPU7S3/';
    final ip = Uri.parse(_baseUrl);
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    };
    final json = '{"email":"$email"}';
    final response =
        await http.post(ip, headers: headers, body: json.toString());

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      String val = ('OTP Send Successfully');

      StackDialog.show(val, 'Please check the given mailId',
          Icons.verified_outlined, trending4);
      return response;
    } else {
      throw Exception('Failed to load users');
    }
  }
}
