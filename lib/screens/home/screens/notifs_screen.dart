import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:scim_partenaire/providers/notification/notification.model.dart';

import '../../../providers/propriete/propriete.provider.dart';
import '../../../providers/user.dart';
import '../widgets/card/widgetcard/generic_text_widget.dart';
import '../widgets/home_appbar.dart';
import 'notif_screen.dart';

class Screen1 extends StatefulWidget {
  static const String routeName = '/notificats-screen';

  final List<Notificat> notificats;

  const Screen1({super.key,  required this.notificats});
  
  @override
  Screen1State createState() => Screen1State();
}

class Screen1State extends State<Screen1> {

  String formatTimeDifference(DateTime dateTime) {
    final DateTime now = DateTime.now();
    final Duration difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds}s';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}min';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else {
      return '${difference.inDays}j';
    }
  }



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
          "Notifications",
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
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0,top: 10),
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: widget.notificats.length,
                      itemBuilder: (_, index) {
                        return chatItems(
                          widget.notificats[index].codeNotification,
                          const Utf8Codec().decode(widget.notificats[index].message.codeUnits).capitalizeFirstLetter(),
                          widget.notificats[index].typeNotification,
                          formatTimeDifference(widget.notificats[index].dateNotification),
                          !widget.notificats[index].vue
                        );
                      }
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget chatItems(name, message, unreadMessagetype, unreadMessageTime, online) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>  Screen3(notificat:message,typenotife:unreadMessagetype,codeNotification:name),
          ),
        );
      },
      child: Container(
        height: 80,
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Colors.black, width: 0.1), 
            bottom: BorderSide(color: Colors.black, width: 0.1),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 60,
                  width: 60,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage('assets/images/logo.png'),
                      fit: BoxFit.contain
                    ),
                  ),
                ),
                online ? 
                Positioned(
                  right: 2,
                  bottom: 4,
                  child: Container(
                    height: 14,
                    width: 14,
                    decoration: const BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 1,
                            color: Colors.white,
                            spreadRadius: 2)
                      ],
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                )
                : Container(),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 0,
                right: 0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GenericTextWidget(
                    name,
                    strutStyle: const StrutStyle(height: 1.0, forceStrutHeight: true),
                    style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600, color:  Colors.grey[900]),
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                    textAlign: TextAlign.center
                  ),
                  message.length > 60
                    ? const SizedBox(height: 4)
                    : const SizedBox(height: 10),
                  SizedBox(
                    width: 200,
                    child: GenericTextWidget(
                      message,
                      enableCopy: true,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14.0, height: 1.6, fontWeight: FontWeight.w300, color: Colors.black),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 55,
              color: Colors.white,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0, bottom: 10),
                    child: Text(
                      unreadMessageTime,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                  Container(
                    height: 10,
                    width: 10,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: const LinearGradient(
                          colors: [
                            Color.fromARGB(255, 165, 214, 167),
                            Color.fromARGB(255, 66, 159, 71),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
