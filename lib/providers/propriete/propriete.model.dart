import 'package:flutter/foundation.dart';

class PartenaireResponse with ChangeNotifier  {
  final int count;
  final String? next;
  final String? previous;
  final List<Propriete> results;

  PartenaireResponse({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory PartenaireResponse.fromJson(Map<String, dynamic> json) {
    return PartenaireResponse(
      count: json['count'],
      next: json['next'],
      previous: json['previous'],
      results: (json['results'] as List)
          .map((result) => Propriete.fromJson(result))
          .toList(),
    );
  }
}


class Propriete with ChangeNotifier{
    String codeScim;
    List<Image> images;
    String titreScim;
    DateTime dateAddScim;
    String? dateApprobation;
    String? dateDesapprobation;
    int cautionScim;
    String montantScim;
    String etatProScim;
    String typeProScim;
    String typeSubScim;
    String addresseScim;
    String quartierScim;
    String arrondisScim;
    String repereadScim;
    int nombreChambres;
    int nombreSalons;
    int nombreDouche;
    int nombreToilette;
    bool aClimatiseur;
    bool aTelephone;
    bool aCuisine;
    bool aGym;
    bool aTelevision;
    bool aWifi;
    bool aPiscine;
    bool aGardien;
    bool aCourant;
    bool aEau;
    bool aParking;
    bool aBacheAEau;
    bool aChauffeEau;
    bool aGroupeElectrogene;
    bool aApprouver;
    bool okApprouver;
    bool desapprouver;
    String description;
    String? document;
    int user;

    Propriete({
        required this.codeScim,
        required this.images,
        required this.titreScim,
        required this.dateAddScim,
        required this.dateApprobation,
        required this.dateDesapprobation,
        required this.cautionScim,
        required this.montantScim,
        required this.etatProScim,
        required this.typeProScim,
        required this.typeSubScim,
        required this.addresseScim,
        required this.quartierScim,
        required this.arrondisScim,
        required this.repereadScim,
        required this.nombreChambres,
        required this.nombreSalons,
        required this.nombreDouche,
        required this.nombreToilette,
        required this.aClimatiseur,
        required this.aTelephone,
        required this.aCuisine,
        required this.aGym,
        required this.aTelevision,
        required this.aWifi,
        required this.aPiscine,
        required this.aGardien,
        required this.aCourant,
        required this.aEau,
        required this.aParking,
        required this.aBacheAEau,
        required this.aChauffeEau,
        required this.aGroupeElectrogene,
        required this.aApprouver,
        required this.okApprouver,
        required this.desapprouver,
        required this.description,
        required this.document,
        required this.user,
    });

    factory Propriete.fromJson(Map<String, dynamic> json) => Propriete(
        codeScim: json["code_scim"],
        images: List<Image>.from(json["images"].map((x) => Image.fromJson(x))),
        titreScim: json["titre_scim"],
        dateAddScim: DateTime.parse(json["date_add_scim"]),
        dateApprobation: json["date_approbation"],
        dateDesapprobation: json["date_desapprobation"],
        cautionScim: json["caution_scim"],
        montantScim: json["montant_scim"],
        etatProScim: json["etat_pro_scim"],
        typeProScim: json["type_pro_scim"],
        typeSubScim: json["type_sub_scim"],
        addresseScim: json["addresse_scim"],
        quartierScim: json["quartier_scim"],
        arrondisScim: json["arrondis_scim"],
        repereadScim: json["reperead_scim"],
        nombreChambres: json["nombre_chambres"],
        nombreSalons: json["nombre_salons"],
        nombreDouche: json["nombre_douche"],
        nombreToilette: json["nombre_toilette"],
        aClimatiseur: json["a_climatiseur"],
        aTelephone: json["a_telephone"],
        aCuisine: json["a_cuisine"],
        aGym: json["a_gym"],
        aTelevision: json["a_television"],
        aWifi: json["a_wifi"],
        aPiscine: json["a_piscine"],
        aGardien: json["a_gardien"],
        aCourant: json["a_courant"],
        aEau: json["a_eau"],
        aParking: json["a_parking"],
        aBacheAEau: json["a_bache_a_eau"],
        aChauffeEau: json["a_chauffe_eau"],
        aGroupeElectrogene: json["a_groupe_electrogene"],
        aApprouver: json["a_approuver"],
        okApprouver: json["ok_approuver"],
        desapprouver: json["desapprouver"],
        description: json["description"],
        document: json["document"],
        user: json["user"],
    );

    Map<String, dynamic> toJson() => {
        "code_scim": codeScim,
        "images": List<dynamic>.from(images.map((x) => x.toJson())),
        "titre_scim": titreScim,
        "date_add_scim": dateAddScim.toIso8601String(),
        "date_approbation": dateApprobation != null,
        "date_desapprobation": dateDesapprobation != null,
        "caution_scim": cautionScim,
        "montant_scim": montantScim,
        "etat_pro_scim": etatProScim,
        "type_pro_scim": typeProScim,
        "type_sub_scim": typeSubScim,
        "addresse_scim": addresseScim,
        "quartier_scim": quartierScim,
        "arrondis_scim": arrondisScim,
        "reperead_scim": repereadScim,
        "nombre_chambres": nombreChambres,
        "nombre_salons": nombreSalons,
        "nombre_douche": nombreDouche,
        "nombre_toilette": nombreToilette,
        "a_climatiseur": aClimatiseur,
        "a_telephone": aTelephone,
        "a_cuisine": aCuisine,
        "a_gym": aGym,
        "a_television": aTelevision,
        "a_wifi": aWifi,
        "a_piscine": aPiscine,
        "a_gardien": aGardien,
        "a_courant": aCourant,
        "a_eau": aEau,
        "a_parking": aParking,
        "a_bache_a_eau": aBacheAEau,
        "a_chauffe_eau": aChauffeEau,
        "a_groupe_electrogene": aGroupeElectrogene,
        "a_approuver": aApprouver,
        "ok_approuver": okApprouver,
        "desapprouver": desapprouver,
        "description": description,
        "document": document,
        "user": user,
    };
}

class Image {
    int id;
    String image;
    String propriete;

    Image({
        required this.id,
        required this.image,
        required this.propriete,
    });

    factory Image.fromJson(Map<String, dynamic> json) => Image(
        id: json["id"],
        image: json["image"],
        propriete: json["propriete"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "propriete": propriete,
    };
}
