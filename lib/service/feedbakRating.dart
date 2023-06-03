import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import '../styles/common Color.dart';
import '../widgets/toaster.dart';

class FeedbackRating extends GetConnect {
  late int UserID;
  RxInt status= 0.obs;
  String? service;
  Future<http.Response> feedbackRatingApi(BuildContext context,
      int? complaintIDPK, double? rating, String? feedback) async {
    final prefs = await SharedPreferences.getInstance();
    UserID = prefs.getInt('UserID')!;
    service = prefs.getString('ip');
    final String baseUrl = '${service}FPC13S3/';
    final ip = Uri.parse(baseUrl);
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    };
    final json =
        '{"data": {"p1": null,"p2": $complaintIDPK,"p3": null,"p4": null,"p5": null,"p6": null,"p7": null,"p8": null,"p9":$rating,"p10": "$feedback","p11": "","p12": "$feedback","p13": "","p14": "","p15": "","p16": "","p17": "RATINGSUPDATE","p18": "null","p19": "$UserID"}}';
    final response =
        await http.post(ip, headers: headers, body: json.toString());
    final data = jsonDecode(response.body);
    final val = (data['Output']['data'][0]['RatingsUpdated']);
    if (response.statusCode == 200) {
      if (val == 0) {
        toaster(context, 'FeedBack Saved successfully', trending8, Icons.check);
        status.value=val;
      } else {
        toaster(context, 'FeedBack Already Saved', trending4, Icons.check);
        status.value=val;
      }
      return response;
    } else {
      toaster(context, val, red, Icons.error);
      throw Exception('Check the network call');
    }
  }
}
