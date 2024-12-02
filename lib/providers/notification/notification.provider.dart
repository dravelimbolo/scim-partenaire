import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart' show Response;

import 'notification.model.dart';

class NotificatProvider with ChangeNotifier {
  static const String domain =
      'https://scim-immo.com/';

  List<Notificat> _notificats = [];
  String? email;
  String? token;

  NotificatProvider({
    required this.email,
    required this.token,
    required List<Notificat> notificats,
  }) : _notificats = notificats;


  factory NotificatProvider.fromJson(List<dynamic> jsonNotificatList) {
    final List<Notificat> notificatList = [];
    for (Map<String, dynamic> jsonNotificat in jsonNotificatList) {
      notificatList.insert(0, Notificat.fromJson(jsonNotificat));
    }
    return NotificatProvider(email: null, token: null, notificats: notificatList);
  }

  List<Notificat> get notificats {
    return _notificats;
  }



  void clear() {
    _notificats.clear();
  }

  Future<List<Notificat>> fetchNotificat() async {
    try {
      final Uri url = Uri.parse('${domain}notification-list/');
      final Response response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'TOKEN $token',
        },
      );

      final List<dynamic> jsonNotificats = json.decode(response.body);
      final NotificatProvider notificatProvider = NotificatProvider.fromJson(jsonNotificats);
      _notificats = notificatProvider.notificats;
      notifyListeners();
      return _notificats;
    } catch (error) {
      throw error.toString();
    }
  }

  Future<void> updateNotification(String codeNotification) async {
    try {
      final Uri url = Uri.parse('${domain}notification/$codeNotification/');
      final Response response = await http.put(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'TOKEN $token',
        },
      );

      if (response.statusCode == 200) {
        print('Notification mise à jour avec succès.');
      } else {
        print('Erreur: ${response.body}');
      }
    } catch (error) {
      print('Erreur: $error');
    }
  }

}