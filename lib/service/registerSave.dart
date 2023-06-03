import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../styles/common Color.dart';
import '../widgets/toaster.dart';

class RegisterSaveControl extends GetConnect {
  List value = [];
  String? service;

  ///ccm complaints_save
  late int userId;
  Future<http.Response> registerSaveApi(
      BuildContext context,
      int? contractId,
      int? locationId,
      int? buildingId,
      int? floorId,
      int? spotId,
      int? natureComplaintID,
      int? ccmComplaintTypeID,
      int? divisionId,
      int? assetId,
      String? description,
      String? fromDate,
      String? mobNo,
      String? mail,
      int? discipline,
      int? nameID,
      String? newNatureComplaint,
      String? newName,
      int? modIndex,
      int? woID) async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('UserID')!;
    service = prefs.getString('ip');
    final String _baseUrl = '${service}FP290S1/';
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd h:mm a');
    final String currentDate = formatter.format(now);
    final ip = Uri.parse(_baseUrl);
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    };
    final json =
        '{"data": [{"P1": "","P2": "","P3": "","P4": "$currentDate","P5": null,"P6": null,"P7": null,"P8": "$description","P9": "","P10": "$mobNo","P11": 0,"P12": 5,"P13": 0,"P14": 0,"P15": "$newNatureComplaint","P16": 0,"P17": 0,"P18": "$newName","P19": null,"P20": null,"P21": 0,"P22": 0,"P23": null,"P24": null,"P25": null,"P26": null,"P27": "$fromDate","P28": "","P29":$userId,"P30": "","P31": "","P32": null,"P33": "","P34": "","P35": "","P36": "","P37": "","P38": "$mail","P39": 0,"P40": 0,"P41": null,"P42": null,"P43": null,"P44": null,"P45": "","P46": "","P47": "","P48": "","P49": 0,"P50": 2,"P51": $contractId,"P52": $locationId,"P53": $buildingId,"P54": $floorId,"P55": $spotId,"P56": "","P57": $divisionId,"P58": $discipline,"P59": $nameID,"P60": $natureComplaintID,"P61": "","P62": $ccmComplaintTypeID,"P63": "","P64": $modIndex,"P65": $woID,"P66": $ccmComplaintTypeID,"P67": null,"P68": null,"P69": $assetId,"P70": null,"P71": null,"P72": 1,"P73": 0,"P74": 1,"P75": null,"P76": 0,"P77": null  }]}';
    final response =
        await http.post(ip, headers: headers, body: json.toString());
    final data = jsonDecode(response.body);
    String val = ('${data[0]['status']['message']}');
    if (response.statusCode == 200) {
      String error = ('${data[0]['status']['code']}');
      if (error == "400") {
        toaster(context, val, red, Icons.error);
      } else {
        value = data;
        toaster(context, val, trending8, Icons.check);
      }
      return response;
    } else {
      toaster(context, val, red, Icons.error);
      throw Exception('Invalid');
    }
  }
}
