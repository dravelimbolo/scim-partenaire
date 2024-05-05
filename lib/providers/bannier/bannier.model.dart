import 'package:flutter/foundation.dart';

class Bannier with ChangeNotifier {
    String titre;
    String image;

    Bannier({
        required this.titre,
        required this.image,
    });

    factory Bannier.fromJson(Map<String, dynamic> json) => Bannier(
        titre: json["titre"],
        image: json["image"],
    );

    Map<String, dynamic> toJson() => {
        "titre": titre,
        "image": image,
    };
}
