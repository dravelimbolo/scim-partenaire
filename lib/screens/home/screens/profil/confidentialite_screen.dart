import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../../providers/propriete/propriete.provider.dart';
import '../../../../providers/user.dart';
import '../../widgets/card/widgetcard/generic_text_widget.dart';

enum   SelectedOptions { logout }

class PoliticScreen extends StatelessWidget {

  static const String routeName = '/confidentila-screen';

  const PoliticScreen({super.key});

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
          "Politique de Confidentialité",
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
              Container(
                padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: GenericTextWidget(
                    "Nous nous engageons à protéger la confidentialité des utilisateurs de SCIM Immo. Cette politique de confidentialité explique comment nous collectons, utilisons et protégeons les informations que vous nous fournissez.",
                    enableCopy: true,
                    onLongPress: (){
                      Clipboard.setData(const ClipboardData(text:"Nous nous engageons à protéger la confidentialité des utilisateurs de SCIM Immo. Cette politique de confidentialité explique comment nous collectons, utilisons et protégeons les informations que vous nous fournissez."));
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
                      "Collecte d'Informations :",
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
                    "Nous collectons des informations personnelles, telles que votre nom, adresse, adresse e-mail, etc., pour faciliter la recherche de biens immobiliers et améliorer nos services. Ces informations sont collectées de manière légale et transparente.",
                    enableCopy: true,
                    onLongPress: (){
                      Clipboard.setData(const ClipboardData(text:"Nous collectons des informations personnelles, telles que votre nom, adresse, adresse e-mail, etc., pour faciliter la recherche de biens immobiliers et améliorer nos services. Ces informations sont collectées de manière légale et transparente."));
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
                      "Utilisation des Informations :",
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
                    "Nous utilisons vos informations pour personnaliser votre expérience sur la plateforme, faciliter la recherche des annonces, et vous informer sur des mises à jour importantes. Nous ne partageons pas vos informations avec des tiers sans votre consentement, sauf si la loi l'exige.",
                    enableCopy: true,
                    onLongPress: (){
                      Clipboard.setData(const ClipboardData(text:"Nous utilisons vos informations pour personnaliser votre expérience sur la plateforme, faciliter la recherche des annonces, et vous informer sur des mises à jour importantes. Nous ne partageons pas vos informations avec des tiers sans votre consentement, sauf si la loi l'exige."));
                    },
                    strutStyle:
                    const StrutStyle(height:1.6),
                    style: const TextStyle(fontSize: 14.0, height: 1.6, fontWeight: FontWeight.w300, color: Colors.black),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: GenericTextWidget(
                      "Protection des Informations :",
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
                    "Des mesures de sécurité sont en place pour protéger vos informations personnelles contre tout accès non autorisé, altération, divulgation ou destruction.",
                    enableCopy: true,
                    onLongPress: (){
                      Clipboard.setData(const ClipboardData(text:"Des mesures de sécurité sont en place pour protéger vos informations personnelles contre tout accès non autorisé, altération, divulgation ou destruction."));
                    },
                    strutStyle:
                    const StrutStyle(height:1.6),
                    style: const TextStyle(fontSize: 14.0, height: 1.6, fontWeight: FontWeight.w300, color: Colors.black),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: GenericTextWidget(
                      "Accès et Contrôle :",
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
                    "Vous avez le droit d'accéder à vos informations personnelles et de les corriger. Contactez-nous pour exercer ces droits ou pour toute question sur la confidentialité de vos données.",
                    enableCopy: true,
                    onLongPress: (){
                      Clipboard.setData(const ClipboardData(text:"Vous avez le droit d'accéder à vos informations personnelles et de les corriger. Contactez-nous pour exercer ces droits ou pour toute question sur la confidentialité de vos données."));
                    },
                    strutStyle:
                    const StrutStyle(height:1.6),
                    style: const TextStyle(fontSize: 14.0, height: 1.6, fontWeight: FontWeight.w300, color: Colors.black),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: GenericTextWidget(
                      "Modifications de la Politique :",
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
                    "Nous nous réservons le droit de mettre à jour cette politique de confidentialité. Veuillez consulter régulièrement la dernière version sur notre plateforme.",
                    enableCopy: true,
                    onLongPress: (){
                      Clipboard.setData(const ClipboardData(text:"Nous nous réservons le droit de mettre à jour cette politique de confidentialité. Veuillez consulter régulièrement la dernière version sur notre plateforme."));
                    },
                    strutStyle:
                    const StrutStyle(height:1.6),
                    style: const TextStyle(fontSize: 14.0, height: 1.6, fontWeight: FontWeight.w300, color: Colors.black),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: GenericTextWidget(
                    "En utilisant SCIM Immo, vous acceptez les termes de cette politique de confidentialité. Pour des questions ou des préoccupations, veuillez nous contacter",
                    enableCopy: true,
                    onLongPress: (){
                      Clipboard.setData(const ClipboardData(text:"En utilisant SCIM Immo, vous acceptez les termes de cette politique de confidentialité. Pour des questions ou des préoccupations, veuillez nous contacter"));
                    },
                    strutStyle:
                    const StrutStyle(height:1.6),
                    style: const TextStyle(fontSize: 14.0, height: 1.6, fontWeight: FontWeight.w300, color: Colors.black),
                    textAlign: TextAlign.justify,
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
