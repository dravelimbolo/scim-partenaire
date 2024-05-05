import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:scim_partenaire/providers/propriete/propriete.provider.dart';
import 'package:scim_partenaire/providers/user.dart';
import '../../../providers/client/client.provider.dart';
import '../../../utils/check_time_date.dart';
import '../home_controller.dart';
// import 'package:badges/badges.dart' as badges;

enum SelectedOptions { logout }

class HomeAppbar extends StatelessWidget {
  HomeAppbar({super.key});

  final HomeController controller = HomeController();

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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        FutureBuilder(
          future: Provider.of<ClientProvider>(context).fetchClient(),
          builder: (context, spanshot){
            if (spanshot.connectionState == ConnectionState.waiting) {
              return Row(
                children: [
                  
                  Icon(
                    controller.getGreeting() == Greeting.evening
                    ? Icons.brightness_6 
                    : controller.getGreeting() == Greeting.afternoon ?
                    Icons.sunny
                    :Icons.mood
                  ),
                  const SizedBox(width: 2),
                  // Hello text
                  Text(
                    controller.getGreeting() == Greeting.evening
                      ? 'Bonne soirée...'
                      : controller.getGreeting() == Greeting.afternoon
                      ? 'Bon après-midi...'
                      : 'Bonjour...',
                    style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500, color:Colors.black)
                  ),
                ],
              );
            }else if(spanshot.hasData) {
              return Row(
                children: [
                  
                  Icon(
                    controller.getGreeting() == Greeting.evening
                    ? Icons.brightness_6 
                    : controller.getGreeting() == Greeting.afternoon ?
                    Icons.sunny
                    :Icons.mood
                  ),
                  const SizedBox(width: 2),
                  // Hello text
                  Text(
                    controller.getGreeting() == Greeting.evening
                      ? 'Bonne soirée, ${const Utf8Codec().decode(spanshot.data!.first.user.firstName.codeUnits).capitalizeFirstLetter()} !'
                      : controller.getGreeting() == Greeting.afternoon
                      ? 'Bon après-midi, ${const Utf8Codec().decode(spanshot.data!.first.user.firstName.codeUnits).capitalizeFirstLetter()} !'
                      : 'Bonjour, ${const Utf8Codec().decode(spanshot.data!.first.user.firstName.codeUnits).capitalizeFirstLetter()} !',
                    style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500, color:Colors.black)
                  ),
                ],
              );
            }else{
              return Row(
                children: [
                  
                  Icon(
                    controller.getGreeting() == Greeting.evening
                    ? Icons.brightness_6 
                    : controller.getGreeting() == Greeting.afternoon ?
                    Icons.sunny
                    :Icons.mood
                  ),
                  const SizedBox(width: 2),
                  // Hello text
                  Text(
                    controller.getGreeting() == Greeting.evening
                      ? 'Bonne soirée!'
                      : controller.getGreeting() == Greeting.afternoon
                      ? 'Bon après-midi!'
                      : 'Bonjour!',
                    style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500, color:Colors.black)
                  ),
                ],
              );
            }
          }
        ),
        // Icons
        Row(
          children: [
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
              child: const Icon(Icons.more_vert),
            ),
          ],
        )
      ],
    );
  }
}
