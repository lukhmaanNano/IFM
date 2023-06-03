import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AdminImageRegistrySaveControl extends GetConnect {
  late int userId;
  String? service;
  var jsonData = [];

  Future<http.Response> adminImageSaveApi(BuildContext context,
      int? complaintId, String? fromDate, String? toDate, List myList) async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('UserID')!;
    service = prefs.getString('ip');

    final String _baseUrl = '${service}FP10S1/';
    for (var file in myList) {
      jsonData.addAll({
        {
          "p1": 0,
          "p2": "",
          "p3": "${file['name']}",
          "p4": "",
          "p5": "",
          "p6": "data:image/png;base64,${file['image']}",
          "p7": "",
          "p8": "png",
          "p9": "image",
          "p10": 0,
          "p11": 0,
          "p12": false,
          "p13": "",
          "p14": complaintId,
          "p15": 290,
          "p16": 0,
          "p17": true,
          "p18": false,
          "p19": 1,
          "p20": "$fromDate",
          "p21": "$userId",
          "p22": "$toDate"
        }
      });
    }
    final sendDate = {'data': jsonData};
    final ip = Uri.parse(_baseUrl);
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    };
    final response = await http.post(ip,
        headers: headers, body: jsonEncode(sendDate).toString());
    final data = jsonDecode(response.body);
    String val = ('${data[0]['status']['message']}');
    if (response.statusCode == 200) {
      jsonData.clear();
      myList.clear();
      return response;
    } else {
      throw Exception('Invalid Otp');
    }
  }
}
