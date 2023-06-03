import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/state_manager.dart';

class ListenerControl extends GetxController {
  RxInt count = 10.obs;
  RxList<dynamic> drop1 = <dynamic>[].obs;

  changeStatus() {
    count = count + 10;
    divisionApi();
  }

  Future<http.Response> divisionApi() async {
    const String _baseUrl = 'http://13.127.67.252:5040/FPC13S3/';
    final ip = Uri.parse(_baseUrl);
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    };
    final json =
        '{"data": {"p1": null,"p2": null,"p3": null,"p4": null,"p5": null,"p6": null,"p7": null,"p8": null,"p9": null,"p10": "","p11": "","p12": "","p13": null,"p14": null,"p15": 1,"p16": $count,"p17": "ComplaintnatureIDPK","p18": "null","p19": "84"}}';
    final response =
        await http.post(ip, headers: headers, body: json.toString());
    final data = jsonDecode(response.body);
    String val = ('${data['Output']['status']['message']}');
    final value = (data['Output']['data']);
    if (response.statusCode == 200) {
      drop1.assignAll(value);
      return response;
    } else {
      throw Exception('Invalid Otp');
    }
  }
}
