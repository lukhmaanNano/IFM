import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LocationControl extends GetConnect {
  RxInt index = 10.obs;
  RxList<dynamic> locationData = <dynamic>[].obs;
  changeStatus(contractId) async {
    index = index + 10;
    locationApi(contractId);
  }

  late int userId;
  String? service;
  Future<http.Response> locationApi(int? contractId) async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('UserID')!;
    service = prefs.getString('ip');
    final String baseUrl = '${service}FPC13S3/';
    final ip = Uri.parse(baseUrl);
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    };
    final json =
        '{"data": {"p1": null,"p2": null,"p3": $contractId,"p4": null,"p5": null,"p6": null,"p7": null,"p8": null,"p9": null,"p10": "","p11": "","p12": "","p13": null,"p14": null,"p15": 1,"p16": $index,"p17": "localityidpk","p18": "null","p19": "$userId"}}';
    final response =
        await http.post(ip, headers: headers, body: json.toString());
    final data = jsonDecode(response.body);
    String val = ('${data['Output']['status']['message']}');
    if (response.statusCode == 200) {
      final value = (data['Output']['data']);
      locationData.assignAll(value);
      return response;
    } else {
      throw Exception('Invalid Otp');
    }
  }
}
