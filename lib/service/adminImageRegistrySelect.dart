import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../config.dart';
import '../styles/common Color.dart';
import '../widgets/toaster.dart';

class AdminImageRegistrySelectControl extends GetConnect {
  late int userId;
  String? service;
  List<dynamic> value = [];
  Future<http.Response> adminImageSelectApi(
    BuildContext context,
    int? complaintId,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('UserID')!;
    service = prefs.getString('ip');
    final String _baseUrl = '${service}FP10S3/';
    final ip = Uri.parse(_baseUrl);
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    };
    final json =
        '{"data": {"p1": null,"p2": null,"p3": null,"p4": null,"p5": null,"p6": null,"p7": null,"p8": null,"p9": null,"p10": null,"p11": null,"p12": null,"p13": null,"p14": $complaintId,"p15": 290,"p16": null,"p17": null,"p18": null,"p19": null,"p20": null,"p21": null,"p22": null,"p23": null,"p24": null,"p25": null,"p26": 1,"p27": 10,"p28": "AdminImageID","p29": null,"p30": null,"p31": 1,"p32": 1}}';
    final response =
        await http.post(ip, headers: headers, body: json.toString());
    final data = jsonDecode(response.body);
    String val = ('${data['Output']['status']['message']}');
    final values = (data['Output']['data']);
    if (response.statusCode == 200) {
      value = values;
      return response;
    } else {
      toaster(context, val, red, Icons.error);
      throw Exception('Invalid Otp');
    }
  }
}
