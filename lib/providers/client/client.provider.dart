import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart' show Response;

import 'client.model.dart';

class ClientProvider with ChangeNotifier {
  static const String domain =
      'https://scim.pythonanywhere.com/';

  List<Client> _clients = [];
  String? email;
  String? token;

  ClientProvider({
    required this.email,
    required this.token,
    required List<Client> clients,
  }) : _clients = clients;


  factory ClientProvider.fromJson(List<dynamic> jsonClientList) {
    final List<Client> clientList = [];
    for (Map<String, dynamic> jsonClient in jsonClientList) {
      clientList.insert(0, Client.fromJson(jsonClient));
    }
    return ClientProvider(email: null, token: null, clients: clientList);
  }

  List<Client> get clients {
    return _clients;
  }



  void clear() {
    _clients.clear();
  }

  Future<List<Client>> fetchClient() async {
    try {
      final Uri url = Uri.parse('${domain}client-list/');
      final Response response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'TOKEN $token',
        },
      );

      final List<dynamic> jsonClients = json.decode(response.body);
      final ClientProvider clientProvider = ClientProvider.fromJson(jsonClients);
      _clients = clientProvider.clients;
      return clientProvider.clients;
    } catch (error) {
      throw error.toString();
    }
  }

  Future<void> updateMonProfil(String newPassword) async {
    
    try {
      final Uri url = Uri.parse('${domain}change-password/');
      Map<String, dynamic> tempMonProfil = {
        'new_password': newPassword,
      };

      final Response response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'TOKEN $token',
        },
        body: json.encode(tempMonProfil),
      );
      if (response.statusCode == 200) {
      // Mot de passe mis à jour avec succès
      } else {
        throw 'Erreur lors de la mise à jour du mot de passe: ${response.statusCode}';
      }

    } catch (error) {
      throw error.toString();
    }
  }

  Future<void> editImageProfil(
    File image,
  ) async {
    try {
      final Uri url = Uri.parse('${domain}change-client-image/');
      
      final request = http.MultipartRequest('PUT', url);
      
      String generateImageFileName(String usermon) {
        // Obtene la date actuelle sous forme de millisecondes depuis l'Époque Unix.
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        
        // Génére un nombre aléatoire entre 0 et 999 pour plus de diversité.
        final random = Random().nextInt(1000);
        
        // Combine le nom du plat, le timestamp et le nombre aléatoire pour créer un nom de fichier unique.
        final fileName = '$usermon-$timestamp-$random.jpg';
        
        return fileName;
      }

      final fileName = generateImageFileName(clients.first.user.username);
      request.files.add(
        http.MultipartFile(
          'image',
          image.readAsBytes().asStream(),
          image.lengthSync(),
          filename: fileName,
        ),
      );
    
      request.headers['Authorization'] = 'TOKEN $token';

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonMonProfil = json.decode(response.body);
        clients.insert(0, Client.fromJson(jsonMonProfil));
        notifyListeners();
      } else {
        throw 'Erreur lors de l\'ajout: ${response.statusCode}';
      }
    } catch (error) {
      throw error.toString();
    }
  }


}