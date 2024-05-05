import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart' show Response;

import 'bannier.model.dart';

class BannierProvider with ChangeNotifier {
  static const String domain =
      'https://scim.pythonanywhere.com/';

  List<Bannier> _banniers = [];
  String? email;
  String? token;

  BannierProvider({
    required this.email,
    required this.token,
    required List<Bannier> banniers,
  }) : _banniers = banniers;


  factory BannierProvider.fromJson(List<dynamic> jsonBannierList) {
    final List<Bannier> bannierList = [];
    for (Map<String, dynamic> jsonBannier in jsonBannierList) {
      bannierList.insert(0, Bannier.fromJson(jsonBannier));
    }
    return BannierProvider(email: null, token: null, banniers: bannierList);
  }

  List<Bannier> get banniers {
    return _banniers;
  }



  void clear() {
    _banniers.clear();
  }

  Future<List<Bannier>> fetchBannier() async {
    try {
      final Uri url = Uri.parse('${domain}bannier-list/');
      final Response response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'TOKEN $token',
        },
      );

      final List<dynamic> jsonBanniers = json.decode(response.body);
      final BannierProvider bannierProvider = BannierProvider.fromJson(jsonBanniers);
      _banniers = bannierProvider.banniers;
      return bannierProvider.banniers;
    } catch (error) {
      throw error.toString();
    }
  }

}