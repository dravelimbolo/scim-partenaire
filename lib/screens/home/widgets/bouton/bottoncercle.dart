import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scim_partenaire/providers/propriete/propriete.provider.dart';
import 'package:scim_partenaire/screens/home/screens/bouton/bouton_screen.dart';

import '../card/widgetcard/generic_text_widget.dart';

class TermWithIconsWidget extends StatefulWidget {
  const TermWithIconsWidget({super.key});

  @override
  State<TermWithIconsWidget> createState() => _TermWithIconsWidgetState();
}

class _TermWithIconsWidgetState extends State<TermWithIconsWidget> {

  
  @override
  Widget build(BuildContext context) {

    final ProprieteProvider proprieteProvider = Provider.of<ProprieteProvider>(context);
    proprieteProvider.fetchRechPropriete("","",0,0,"","");
    
    var width = MediaQuery.of(context).size.width;
    double boxSize = (width / 4) - 0;

    final botondatas = [
      {"icon": Icons.house, "title": "À louer"},
      {"icon": Icons.sell, "title": "À vendre"}, 
      {"icon": Icons.real_estate_agent, "title": "Loué"}, 
      {"icon": Icons.verified, "title": "Vendu"},
    ];

    return Container(
      height: boxSize,
      margin: const EdgeInsets.only(bottom: 5),
      padding:  EdgeInsets.zero,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: botondatas.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              if (botondatas[index]['title'] as String == "À louer") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BoutonScreen(propriete: "À louer"),
                  ),
                );
              } else if (botondatas[index]['title'] as String == "À vendre") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BoutonScreen(propriete: "À vendre"),
                  ),
                );
              }else if (botondatas[index]['title'] as String == "Loué") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BoutonScreen(propriete: "Loué"),
                  ),
                );
              }else if (botondatas[index]['title'] as String == "Vendu") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BoutonScreen(propriete: "Vendu"),
                  ),
                );
              }
            },
            child: Container(
              width: boxSize,
              padding: EdgeInsets.zero,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Card(
                    elevation: 0.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100.0),
                    ),
                    color: Colors.grey[100],
                    child:Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Icon(
                        botondatas[index]["icon"] as IconData,
                        size: 25.0,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: GenericTextWidget(
                        botondatas[index]['title'] as String,
                        strutStyle: const StrutStyle(height: 1.0, forceStrutHeight: true),
                        style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, color:  Colors.grey[900]),
                        maxLines: 1,
                        overflow: TextOverflow.clip,
                        textAlign: TextAlign.center
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}





