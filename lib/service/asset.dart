import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AssetControl extends GetConnect {
  RxInt index = 10.obs;
  RxList<dynamic> assetData = <dynamic>[].obs;

  changeStatus(int? buildingId,int? floorId,int? spotId,int? division) async {
    index = index + 10;
    assetApi(buildingId,floorId,spotId,division);
  }

  late int userId;
  String? service;
  Future<http.Response> assetApi(int? buildingId,int? floorId,int? spotId,int? division) async {
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
        '{"data": {"p1": null,"p2": null,"p3": null,"p4": null,"p5": $buildingId,"p6": $floorId,"p7": $spotId,"p8": $division,,"p9": null,"p10": "","p11": "","p12": "","p13": null,"p14": null,"p15": 1,"p16": $index,"p17": "AssetIDPK","p18": "null","p19": "$userId"}}';
    final response =
        await http.post(ip, headers: headers, body: json.toString());
    final data = jsonDecode(response.body);
    String val = ('${data['Output']['status']['message']}');
    if (response.statusCode == 200) {
      final value = (data['Output']['data']);
      assetData.assignAll(value);
      return response;
    } else {
      throw Exception('Invalid Otp');
    }
  }
}
