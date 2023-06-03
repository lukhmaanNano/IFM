import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SpotControl extends GetConnect {
  RxInt index = 10.obs;
  RxList<dynamic> spotData = <dynamic>[].obs;

  changeStatus(contractId, locationId, buildingId, floorId) async {
    index = index + 10;
    spotApi(contractId, locationId, buildingId, floorId);
  }

  late int userId;
  String? service;
  Future<http.Response> spotApi(
      int? contractId, int? locationId, int? buildingId, int? floorId) async {
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
        '{"data": {"p1": null,"p2": null,"p3": $contractId,"p4": $locationId,"p5": $buildingId,"p6": $floorId,"p7": null,"p8": null,"p9": null,"p10": "","p11": "","p12": "","p13": null,"p14": null,"p15": 1,"p16": $index,"p17": "SpotIDPK","p18": "null","p19": "$userId"}}';
    final response =
        await http.post(ip, headers: headers, body: json.toString());
    final data = jsonDecode(response.body);
    String val = ('${data['Output']['status']['message']}');
    if (response.statusCode == 200) {
      final value = (data['Output']['data']);
      spotData.assignAll(value);
      return response;
    } else {
      throw Exception('Invalid Otp');
    }
  }
}
