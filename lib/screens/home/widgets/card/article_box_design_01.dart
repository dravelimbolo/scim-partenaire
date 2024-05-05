import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scim_partenaire/providers/propriete/propriete.model.dart';

import '../detailarticle/property_details_page.dart';
import 'widgetcard/generic_text_widget.dart';

class ArticleBox extends StatelessWidget {
  // const ArticleBox({Key? key}) : super(key: key);
  const ArticleBox({super.key});

  @override
  Widget build(BuildContext context) {

    final Propriete propriete = Provider.of<Propriete>(context, listen: false);

    // print(propriete.titreScim);

    return Stack(
      key: UniqueKey(), // Utilisez une clé unique pour éviter les problèmes de performance
      children: <Widget>[
        Container(
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          height: 155,
          child: Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: BorderSide.none),
            elevation: 1.0,
            child: InkWell(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PropertyDetailsPage(propriete:propriete),
                  ),
                );
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ImageWidget(image: propriete.image),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PropertyTitleWidget(titre: propriete.titreScim),
                        PropertyTagsWidget(soustypeEtat: propriete),
                        PropertyAddressWidget(arrodissement: propriete.arrondisScim),
                        PropertyFeaturesWidget(propriete: propriete),
                        PropertyDetailsWidget(prix: propriete.montantScim),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ImageWidget extends StatelessWidget {
  
  const ImageWidget({Key? key,required this.image,}) : super(key: key);

  final String image;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: SizedBox(
        height: 150,
        width: 120,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: CachedNetworkImage(
            imageUrl: image,
            fit: BoxFit.cover,
            placeholder: (context, url) => const Center(
              child: CircularProgressIndicator(),
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
      ),
    );
  }
}

class PropertyTagsWidget extends StatelessWidget {
  const PropertyTagsWidget({Key? key, required this.soustypeEtat}) : super(key: key);

  final Propriete soustypeEtat;

  @override
  Widget build(BuildContext context) {

    return Container(
      padding:  EdgeInsets.zero,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children:[
          Container(
            padding: const EdgeInsets.only(right: 5,left: 5,),
            alignment: Alignment.topLeft,
            child: Container(
              padding: const EdgeInsets.fromLTRB(5, 3, 5, 5),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                border: Border.all(color:const Color(0xFFE3C35A).withOpacity(0.6)),
                borderRadius:const BorderRadius.all(Radius.circular(4)),
              ),
              child:  GenericTextWidget(
                const Utf8Codec().decode(soustypeEtat.typeSubScim.codeUnits),
                strutStyle: const StrutStyle(forceStrutHeight: true),
                style: const TextStyle(
                  fontSize: 11.0,
                  fontWeight: FontWeight.w400,
                  color: Colors.black
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 5,left: 5,),
            child: Container(
              padding: const EdgeInsets.fromLTRB(5, 3, 5, 5),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                border: Border.all(color: const Color(0x1F000000)),
                borderRadius:const BorderRadius.all(Radius.circular(4)),
              ),
              child:  GenericTextWidget(
                const Utf8Codec().decode(soustypeEtat.etatProScim.codeUnits),
                strutStyle: const StrutStyle(forceStrutHeight: true),
                style: const TextStyle(
                  fontSize: 11.0,
                  fontWeight: FontWeight.w400,
                  color: Colors.black
                ),
              ),
            ),
          )
        ]
      ),
    );
  }
}

class PropertyTitleWidget extends StatelessWidget {

  const PropertyTitleWidget({Key? key, required this.titre}):super(key: key);
  
  final String titre;

  @override
  Widget build(BuildContext context) {
    
    return Padding(
      padding: EdgeInsets.zero,
      child: GenericTextWidget(
        const Utf8Codec().decode(titre.codeUnits),
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
    );
  }
}

class PropertyAddressWidget extends StatelessWidget {

  const PropertyAddressWidget({Key? key,  required this.arrodissement,}): super(key: key);
 
  final String arrodissement;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.zero,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          const Icon(Icons.location_on_outlined,
              size: 17.0, color: Color(0xFFE3C35A)),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 5),
              child: GenericTextWidget(
                const Utf8Codec().decode(arrodissement.codeUnits),
                textDirection: TextDirection.ltr,
                maxLines: 1,
                strutStyle: const StrutStyle(forceStrutHeight: true),
                overflow: TextOverflow.clip,
                style: const TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w300,
                  color: Colors.black
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PropertyFeaturesWidget extends StatelessWidget {

  const PropertyFeaturesWidget({Key? key, required this.propriete}):super(key: key);

  final Propriete propriete;

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.zero,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          propriete.nombreChambres < 1 
          ? Container()
          : Row(
              children: <Widget>[
                const Icon(Icons.king_bed_outlined,
                    size: 17.0, color: Color(0xFFE3C35A)),
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: GenericTextWidget(
                    propriete.nombreChambres.toString(),
                    strutStyle: const StrutStyle(forceStrutHeight: true),
                    style: const TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w300,
                        color: Colors.black),
                  ),
                ),
              ],
          ),
          propriete.nombreSalons < 1 
          ? Container()
          : Row(
              children: <Widget>[
                const Icon(Icons.weekend_outlined, size: 17.0, color: Color(0xFFE3C35A)),
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: GenericTextWidget(
                    propriete.nombreSalons.toString(),
                    strutStyle: const StrutStyle(forceStrutHeight: true),
                    style: const TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w300,
                        color: Colors.black),
                  ),
                ),
              ],
          ),
          propriete.nombreDouche < 1 
          ? Container()
          : Row(
              children: <Widget>[
                const Icon(Icons.bathtub_outlined,size: 17.0, color: Color(0xFFE3C35A)),
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: GenericTextWidget(
                    propriete.nombreDouche.toString(),
                    strutStyle: const StrutStyle(forceStrutHeight: true),
                    style: const TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w300,
                        color: Colors.black),
                  ),
                ),
              ],
          ),
          propriete.nombreToilette < 1
          ? Container()
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: Row(
                children: <Widget>[
                  const Icon(
                    Icons.wc_outlined,
                    size: 17.0,
                    color: Color(0xFFE3C35A)
                  ),
                  Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: GenericTextWidget(
                    propriete.nombreToilette.toString(),
                    strutStyle: const StrutStyle(forceStrutHeight: true),
                    style: const TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w300,
                        color: Colors.black),
                  ),
                ),
                ],
              ),
          ),
          (propriete.typeSubScim != ("Bureau"))
          ? Container()
          : const Expanded(
              child: Row(
                children: <Widget>[
                  Flexible(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2.0),
                      child: Icon(Icons.square_foot,
                          size: 17.0, color: Color(0xFFE3C35A)),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: GenericTextWidget(
                      "20*20 m2",
                      strutStyle:
                          StrutStyle(forceStrutHeight: true),
                      style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w300,
                          color: Colors.black),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class PropertyDetailsWidget extends StatelessWidget {

  const PropertyDetailsWidget({Key? key, required this.prix}) : super(key: key);

  final String prix;

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.zero,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(right: 5),
              child: GenericTextWidget(
                "$prix FCFA",
                strutStyle: const StrutStyle(forceStrutHeight: true),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: const TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFE3C35A)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ErrorWidget extends StatelessWidget {
  const ErrorWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      child: Center(
          child: Icon(Icons.image_outlined,
              size: 80.0, color: Colors.grey[300])),
    );
  }
}
