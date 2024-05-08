import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:scim_partenaire/providers/client/client.provider.dart';
import 'package:scim_partenaire/screens/home/screens/rejet_screen.dart';
import 'package:shimmer/shimmer.dart';
import '../../../providers/propriete/propriete.provider.dart';
import '../../../providers/user.dart';
import '../../../utils/constant.dart';
import '../widgets/card/widgetcard/generic_text_widget.dart';
import 'profil/apropos_screen.dart';
import 'profil/confidentialite_screen.dart';
import 'profil/modification_screen.dart';


enum   SelectedOptions { logout }

class Profil extends StatefulWidget {
  const Profil({Key? key}) : super(key: key);

  @override
  State<Profil> createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {

  Future<bool?> showLogoutDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (cntxt) {
        return AlertDialog(
          icon: const Icon(Icons.logout),
          title: const Text('Êtes-vous sûr(e) ?'),
          content: const Text('Voulez-vous vous déconnecter ?'),
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
          "Profil",
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          child: Column(
            children: [
              // const SizedBox(
              //   height: 30.0,
              // ),
              // const SizedBox(
              //   height: 20.0,
              // ),
              Container(
                width: context.width(),
                height: context.height(),
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 30.0,
                      ),
                      FutureBuilder(
                        future: Provider.of<ClientProvider>(context).fetchClient(),
                        builder: (context, spanshot){
                          if (spanshot.connectionState == ConnectionState.waiting) {
                            return Column(
                              children: [
                                const SizedBox(
                                  height: 20.0,
                                ),
                                Shimmer.fromColors(
                                  baseColor: Colors.amber.shade300,
                                  highlightColor: Colors.amber.shade100,
                                  child: const CircleAvatar(
                                    radius: 40.0,
                                    backgroundColor: black,
                                  ),
                                ),
                                const SizedBox(
                                  height: 40.0,
                                ),
                              ],
                            );
                          }else if(spanshot.hasData) {
                            return Column(
                              children: [
                                ClipOval(
                                  child: CachedNetworkImage(
                                    imageUrl: spanshot.data!.first.image,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                    errorWidget: (context, url, error) => const Icon(Icons.error),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                 GenericTextWidget(
                                  '${const Utf8Codec().decode(spanshot.data!.first.user.firstName.codeUnits).capitalizeFirstLetter()} ${const Utf8Codec().decode(spanshot.data!.first.user.lastName.codeUnits).toUpperCase()}',
                                  maxLines: 1,
                                  overflow: TextOverflow.clip,
                                  strutStyle: const StrutStyle(
                                    forceStrutHeight: true,
                                    height: 1.7
                                  ),
                                  style: const TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black
                                  ),
                                ),
                                GenericTextWidget(
                                  spanshot.data!.first.user.username,
                                  maxLines: 2,
                                  strutStyle: const StrutStyle(height: 1.0),
                                  style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, color: Colors.grey[600]),
                                ),
                              ],
                            );
                          }else{
                            return Container();
                          }
                        }

                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              decoration:  BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(30.0),
                                  topRight: Radius.circular(30.0)
                                ),
                              ),
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 20.0,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10.0),
                                        color: Colors.white,
                                      ),
                                      child: ListTile(
                                        onTap: (){
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => EditProfile(image:Provider.of<ClientProvider>(context).clients.first.image),
                                            ),
                                          );
                                        },
                                        leading: const CircleAvatar(
                                          backgroundColor: Color(0xFFF5F5F5),
                                          child: Icon(
                                            Icons.edit_outlined,
                                            color: kMainColor,
                                          ),
                                        ),
                                        title: const Text(
                                          'Modification',
                                          style:
                                          TextStyle(color: Colors.black),
                                        ),
                                        trailing: const Icon(Icons.arrow_forward_ios,color: Colors.black,size: 20.0,),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10.0),
                                        color: Colors.white,
                                      ),
                                      child: ListTile(
                                        onTap: (){
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => RejetScreen(),
                                            ),
                                          );
                                        },
                                        leading: const CircleAvatar(
                                          backgroundColor: Color(0xFFF5F5F5),
                                          child: Icon(
                                            Icons.bookmark_border_rounded,
                                            color: kMainColor,
                                          ),
                                        ),
                                        title: const Text(
                                          'Inscription',
                                          style:
                                          TextStyle(color: Colors.black),
                                        ),
                                        trailing: const Icon(Icons.arrow_forward_ios,color: Colors.black,size: 20.0,),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10.0),
                                        color: Colors.white,
                                      ),
                                      child: ListTile(
                                        onTap: (){
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>  const ApropoScreen(),
                                            ),
                                          );
                                        },
                                        leading: const CircleAvatar(
                                          backgroundColor: Color(0xFFF5F5F5),
                                          child: Icon(
                                            Icons.help_outline,
                                            color: kMainColor,
                                          ),
                                        ),
                                        title: const Text(
                                          'À propos',
                                          style:
                                          TextStyle(color: Colors.black),
                                        ),
                                        trailing: const Icon(Icons.arrow_forward_ios,color: Colors.black,size: 20.0,),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10.0),
                                        color: Colors.white,
                                      ),
                                      child: ListTile(
                                        onTap: (){
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => const PoliticScreen(),
                                            ),
                                          );
                                        },
                                        leading: const CircleAvatar(
                                          backgroundColor: Color(0xFFF5F5F5),
                                          child: Icon(
                                            Icons.lock_clock_outlined,
                                            color: kMainColor,
                                          ),
                                        ),
                                        title: const Text(
                                          'Confidentialité',
                                          style:
                                          TextStyle(color: Colors.black),
                                        ),
                                        trailing: const Icon(Icons.arrow_forward_ios,color: Colors.black,size: 20.0,),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10.0),
                                        color: Colors.white,
                                      ),
                                      child: ListTile(
                                        onTap: (){
                                          showLogoutDialog(context).then(
                                            (value) {
                                              if (value == true) {
                                                proprieteProvider.clear();
                                                Provider.of<User>(context, listen: false).logout();
                                                
                                              }
                                            },
                                          );
                                        },
                                        leading: const CircleAvatar(
                                          backgroundColor: Color(0xFFF5F5F5),
                                          child: Icon(
                                            Icons.logout_outlined,
                                            color: kMainColor,
                                          ),
                                        ),
                                        title: const Text(
                                          'Se déconnecter',
                                          style:
                                          TextStyle(color: Colors.black),
                                        ),
                                        trailing: const Icon(Icons.arrow_forward_ios,color: Colors.black,size: 20.0,),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
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
