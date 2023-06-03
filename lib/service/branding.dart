import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config.dart';
import '../styles/common Color.dart';
import '../widgets/toaster.dart';

class BrandingControl extends GetConnect {
  List<dynamic> brandingData = [];
  // String? service;
  static const String _baseUrl = '${ApiConfig.service}FP95S3/';
  Future<http.Response> brandingApi(BuildContext context) async {
    final ip = Uri.parse(_baseUrl);
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    };
    const json =
        '{"data": {"p1": null,"p2": null,"p3": null,"p4": null,"p5": null,"p6": null,"p7": null,"p8": null,"p9": null,"p10": null,"p11": null,"p12": null,"p13": null,"p14": null,"p15": null,"p16": null,"p17": null,"p18": null,"p19": null,"p20": null,"p21": null,"p22": null,"p23": null,"p24": null,"p25": null,"p26": null,"p27": null,"p28": null,"p29": null,"p30": null,"p31": null,"p32": null,"p33": null,"p34": null,"p35": null,"p36": null,"p37": null,"p38": null,"p39": null,"p40": null,"p41": null,"p42": null,"p43": null,"p44": null,"p45": null,"p46": null,"p47": null,"p48": null,"p49": null,"p50": null,"p51": null,"p52": null,"p53": null,"p54": null,"p55": null,"p56": null,"p57": null,"p58": null,"p59": null,"p60": null,"p61": null,"p62": null,"p63": null,"p64": null,"p65": null,"p66": null,"p67": null,"p68": null,"p69": null,"p70": null,"p71": null,"p72": null,"p73": null,"p74": null,"p75": null,"p76": null,"p77": 1,"p78": 10,"p79": "BrandingID","p80": null,"p81": null,"p82": 1,"p83": 1}}';
    final response =
        await http.post(ip, headers: headers, body: json.toString());
    final data = jsonDecode(response.body);
    String val = ('${data['Output']['status']['message']}');
    final value = (data['Output']['data']);
    if (response.statusCode == 200) {
      brandingData = value;
      return response;
    } else {
      toaster(context, val, red, Icons.error);
      throw Exception('Branding Error');
    }
  }
}
