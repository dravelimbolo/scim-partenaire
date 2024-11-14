
import 'package:flutter/foundation.dart';

class Notificat with ChangeNotifier {
    int id;
    String codeNotification;
    String typeNotification;
    String message;
    DateTime dateNotification;
    bool vue;
    String propriete;

    Notificat({
        required this.id,
        required this.codeNotification,
        required this.typeNotification,
        required this.message,
        required this.dateNotification,
        required this.vue,
        required this.propriete,
    });

    factory Notificat.fromJson(Map<String, dynamic> json) => Notificat(
        id: json["id"],
        codeNotification: json["code_notification"],
        typeNotification: json["type_notification"],
        message: json["message"],
        dateNotification: DateTime.parse(json["date_notification"]),
        vue: json["vue"],
        propriete: json["propriete"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "code_notification": codeNotification,
        "type_notification": typeNotification,
        "message": message,
        "date_notification": dateNotification.toIso8601String(),
        "vue": vue,
        "propriete": propriete,
    };
}
