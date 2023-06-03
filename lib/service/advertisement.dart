import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../styles/common Color.dart';
import '../widgets/toaster.dart';

class AdvertisementControl extends GetConnect {
  late int userId;
  String? service;
  Future<http.Response> advertisementApi(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('UserID')!;
    service = prefs.getString('ip');
    final String _baseUrl = '${service}FP802S3/';
    final ip = Uri.parse(_baseUrl);
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    };
    const json =
        '{"data": {"p25": "1","p89": 1,"p90": 10,"p91": "PORTALADVID","p92": null,"p93": null,"p95": "84"}}';
    final response =
        await http.post(ip, headers: headers, body: json.toString());
    final data = jsonDecode(response.body);
    String val = ('${data['Output']['status']['message']}');
    if (response.statusCode == 200) {
      return response;
    } else {
      toaster(context, val, red, Icons.error);
      throw Exception('Invalid Otp');
    }
  }
}
