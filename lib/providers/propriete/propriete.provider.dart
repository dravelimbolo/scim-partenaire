import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart' show Response;
import 'package:super_paging/super_paging.dart';

import 'propriete.model.dart';
import 'propriete_paging_source.dart';



class ProprieteProvider with ChangeNotifier {
  static const String domain = 'https://scim-immo.com/';
  List<Propriete> _proprietes = [];
  final String? email;
  final String? token;

  late Pager<int, Propriete> pager;

  ProprieteProvider({required this.email, required this.token, required List<Propriete> proprietes}) {
    _proprietes = proprietes;
    pager = Pager<int, Propriete>(
      initialKey: 1,
      config: const PagingConfig(
        pageSize: 2,
        initialLoadSize: 2,
        prefetchIndex: 1,
      ),
      pagingSourceFactory: () => ProprietePagingSource(token: token),
    );
  }

  List<Propriete> get proprietes => _proprietes;

  @override
  void dispose() {
    super.dispose();
    pager.dispose();
  }




  factory ProprieteProvider.fromJson(List<dynamic> jsonProprieteList) {
    final List<Propriete> proprieteList = [];
    for (Map<String, dynamic> jsonPropriete in jsonProprieteList) {
      proprieteList.insert(0, Propriete.fromJson(jsonPropriete));
    }
    return ProprieteProvider(email: null, token: null, proprietes: proprieteList);
  }


  void clear() {
    _proprietes.clear();
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




Future<void> addPropriete(
    String titreScim,
    String cautionScim,
    String montantScim,
    String etatProScim,
    String typeProScim,
    String typeSubScim,
    String addresseScim,
    String quartierScim,
    String arrondisScim,
    String repereadScim,
    String nombreChambres,
    String nombreSalons,
    String nombreDouche,
    String nombreToilette,
    bool aClimatiseur,
    bool aTelephone,
    bool aCuisine,
    bool aGym,
    bool aTelevision,
    bool aWifi,
    bool aPiscine,
    bool aGardien,
    bool aCourant,
    bool aEau,
    bool aParking,
    bool aBacheAEau,
    bool aChauffeEau,
    bool aGroupeElectrogene,
    String description,
    List<File> imageFiles,
    File? documentFile,
  ) async {
    try {
      final Uri url = Uri.parse('${domain}creation-list/');
      final request = http.MultipartRequest('POST', url);
      request.fields['titre_scim'] = titreScim;
      request.fields['caution_scim'] = cautionScim.toString();
      request.fields['montant_scim'] = montantScim.toString();
      request.fields['etat_pro_scim'] = etatProScim;
      request.fields['type_pro_scim'] = typeProScim;
      request.fields['type_sub_scim'] = typeSubScim;
      request.fields['addresse_scim'] = addresseScim;
      request.fields['quartier_scim'] = quartierScim;
      request.fields['arrondis_scim'] = arrondisScim;
      request.fields['reperead_scim'] = repereadScim;
      request.fields['nombre_chambres'] = nombreChambres;
      request.fields['nombre_salons'] = nombreSalons;
      request.fields['nombre_douche'] = nombreDouche;
      request.fields['nombre_toilette'] = nombreToilette;
      request.fields['a_climatiseur'] = aClimatiseur.toString();
      request.fields['a_telephone'] = aTelephone.toString();
      request.fields['a_cuisine'] = aCuisine.toString();
      request.fields['a_gym'] = aGym.toString();
      request.fields['a_television'] = aTelevision.toString();
      request.fields['a_wifi'] = aWifi.toString();
      request.fields['a_piscine'] = aPiscine.toString();
      request.fields['a_gardien'] = aGardien.toString();
      request.fields['a_courant'] = aCourant.toString();
      request.fields['a_eau'] = aEau.toString();
      request.fields['a_parking'] = aParking.toString();
      request.fields['a_bache_a_eau'] = aBacheAEau.toString();
      request.fields['a_chauffe_eau'] = aChauffeEau.toString();
      request.fields['a_groupe_electrogene'] = aGroupeElectrogene.toString();
      request.fields['description'] = description.toString();

      for (int i = 0; i < imageFiles.length; i++) {
        final http.MultipartFile imageFile = await http.MultipartFile.fromPath(
          'uploaded_images',
          imageFiles[i].path,
        );
        request.files.add(imageFile);
      }

      if (documentFile != null) {
        final http.MultipartFile document = await http.MultipartFile.fromPath(
          'document',
          documentFile.path,
        );
        request.files.add(document);
      }

      request.headers['Authorization'] = 'TOKEN $token';
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      
      if (response.statusCode == 201) {
        // Si la requête réussit, ne rien faire
      } else {
        throw 'Failed to add propriete';
      }
    } catch (error) {
      throw error.toString();
    }
  }

  Future<void> deletePropriete(String codeScim) async {
    try {
      final Uri url = Uri.parse('${domain}supprime-list/$codeScim/delete/');
      await http.delete(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'TOKEN $token',
        },
      );
    } catch (error) {
      throw error.toString();
    }
  }



}