import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../config.dart';
import '../styles/common Color.dart';
import '../widgets/toaster.dart';

class TrackViewControl extends GetConnect {
  List<dynamic> trackViewData = [];
  String? service;
  late int userId;
  Future<http.Response> trackViewApi(
      BuildContext context, int? complaintId) async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('UserID')!;
    service = prefs.getString('ip');
    final String _baseUrl = '${service}FPC13S3/';
    final ip = Uri.parse(_baseUrl);
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    };
    final json =
        '{"data": {"p1": null,"p2": $complaintId,"p3": null,"p4": null,"p5": null,"p6": null,"p7": null,"p8": null,"p9": null,"p10": "","p11": "","p12": "","p13": null,"p14": null,"p15": 1,"p16": 10,"p17": "PORTALCOMPLAINTID","p18": "null","p19": "$userId"}}';
    final response =
        await http.post(ip, headers: headers, body: json.toString());
    final data = jsonDecode(response.body);
    final value = (data['Output']['data']);
    String val = ('${data['Output']['status']['message']}');
    if (response.statusCode == 200) {
      trackViewData = value;
      return response;
    } else {
      toaster(context, val, red, Icons.error);
      throw Exception('Invalid Otp');
    }
  }
}
