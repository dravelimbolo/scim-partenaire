import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart' show Response;

import 'propriete.model.dart';

class ProprieteProvider with ChangeNotifier {
  static const String domain =
      'https://scim.pythonanywhere.com/';

  List<Propriete> _proprietes = [];
  String? email;
  String? token;

  ProprieteProvider({
    required this.email,
    required this.token,
    required List<Propriete> proprietes,
  }) : _proprietes = proprietes;


  factory ProprieteProvider.fromJson(List<dynamic> jsonProprieteList) {
    final List<Propriete> proprieteList = [];
    for (Map<String, dynamic> jsonPropriete in jsonProprieteList) {
      proprieteList.insert(0, Propriete.fromJson(jsonPropriete));
    }
    return ProprieteProvider(email: null, token: null, proprietes: proprieteList);
  }

  List<Propriete> get proprietes {
    return _proprietes;
  }



  void clear() {
    _proprietes.clear();
  }

  Future<List<Propriete>> fetchPropriete() async {
    try {
      final Uri url = Uri.parse('${domain}propriete-list/');
      final Response response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'TOKEN $token',
        },
      );

      final List<dynamic> jsonProprietes = json.decode(response.body);
      final ProprieteProvider proprieteProvider = ProprieteProvider.fromJson(jsonProprietes);
      _proprietes = proprieteProvider.proprietes;
      return proprieteProvider.proprietes;
    } catch (error) {
      throw error.toString();
    }
  }

  Future<List<Propriete>> fetchRechPropriete(
    String? arrondisScim,
    String? typeSubScim,
    int? nombreChambres,
    int? nombreSalons,
    String? montantScimMin,
    String? montantScimMax,
  ) async {
    try {
      final Map<String, String> queryParams = {
        'arrondisScim': arrondisScim ?? '',
        'typeSubScim': typeSubScim ?? '',
        'nombreChambres': nombreChambres?.toString() ?? '',
        'nombreSalons': nombreSalons?.toString() ?? '',
        'montantScimMin': montantScimMin ?? '',
        'montantScimMax': montantScimMax ?? '',
      };
      final Uri url = Uri.parse('${domain}propriete-recherche/')
          .replace(queryParameters: queryParams);
      queryParams.clear();
      final Response response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'TOKEN $token',
        },
      );

      final List<dynamic> jsonProprietes = json.decode(response.body);
      final ProprieteProvider proprieteProvider =
          ProprieteProvider.fromJson(jsonProprietes);
      _proprietes = proprieteProvider.proprietes;
      return proprieteProvider.proprietes;
    } catch (error) {
      throw error.toString();
    }
  }

  Future<List<Propriete>> fetchSauvPropriete() async {
    try {
      
      final Uri url = Uri.parse('${domain}sauvegarde-list/');
      final Response response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'TOKEN $token',
        },
      );

      final List<dynamic> jsonProprietes = json.decode(response.body);
      final ProprieteProvider proprieteProvider =
          ProprieteProvider.fromJson(jsonProprietes);
      _proprietes = proprieteProvider.proprietes;
      return proprieteProvider.proprietes;
    } catch (error) {
      throw error.toString();
    }
  }

  List<Propriete> get locationPropriete {

    return proprietes.where((propriete) =>  propriete.etatProScim == "louer").toList();
  }

  List<Propriete> get avendrePropriete {
    return proprietes.where((propriete) => propriete.etatProScim == "vendre").toList();
  }

  List<Propriete> get commercialPropriete {
    return proprietes.where((propriete) => propriete.typeProScim == "commercial").toList();
  }

  List<Propriete> get residentielPropriete {
    return proprietes.where((propriete) => propriete.typeProScim == "residentiel").toList();
  }


}