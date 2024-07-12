import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../../providers/propriete/propriete.provider.dart';
import '../../../../providers/user.dart';
import '../../widgets/card/widgetcard/generic_text_widget.dart';

enum   SelectedOptions { logout }

class ApropoScreen extends StatelessWidget {

  static const String routeName = '/apropos-screen';

  const ApropoScreen({super.key});

  Future<bool?> showLogoutDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (cntxt) {
        return AlertDialog(
          surfaceTintColor: Colors.white,
          icon: const Icon(Icons.logout),
          title: const Text('Êtes-vous sûr?'),
          content: const Text('Voulez-vous vous déconnecter ?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(cntxt).pop(false);
              },
              child: const Text('Non'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(cntxt).pop(true);
              },
              child: const Text(
                'Oui',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    final ProprieteProvider proprieteProvider = Provider.of<ProprieteProvider>(context);

    return Scaffold(
      appBar: AppBar( 
        backgroundColor: const Color(0xFFE3C35A),
        title:  const GenericTextWidget(
          "À propos",
          strutStyle: StrutStyle(height: 1),
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400, color:Colors.white),
        ),
        elevation:1.0,
        leading: Navigator.canPop(context)
        ? IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        : null,
        actions: [
          PopupMenuButton<SelectedOptions>(
            surfaceTintColor: Colors.white,
            tooltip: "Déconnexion",
            onSelected: (SelectedOptions selectedOptions) {
              switch (selectedOptions) {
                case SelectedOptions.logout:
                  showLogoutDialog(context).then(
                    (value) {
                      if (value == true) {
                        proprieteProvider.clear();
                        Provider.of<User>(context, listen: false).logout();
                        
                      }
                    },
                  );
              }
            },
            itemBuilder: (cntxt) {
              return [
                const PopupMenuItem<SelectedOptions>(
                  value: SelectedOptions.logout,
                  child: Text('Se déconnecter'),
                ),
              ];
            },
            child: const Icon(Icons.more_vert,color: Colors.white,),
          ),
        ],
      ),
      body:  SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: GenericTextWidget(
                      "Description",
                      strutStyle: const StrutStyle(height: 1.5),
                      style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w400, color:  Colors.grey[600]),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: GenericTextWidget(
                    "SCIM Immo, une plateforme novatrice dédiée à la recherche de biens immobiliers en République du Congo, a été conçue dans le but de simplifier et d'optimiser l'expérience des utilisateurs. Que vous soyez une agence immobilière ou un propriétaire, la plateforme offre une interface conviviale et des fonctionnalités puissantes pour faciliter la recherche, la promotion et la conclusion rapide de transactions immobilières.",
                    enableCopy: true,
                    onLongPress: (){
                      Clipboard.setData(const ClipboardData(text:"SCIM Immo, une plateforme novatrice dédiée à la recherche de biens immobiliers en République du Congo, a été conçue dans le but de simplifier et d'optimiser l'expérience des utilisateurs. Que vous soyez une agence immobilière ou un propriétaire, la plateforme offre une interface conviviale et des fonctionnalités puissantes pour faciliter la recherche, la promotion et la conclusion rapide de transactions immobilières."));
                    },
                    strutStyle:
                    const StrutStyle(height:1.6),
                    style: const TextStyle(fontSize: 14.0, height: 1.6, fontWeight: FontWeight.w300, color: Colors.black),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: GenericTextWidget(
                      "Avantages pour les clients :",
                      strutStyle: const StrutStyle(height: 1.5),
                      style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, color:  Colors.grey[600]),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: GenericTextWidget(
                    "Pour les clients, SCIM Immo offre une expérience optimale avec une interface conviviale facilitant une recherche immobilière rapide et précise. De plus, les utilisateurs bénéficient d'une diversité de choix exceptionnelle, accédant ainsi à une large gamme de biens immobiliers grâce à notre plateforme.",
                    enableCopy: true,
                    onLongPress: (){
                      Clipboard.setData(const ClipboardData(text:"Pour les clients, SCIM Immo offre une expérience optimale avec une interface conviviale facilitant une recherche immobilière rapide et précise. De plus, les utilisateurs bénéficient d'une diversité de choix exceptionnelle, accédant ainsi à une large gamme de biens immobiliers grâce à notre plateforme."));
                    },
                    strutStyle:
                    const StrutStyle(height:1.6),
                    style: const TextStyle(fontSize: 14.0, height: 1.6, fontWeight: FontWeight.w300, color: Colors.black),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: GenericTextWidget(
                      "Avantages pour les partenaires :",
                      strutStyle: const StrutStyle(height: 1.5),
                      style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, color:  Colors.grey[600]),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: GenericTextWidget(
                    "SCIM Immo offre aux partenaires (propriétaires et agences) un contrôle total, des transactions rapides et une visibilité étendue. Les propriétaires bénéficient d'une mise en avant personnalisée, les agences automatisent les tâches, gagnent du temps. En devenant partenaire, profitez d'un support dédié et d'avantages exclusifs pour maximiser le succès de vos transactions immobilières sur la plateforme SCIM Immo.",
                    enableCopy: true,
                    onLongPress: (){
                      Clipboard.setData(const ClipboardData(text:"SCIM Immo offre aux partenaires (propriétaires et agences) un contrôle total, des transactions rapides et une visibilité étendue. Les propriétaires bénéficient d'une mise en avant personnalisée, les agences automatisent les tâches, gagnent du temps. En devenant partenaire, profitez d'un support dédié et d'avantages exclusifs pour maximiser le succès de vos transactions immobilières sur la plateforme SCIM Immo."));
                    },
                    strutStyle:
                    const StrutStyle(height:1.6),
                    style: const TextStyle(fontSize: 14.0, height: 1.6, fontWeight: FontWeight.w300, color: Colors.black),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: GenericTextWidget(
                      "À propos du développeur :",
                      strutStyle: const StrutStyle(height: 1.5),
                      style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, color:  Colors.grey[600]),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: GenericTextWidget(
                    "Dravel IMBOLO e-mail: dravelameguste@gmail.com",
                    enableCopy: true,
                    onLongPress: (){
                      Clipboard.setData(const ClipboardData(text:"Dravel IMBOLO e-mail: dravelameguste@gmail.com"));
                    },
                    strutStyle:
                    const StrutStyle(height:1.6),
                    style: const TextStyle(fontSize: 14.0, height: 1.6, fontWeight: FontWeight.w300, color: Colors.black),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
