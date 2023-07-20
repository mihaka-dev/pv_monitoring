import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_pv_monitoring/entity/detail_system.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class PVData {
  String token = '';
  String apiKey = "904a6864ef371a9a7b74b7bc76ed54b64f39db1f";
  String systemId = 'FZK6D';
  final storage = const FlutterSecureStorage();

  loginVCOM() async {
    var url = Uri.https('api.meteocontrol.de', '/v2/login');
    var body = {
      'grant_type': 'password',
      'client_id': 'FZK6D',
      'username': 'Alfa-Arif',
      'password': 'Alfa_Arif1234',
      'client_secret': 'AYB=~9_f-BvNoLt8+x=3maCq)>/?@Nom',
    };

    var header = {'Content-Type': 'application/x-www-form-urlencoded'};
    var response = await http.post(url, body: body, headers: header);
    Map responseBody = json.decode(response.body);
    token = responseBody["access_token"];
    storage.write(key: 'token', value: token);
    debugPrint('Response status: ${response.statusCode}');
    debugPrint('Response body: $token');
  }

  Future<bool> checkToken() async {
    var savedToken = await storage.read(key: 'token');
    if (savedToken != null) {
      token = savedToken;
      return true;
    }
    return false;
  }

  Future<DetailSystem> detailSystem() async {
    var url = Uri.https('api.meteocontrol.de', '/v2/systems/$systemId');
    var response = await http.get(url,
        headers: {"Authorization": 'Bearer $token', "X-API-KEY": apiKey});
    Map<String, dynamic> responseBody = json.decode(response.body);
    return DetailSystem.fromJson(responseBody);
  }

  Future listMeters() async {
    var url = Uri.https('api.meteocontrol.de', '/v2/systems/$systemId/meters');
    var response = await http.get(url,
        headers: {"Authorization": 'Bearer $token', "X-API-KEY": apiKey});
    Map<String, dynamic> responseBody = json.decode(response.body);
    debugPrint(responseBody.toString());
  }

  Future<Map> currentPower() async {
    DateTime now = DateTime.now();
    var dateFormatter = DateFormat('yyyy-MM-ddTHH:mm:ss');
    var from = dateFormatter.format(now.subtract(const Duration(minutes: 15)));
    var to = dateFormatter.format(now);

    var url = Uri.https(
        'api.meteocontrol.de',
        '/v2/systems/FZK6D/basics/abbreviations/C_P/measurements',
        {'from': from, 'to': to});
    var response = await http.get(url,
        headers: {"Authorization": 'Bearer $token', "X-API-KEY": apiKey});
    Map<String, dynamic> responseBody = json.decode(response.body);
    debugPrint(response.body);

    debugPrint('This my token : $token');
    return responseBody["data"]["C_P"][0];
  }
}
