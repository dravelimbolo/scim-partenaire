
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:scim_partenaire/providers/propriete/propriete.model.dart' as resoltion;
import 'package:url_launcher/url_launcher.dart';


import '../../../../providers/propriete/propriete.provider.dart';
import '../card/widgetcard/generic_text_widget.dart';
import 'detailarticle.dart';

class PropertyDetailsPage extends StatefulWidget {
  final int? propertyID;
  final String? heroId;
  final resoltion.Propriete propriete;
  final String? permaLink;

  const PropertyDetailsPage({super.key,
    this.propertyID,
    this.heroId,
    this.permaLink, required this.propriete
  });

  @override
  PropertyDetailsPageState createState() => PropertyDetailsPageState();
}

class PropertyDetailsPageState extends State<PropertyDetailsPage> {


  double opacity = 0.0;

  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_scrollListener);
  }

  @override
  dispose() {

    _scrollController.dispose();
    
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final ProprieteProvider userProprieteProvider = Provider.of<ProprieteProvider>(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.white.withOpacity(0.0),
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        body: Stack(
          children: [
            RefreshIndicator(
              onRefresh: () {
                return userProprieteProvider.fetchPropriete();
              },
              child: SingleChildScrollView(
                controller: _scrollController,
                scrollDirection: Axis.vertical,
                child:  Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children:[
                        PropertyDetailPageImages(
                          imageUrlsList: widget.propriete.images.map((image) => image.image).toList(),
                        ),
                        Container(
                          padding:  const EdgeInsets.fromLTRB(20, 20, 20, 5),
                          child: GenericTextWidget(
                            const Utf8Codec().decode(widget.propriete.titreScim.codeUnits),
                            strutStyle:  const StrutStyle(height: 1.0),
                            style: TextStyle(fontSize: 23.0, fontWeight: FontWeight.w500, color:Colors.grey[900]),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(20, 5, 20, 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Wrap(
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(right: 5,bottom: 5),
                                        child:  Container(
                                          padding: const EdgeInsets.fromLTRB(5,3,5,5),
                                          decoration: BoxDecoration(
                                            color: Colors.grey[100],
                                            border: Border.all(color: const Color(0x1F000000)),
                                            borderRadius: const BorderRadius.all(Radius.circular(4)),
                                          ),
                                          child: GenericTextWidget(
                                            const Utf8Codec().decode(widget.propriete.typeSubScim.codeUnits),
                                            strutStyle: const StrutStyle(forceStrutHeight: true),
                                            style: const TextStyle(fontSize: 11.0, fontWeight: FontWeight.w400, color: Colors.black),
                                          ),
                                        )
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(right: 5,bottom: 5),
                                        child: Container(
                                          padding: const EdgeInsets.fromLTRB(5,3,5,5),
                                          decoration: BoxDecoration(
                                            color:Colors.grey[100],
                                            border: Border.all(color: const Color(0x1F000000)),
                                            borderRadius: const BorderRadius.all(Radius.circular(4)),
                                          ),
                                          child: GenericTextWidget(
                                            widget.propriete.etatProScim == 'louer'
                                            ? 'À louer'
                                            : widget.propriete.etatProScim == 'vendre'
                                              ? 'À vendre'
                                              : const Utf8Codec().decode(widget.propriete.etatProScim.codeUnits),
                                            strutStyle: const StrutStyle(forceStrutHeight: true),
                                            style: const TextStyle(fontSize: 11.0, fontWeight: FontWeight.w400, color: Colors.black),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ]
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: GenericTextWidget(
                                  "${widget.propriete.montantScim} FCFA",
                                  strutStyle: const StrutStyle(height: 1.0),
                                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400, color: Colors.grey[900]),
                                ),
                              ),
                            ],
                          ),
                        ),

                        Container(
                          height: 50,
                          padding: const EdgeInsets.fromLTRB( 16,0, 16 , 0,),
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: 1,
                            itemBuilder: (context, index) {
                              return Row(
                                children: [
                                  widget.propriete.nombreChambres < 1 ?
                                  Container():
                                  Padding(
                                    padding: EdgeInsets.only(left: index == 0 ? 0 : 5),
                                    child: Card(
                                      elevation: 0.0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                        side: BorderSide.none,
                                      ),
                                      color: Colors.grey[100],
                                      // padding: EdgeInsets.symmetric(horizontal: 10),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          // crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(
                                              Icons.king_bed_outlined,
                                              // weekend
                                              size: 23.0,
                                            ),
                                            Container(
                                              padding: const EdgeInsets.only(top: 0, left: 5),
                                              child: GenericTextWidget(
                                                widget.propriete.nombreChambres == 1 ?
                                                "${widget.propriete.nombreChambres.toString()} Chambre" :
                                                "${widget.propriete.nombreChambres.toString()} Chambres",
                                                textAlign: TextAlign.center,
                                                strutStyle: const StrutStyle(height: 1.0),
                                                style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, color: Colors.grey[900]),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  widget.propriete.nombreSalons < 1 ?
                                  Container():
                                  Padding(
                                    padding: EdgeInsets.only(left: index == 0 ? 0 : 5),
                                    child: Card(
                                      elevation: 0.0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                        side: BorderSide.none,
                                      ),
                                      color: Colors.grey[100],
                                      // padding: EdgeInsets.symmetric(horizontal: 10),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          // crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(
                                              Icons.weekend_outlined,
                                              size: 23.0,
                                            ),
                                            Container(
                                              padding: const EdgeInsets.only(top: 0, left: 5),
                                              child: GenericTextWidget(
                                                widget.propriete.nombreSalons == 1 ?
                                                "${widget.propriete.nombreSalons.toString()} Salon" :
                                                "${widget.propriete.nombreSalons.toString()} Salons",
                                                textAlign: TextAlign.center,
                                                strutStyle: const StrutStyle(height: 1.0),
                                                style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, color: Colors.grey[900]),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  widget.propriete.nombreDouche < 1 ?
                                  Container():
                                  Padding(
                                    padding: EdgeInsets.only(left: index == 0 ? 0 : 5),
                                    child: Card(
                                      elevation: 0.0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                        side: BorderSide.none,
                                      ),
                                      color: Colors.grey[100],
                                      // padding: EdgeInsets.symmetric(horizontal: 10),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          // crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(
                                              Icons.bathtub_outlined,
                                              size: 23.0,
                                            ),
                                            Container(
                                              padding: const EdgeInsets.only(top: 0, left: 5),
                                              child: GenericTextWidget(
                                                widget.propriete.nombreDouche == 1 ?
                                                "${widget.propriete.nombreDouche.toString()} Douche" :
                                                "${widget.propriete.nombreDouche.toString()} Douches",
                                                textAlign: TextAlign.center,
                                                strutStyle: const StrutStyle(height: 1.0),
                                                style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, color: Colors.grey[900]),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  widget.propriete.nombreToilette < 1 ?
                                  Container():
                                  Padding(
                                    padding: EdgeInsets.only(left: index == 0 ? 0 : 5),
                                    child: Card(
                                      elevation: 0.0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                        side: BorderSide.none,
                                      ),
                                      color: Colors.grey[100],
                                      // padding: EdgeInsets.symmetric(horizontal: 10),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          // crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(
                                              Icons.wc_outlined,
                                              size: 23.0,
                                            ),
                                            Container(
                                              padding: const EdgeInsets.only(top: 0, left: 5),
                                              child: GenericTextWidget(
                                                widget.propriete.nombreToilette == 1 ?
                                                "${widget.propriete.nombreToilette.toString()} Toilette" :
                                                "${widget.propriete.nombreToilette.toString()} Toilettes",
                                                textAlign: TextAlign.center,
                                                strutStyle: const StrutStyle(height: 1.0),
                                                style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, color: Colors.grey[900]),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Padding(
                                  //   padding: EdgeInsets.only(left: index == 0 ? 0 : 5),
                                  //   child: Card(
                                  //     elevation: 0.0,
                                  //     shape: RoundedRectangleBorder(
                                  //       borderRadius: BorderRadius.circular(10.0),
                                  //       side: BorderSide.none,
                                  //     ),
                                  //     color: Colors.grey[100],
                                  //     // padding: EdgeInsets.symmetric(horizontal: 10),
                                  //     child: Padding(
                                  //       padding: const EdgeInsets.all(8.0),
                                  //       child: Row(
                                  //         // crossAxisAlignment: CrossAxisAlignment.center,
                                  //         mainAxisSize: MainAxisSize.min,
                                  //         children: [
                                  //           const Icon(
                                  //             Icons.square_foot,
                                  //             size: 23.0,
                                  //           ),
                                  //           Container(
                                  //             padding: const EdgeInsets.only(top: 0, left: 5),
                                  //             child: GenericTextWidget(
                                  //               "20*20 m2",
                                  //               textAlign: TextAlign.center,
                                  //               strutStyle: const StrutStyle(height: 1.0),
                                  //               style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, color: Colors.grey[900]),
                                  //             ),
                                  //           ),
                                  //         ],
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                ],
                              );
                            },
                          ),
                        ),

                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 16),
                              child: Card(
                                elevation: 0.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0.0),
                                  side: BorderSide.none,
                                  // side: BorderSide(color: AppThemePreferences().appTheme.dividerColor, width: 0.5)
                                ),
                                color: Colors.grey[100],
                                child: MediaQuery.removePadding(
                                  context: context,
                                  removeTop: true,
                                  removeBottom: true,
                                  child: Column(
                                    children: [
                                      Container(
                                        decoration:  const BoxDecoration(
                                            border: Border(
                                              top: BorderSide(color: Color(0x1F000000), width: 1.0, style: BorderStyle.solid),
                                              bottom: BorderSide(color: Color(0x1F000000), width: 1.0, style: BorderStyle.solid),
                                            ),
                                          ),
                                        padding: const EdgeInsets.symmetric(horizontal: 20),
                                        height: 40,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            GenericTextWidget(
                                              widget.propriete.dateDesapprobation != null ?
                                              "Occupée : " :
                                              "Disponible : ",
                                              textAlign: TextAlign.start,
                                              strutStyle: const StrutStyle(height: 1.0),
                                              style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w300, height: 1.8, color: Colors.grey[900]),
                                            ),
                                            Expanded(
                                              child: GenericTextWidget(
                                                // widget.propriete.dateApprobation,
                                                widget.propriete.dateDesapprobation != null ?
                                                DateFormat('yyyy-MM-dd').format(DateTime.parse(widget.propriete.dateDesapprobation as String)):
                                                DateFormat('yyyy-MM-dd').format(DateTime.parse(widget.propriete.dateApprobation as String)),
                                                textAlign: TextAlign.end,
                                                strutStyle: const StrutStyle(height: 1.0),
                                                style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, color: Colors.grey[900]),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                    child: GenericTextWidget(
                                      "Caractéristique(s)",
                                      strutStyle: const StrutStyle(height: 1.5),
                                      style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w400, color:  Colors.grey[600]),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                height: 110,
                                padding: const EdgeInsets.fromLTRB( 0,0, 0 , 0,),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: 1,
                                  itemBuilder: (context, index) {
                                    return Row(
                                      children: [
                                        widget.propriete.aClimatiseur == false ?
                                        Container():
                                        Container(
                                          // width: 70,
                                          padding: const EdgeInsets.only(left: 10),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Card(
                                                elevation: 0.0,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(100.0),
                                                  side: BorderSide.none,
                                                ),
                                                color: Colors.grey[100],
                                                child: const Padding(
                                                  padding: EdgeInsets.all(10.0),
                                                  child: Icon(
                                                    Icons.ac_unit_outlined,
                                                    size: 25.0,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(top: 5.0),
                                                child: GenericTextWidget(
                                                  "Climatisation",
                                                  strutStyle: const StrutStyle(height: 1.0),
                                                  style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, color:  Colors.grey[900]),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.clip,
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        widget.propriete.aWifi == false ?
                                        Container():
                                        Container(
                                          // width: 70,
                                          padding: const EdgeInsets.only(left: 10),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Card(
                                                elevation: 0.0,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(100.0),
                                                  side: BorderSide.none,
                                                ),
                                                color: Colors.grey[100],
                                                child: const Padding(
                                                  padding: EdgeInsets.all(10.0),
                                                  child: Icon(
                                                    Icons.wifi_outlined,
                                                    size: 25.0,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(top: 5.0),
                                                child: GenericTextWidget(
                                                  "Wifi",
                                                  strutStyle: const StrutStyle(height: 1.0),
                                                  style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, color:  Colors.grey[900]),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.clip,
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        widget.propriete.aTelevision == false ?
                                        Container():
                                        Container(
                                          // width: 70,
                                          padding: const EdgeInsets.only(left: 10),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Card(
                                                elevation: 0.0,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(100.0),
                                                  side: BorderSide.none,
                                                ),
                                                color: Colors.grey[100],
                                                child: const Padding(
                                                  padding: EdgeInsets.all(10.0),
                                                  child: Icon(
                                                    Icons.tv_outlined,
                                                    size: 25.0,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(top: 5.0),
                                                child: GenericTextWidget(
                                                  "Télévision",
                                                  strutStyle: const StrutStyle(height: 1.0),
                                                  style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, color:  Colors.grey[900]),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.clip,
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        widget.propriete.aGardien == false ?
                                        Container():
                                        Container(
                                          // width: 70,
                                          padding: const EdgeInsets.only(left: 10),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Card(
                                                elevation: 0.0,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(100.0),
                                                  side: BorderSide.none,
                                                ),
                                                color: Colors.grey[100],
                                                child: const Padding(
                                                  padding: EdgeInsets.all(10.0),
                                                  child: Icon(
                                                    Icons.security_outlined,
                                                    size: 25.0,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(top: 5.0),
                                                child: GenericTextWidget(
                                                  "Gardien",
                                                  strutStyle: const StrutStyle(height: 1.0),
                                                  style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, color:  Colors.grey[900]),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.clip,
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        widget.propriete.aParking == false ?
                                        Container():
                                        Container(
                                          // width: 70,
                                          padding: const EdgeInsets.only(left: 10),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Card(
                                                elevation: 0.0,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(100.0),
                                                  side: BorderSide.none,
                                                ),
                                                color: Colors.grey[100],
                                                child: const Padding(
                                                  padding: EdgeInsets.all(10.0),
                                                  child: Icon(
                                                    Icons.local_parking_outlined,
                                                    size: 25.0,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(top: 5.0),
                                                child: GenericTextWidget(
                                                  "Parking",
                                                  strutStyle: const StrutStyle(height: 1.0),
                                                  style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, color:  Colors.grey[900]),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.clip,
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        widget.propriete.aCuisine == false ?
                                        Container():
                                        Container(
                                          // width: 70,
                                          padding: const EdgeInsets.only(left: 10),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Card(
                                                elevation: 0.0,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(100.0),
                                                  side: BorderSide.none,
                                                ),
                                                color: Colors.grey[100],
                                                child: const Padding(
                                                  padding: EdgeInsets.all(10.0),
                                                  child: Icon(
                                                    Icons.restaurant_outlined,
                                                    size: 25.0,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(top: 5.0),
                                                child: GenericTextWidget(
                                                  "Cuisine",
                                                  strutStyle: const StrutStyle(height: 1.0),
                                                  style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, color:  Colors.grey[900]),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.clip,
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        widget.propriete.aEau == false ?
                                        Container():
                                        Container(
                                          // width: 70,
                                          padding: const EdgeInsets.only(left: 10),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Card(
                                                elevation: 0.0,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(100.0),
                                                  side: BorderSide.none,
                                                ),
                                                color: Colors.grey[100],
                                                child: const Padding(
                                                  padding: EdgeInsets.all(10.0),
                                                  child: Icon(
                                                    Icons.water_outlined,
                                                    size: 25.0,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(top: 5.0),
                                                child: GenericTextWidget(
                                                  "Eau",
                                                  strutStyle: const StrutStyle(height: 1.0),
                                                  style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, color:  Colors.grey[900]),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.clip,
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        widget.propriete.aCourant == false ?
                                        Container():
                                        Container(
                                          // width: 70,
                                          padding: const EdgeInsets.only(left: 10),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Card(
                                                elevation: 0.0,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(100.0),
                                                  side: BorderSide.none,
                                                ),
                                                color: Colors.grey[100],
                                                child: const Padding(
                                                  padding: EdgeInsets.all(10.0),
                                                  child: Icon(
                                                    Icons.flash_on_outlined,
                                                    size: 25.0,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(top: 5.0),
                                                child: GenericTextWidget(
                                                  "Courant",
                                                  strutStyle: const StrutStyle(height: 1.0),
                                                  style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, color:  Colors.grey[900]),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.clip,
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        widget.propriete.aChauffeEau == false ?
                                        Container():
                                        Container(
                                          // width: 70,
                                          padding: const EdgeInsets.only(left: 10),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Card(
                                                elevation: 0.0,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(100.0),
                                                  side: BorderSide.none,
                                                ),
                                                color: Colors.grey[100],
                                                child: const Padding(
                                                  padding: EdgeInsets.all(10.0),
                                                  child: Icon(
                                                    Icons.hot_tub_outlined,
                                                    size: 25.0,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(top: 5.0),
                                                child: GenericTextWidget(
                                                  "Chauffe-eau",
                                                  strutStyle: const StrutStyle(height: 1.0),
                                                  style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, color:  Colors.grey[900]),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.clip,
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        widget.propriete.aPiscine == false ?
                                        Container():
                                        Container(
                                          // width: 70,
                                          padding: const EdgeInsets.only(left: 10),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Card(
                                                elevation: 0.0,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(100.0),
                                                  side: BorderSide.none,
                                                ),
                                                color: Colors.grey[100],
                                                child: const Padding(
                                                  padding: EdgeInsets.all(10.0),
                                                  child: Icon(
                                                    Icons.pool_outlined,
                                                    size: 25.0,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(top: 5.0),
                                                child: GenericTextWidget(
                                                  "Piscine",
                                                  strutStyle: const StrutStyle(height: 1.0),
                                                  style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, color:  Colors.grey[900]),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.clip,
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        widget.propriete.aBacheAEau == false ?
                                        Container():
                                        Container(
                                          // width: 70,
                                          padding: const EdgeInsets.only(left: 10),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Card(
                                                elevation: 0.0,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(100.0),
                                                  side: BorderSide.none,
                                                ),
                                                color: Colors.grey[100],
                                                child: const Padding(
                                                  padding: EdgeInsets.all(10.0),
                                                  child: Icon(
                                                    Icons.opacity_outlined,
                                                    size: 25.0,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(top: 5.0),
                                                child: GenericTextWidget(
                                                  "Bâche à eau",
                                                  strutStyle: const StrutStyle(height: 1.0),
                                                  style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, color:  Colors.grey[900]),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.clip,
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        widget.propriete.aGym == false ?
                                        Container():
                                        Container(
                                          // width: 70,
                                          padding: const EdgeInsets.only(left: 10),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Card(
                                                elevation: 0.0,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(100.0),
                                                  side: BorderSide.none,
                                                ),
                                                color: Colors.grey[100],
                                                child: const Padding(
                                                  padding: EdgeInsets.all(10.0),
                                                  child: Icon(
                                                    Icons.fitness_center_outlined,
                                                    size: 25.0,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(top: 5.0),
                                                child: GenericTextWidget(
                                                  "Salle sport",
                                                  strutStyle: const StrutStyle(height: 1.0),
                                                  style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, color:  Colors.grey[900]),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.clip,
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        widget.propriete.aGroupeElectrogene == false ?
                                        Container():
                                        Container(
                                          // width: 70,
                                          padding: const EdgeInsets.only(left: 10),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Card(
                                                elevation: 0.0,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(100.0),
                                                  side: BorderSide.none,
                                                ),
                                                color: Colors.grey[100],
                                                child: const Padding(
                                                  padding: EdgeInsets.all(10.0),
                                                  child: Icon(
                                                    Icons.settings_input_component_outlined,
                                                    size: 25.0,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(top: 5.0),
                                                child: GenericTextWidget(
                                                  "Groupe électrogène",
                                                  strutStyle: const StrutStyle(height: 1.0),
                                                  style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, color:  Colors.grey[900]),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.clip,
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        widget.propriete.aTelephone == false ?
                                        Container():
                                        Container(
                                          // width: 70,
                                          padding: const EdgeInsets.only(left: 10),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Card(
                                                elevation: 0.0,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(100.0),
                                                  side: BorderSide.none,
                                                ),
                                                color: Colors.grey[100],
                                                child: const Padding(
                                                  padding: EdgeInsets.all(10.0),
                                                  child: Icon(
                                                    Icons.phone_outlined,
                                                    size: 25.0,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(top: 5.0),
                                                child: GenericTextWidget(
                                                  "Téléphone",
                                                  strutStyle: const StrutStyle(height: 1.0),
                                                  style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, color:  Colors.grey[900]),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.clip,
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
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
                                  const Utf8Codec().decode(widget.propriete.description.codeUnits),
                                  enableCopy: true,
                                  onLongPress: (){
                                    Clipboard.setData(ClipboardData(text: const Utf8Codec().decode(widget.propriete.description.codeUnits)));
                                  },
                                  maxLines: 6,
                                  overflow: TextOverflow.ellipsis,
                                  strutStyle:
                                  const StrutStyle(height:1.6),
                                  style: const TextStyle(fontSize: 14.0, height: 1.6, fontWeight: FontWeight.w300, color: Colors.black),
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                            ),
                          ],
                        ),
                        
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0, bottom: 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                    child: GenericTextWidget(
                                      "Addresse",
                                      strutStyle: const StrutStyle(height: 1.5),
                                      style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w400, color:  Colors.grey[600]),
                                    ),
                                  ),
                                ],
                              ), 
                              Padding(
                                padding: const EdgeInsets.fromLTRB(20,10,20,0),
                                child: Row(
                                  children: [
                                    GenericTextWidget(
                                      const Utf8Codec().decode(widget.propriete.addresseScim.codeUnits),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      strutStyle: const StrutStyle(height: 1.0),
                                      style:TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, color: Colors.grey[900]),
                                    ),
                                    const Spacer(),
                                    GenericTextWidget(
                                      const Utf8Codec().decode(widget.propriete.repereadScim.codeUnits),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      strutStyle: const StrutStyle(height: 1.0),
                                      style:TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, color: Colors.grey[900]),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(20,10,20,10),
                                child: Container(
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(color: Color(0x1F000000), width: 1.0, style: BorderStyle.solid),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(13,0,13,0),
                                child: Container(
                                  padding: const EdgeInsets.fromLTRB(
                                      10, 0, 10, 0),
                                  child: Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        // mainAxisSize: MainAxisSize.min,
                                        children: [
                                          GenericTextWidget(
                                            "Quartier:",
                                            maxLines: 2,
                                            strutStyle: const StrutStyle(height: 1.0),
                                            style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, color: Colors.grey[600]),
                                          ),
                                          GenericTextWidget(
                                            const Utf8Codec().decode(widget.propriete.quartierScim.codeUnits),
                                            strutStyle: const StrutStyle(height: 1.0),
                                            style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, color: Colors.grey[900]),
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                      Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.end,
                                        // mainAxisSize: MainAxisSize.min,
                                        children: [
                                          GenericTextWidget(
                                            "Arrodissement:",
                                            maxLines: 2,
                                            strutStyle: const StrutStyle(height: 1.0),
                                            style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, color: Colors.grey[600]),
                                          ),
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: GenericTextWidget(
                                              const Utf8Codec().decode(widget.propriete.arrondisScim.codeUnits),
                                              strutStyle: const StrutStyle(height: 1.0),
                                              style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, color: Colors.grey[900]),
                                              textAlign: TextAlign.right,
                                            ),
                                          ),
                                      
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(20,10,20,10),
                                child: Container(
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(color: Color(0x1F000000), width: 1.0, style: BorderStyle.solid),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20,0,20,0),
                          child: Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: Color(0x1F000000), width: 1.0, style: BorderStyle.solid),
                              ),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                                      child: GenericTextWidget(
                                        "Contact",
                                        strutStyle: const StrutStyle(height: 1.5),
                                        style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w400, color:  Colors.grey[600]),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 20.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                        radius: 35,
                                        backgroundColor: Colors.transparent,
                                        child: Container(
                                          height: 100,
                                          width: 50,
                                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                                          child: Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              // borderRadius: BorderRadius.circular(AppThemePreferences.propertyDetailFeaturesRoundedCornersRadius),
                                              borderRadius: const BorderRadius.all(Radius.circular(50)),
                                              onTap: () {
                                                
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.all(1.0),
                                                child: ClipRRect(
                                                  borderRadius: const BorderRadius.all(Radius.circular(50)),
                                                  child: Image.asset(
                                                    "assets/images/logo.png",
                                                    fit: BoxFit.fill
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: InkWell(
                                          borderRadius: BorderRadius.circular(10),
                                          onTap: () {},
                                          child: Container(
                                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                            child: const Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                GenericTextWidget(
                                                  "SCIM Immo",
                                                  maxLines: 1,
                                                  textAlign: TextAlign.left,
                                                  overflow: TextOverflow.visible,
                                                  strutStyle: StrutStyle(height: 1.0),
                                                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500, color: Colors.black),
                                                  // style: AppThemePreferences().appTheme.body01TextStyle,
                                                ),
                                                GenericTextWidget(
                                                  "Arrêt auto-école",
                                                  maxLines: 1,
                                                  textAlign: TextAlign.left,
                                                  overflow: TextOverflow.visible,
                                                  strutStyle: StrutStyle(height: 1.0),
                                                  style: TextStyle(fontSize: 11.0, fontWeight: FontWeight.w300, height: 0.8, color: Colors.black),
                                                  // style: AppThemePreferences().appTheme.body01TextStyle,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [ 
                                              Padding(
                                                padding: const EdgeInsets.only(left: 5),
                                                child: InkWell(
                                                  borderRadius: BorderRadius.circular(100.0),
                                                  onTap: () {
                                                    launchUrl(Uri.parse("tel://+242067551919"));
                                                  },
                                                  child: Card(
                                                    elevation: 0.0,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(100.0),
                                                      side: BorderSide.none,
                                                    ),
                                                    color: const Color(0xFFE3C35A),
                                                    child: const Padding(
                                                      padding: EdgeInsets.all(10.0),
                                                      child: Icon(
                                                        Icons.phone_outlined,
                                                        color: Colors.white,
                                                        size: 25.0,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(left: 5),
                                                child: InkWell(
                                                  borderRadius: BorderRadius.circular(100.0),
                                                  onTap: () async => await launchUrl(
                                                    Platform.isAndroid
                                                      ? Uri.parse("https://wa.me/+242067551919/?text=${Uri.parse("Bonjour j'ai trouvé ce bien sur l'application SCIM IMMO puis-je avoir plus d'information svp? Id: *${widget.propriete.codeScim}*")}")
                                                      : Uri.parse("https://api.whatsapp.com/send?phone=+242067551919=${Uri.parse("Bonjour j'ai trouvé ce bien sur l'application SCIM IMMO puis-je avoir plus d'information svp? Id: *${widget.propriete.codeScim}*")}")
                                                  ),
                                                  child: Card(
                                                    elevation: 0.0,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(100.0),
                                                      side: BorderSide.none,
                                                    ),
                                                    color: const Color(0xFF25D366),
                                                    child:  Padding(
                                                      padding: const EdgeInsets.all(10.0),
                                                      child: Image.asset("assets/icons/whatsapp-logo.png", height: 25.0, width: 25.0,),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),


                        Container(
                          padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                          
                        ),
                        
                      ],
                    ),
                    SizedBox(
                      height: 45,
                      child: Container(),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 0,
              child: Container(
                //height: 90,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.0),
                  border: Border(
                    bottom: BorderSide(
                      width: 1.0,
                      color: Colors.grey[300]!.withOpacity(0.0),
                    ),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.0),
                      offset: const Offset(0.0, 4.0), //(x,y)
                      blurRadius: 3.0,
                    ),
                  ],
                ),
                child: SafeArea(
                  bottom: false,
                  /// Background Container() Widget
                  child: Container(
                    height: 70,
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 20.0,
                            child: IconButton(
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Colors.black,
                                size: 20.0,
                              ),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          )
                        ),

                        /// Property Title Widget
                        Expanded(
                          flex: 6,
                          child: Opacity(
                            opacity: 0.6,
                            child: Container(
                              
                            ),
                          ),
                        ),

                        /// Favourite Property Widget
                        Expanded(
                          flex: 2,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 20.0,
                            child: IconButton(
                              icon: const Icon(
                                Icons.bookmark_border_rounded,
                                // Icons.favorite_border
                                color: Colors.black,
                                // color: Colors.red,
                                size: 20.0,
                              ),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          )
                        ),

                        /// Share Widget
                        Expanded(
                          flex: 2,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 20.0,
                            child: IconButton(
                              icon: const Icon(
                                Icons.share,
                                size: 20.0,
                              ),
                              // onPressed: () => onSharePropertyIconPressed(),
                              onPressed: (){},
                            ),
                          )
                        ),

                        /// Share Widget
                        Expanded(
                          flex: 2,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 20.0,
                            child: IconButton(
                              icon: const Icon(
                                Icons.print,
                                size: 20.0,
                              ),
                              // onPressed: () => onPrintPropertyIconPressed(),
                              onPressed: (){},
                            ),
                          )
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0.0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  border: const Border(
                    top: BorderSide(width: 1.0, color:Color(0x1F000000)),
                  ),
                ),
                child: SafeArea(
                  top: false,
                  child: SizedBox(
                    height: 70,
                    child:
                    // !widget.isInternetConnected ? NoInternetBottomActionBarWidget(onPressed: ()=> widget.noInternetOnPressed!) :
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: [
                          const SizedBox(width: 5),
                          Expanded(
                            flex: 1,
                            child: SizedBox(
                              height: 50.0,
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () =>  launchUrl(Uri.parse("tel://+242067551919")),
                                style:  ElevatedButton.styleFrom(
                                  elevation: 0.0, backgroundColor: const Color(0xFFE3C35A),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.phone_outlined,
                                      color: Colors.white,
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.only(right: 10.0),
                                        child: GenericTextWidget(
                                          "Appellez",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            flex: 1,
                            child: SizedBox(
                              height: 50.0,
                              width: double.infinity,
                              child: ElevatedButton(
                                
                                onPressed: () async => await launchUrl(
                                  Platform.isAndroid
                                    ? Uri.parse("https://wa.me/+242067551919/?text=${Uri.parse("Bonjour j'ai trouvé ce bien sur l'application SCIM IMMO puis-je avoir plus d'information svp? Id: *${widget.propriete.codeScim}*")}")
                                    : Uri.parse("https://api.whatsapp.com/send?phone=+242067551919=${Uri.parse("Bonjour j'ai trouvé ce bien sur l'application SCIM IMMO puis-je avoir plus d'information svp? Id: *${widget.propriete.codeScim}*")}")
                                ),

                                style:  ElevatedButton.styleFrom(
                                  elevation: 0.0, backgroundColor: const Color(0xFF25D366) ,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset("assets/icons/whatsapp-logo.png", height: 25.0, width: 25.0,),
                                    const Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.only(right: 10.0),
                                        child: GenericTextWidget(
                                          "Whatsapp",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12.0,
                                          ),
                                        ),
                                                                    ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ),
                        ],
                      ),
                    ),

                  ),
                ),
              ),
            )
          ],
        )
        // : Align(
        //     alignment: Alignment.topCenter,
        //     child: NoInternetConnectionErrorWidget(onPressed: ()=> checkInternetAndLoadData()),
        // ),
      ),
    );
  }

  _scrollListener() {
    if(mounted){
      setState(() {
        if (_scrollController.offset < 50.0) {
          opacity = 0.0;
        }
        if (_scrollController.offset > 50.0 && _scrollController.offset < 100.0) {
          opacity = 0.4;
        }
        if (_scrollController.offset > 100.0 && _scrollController.offset < 150.0) {
          opacity = 0.8;
        }
        if (_scrollController.offset > 190.0) {
          opacity = 1.0;
        }
      });
    }

    // print('Scroll Offset: ${_scrollController.offset}');
    // var isEnd = _scrollController.offset >= _scrollController.position.maxScrollExtent &&
    //     !_scrollController.position.outOfRange;
  }

  


  // void onPrintPropertyIconPressed() async {
  //   final url = await _propertyBloc.fetchPrintPdfPropertyResponse(
  //       { "propid": widget.propertyID.toString() }
  //   );

  //   if (await canLaunchUrl(url)) {
  //     await launchUrl(
  //       url,
  //       mode: LaunchMode.externalApplication,
  //     );
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }

  // void onSharePropertyIconPressed() {
  //   Share.share(
  //       UtilityMethods.getLocalizedString(
  //           "property_share_msg",
  //           inputWords: ["${UtilityMethods.stripHtmlIfNeeded(_article!.title!)}.",
  //             _article!.link!.isEmpty ? _articleLink : _article!.link],
  //       ),
  //   );
  // }

  // void onFavPropertyIconPressed() async {
  //   if (isInternetConnected) {
  //     if (isLoggedIn) {
  //       if (mounted) {
  //         setState(() {
  //           isLiked = !isLiked;
  //         });
  //       }
  //       Map<String, dynamic> addOrRemoveFromFavInfo = {
  //         "listing_id": widget.propertyID,
  //       };

  //       var response = await _propertyBloc.fetchAddOrRemoveFromFavResponse(addOrRemoveFromFavInfo);

  //       String tempResponseString = response.toString().split("{")[1];
  //       Map map = jsonDecode("{${tempResponseString.split("}")[0]}}");
  //       if (mounted) {
  //         setState(() {
  //           if (map['added'] == true) {
  //             isLiked = true;
  //             _showToastWhileDataLoading(context, UtilityMethods.getLocalizedString("add_to_fav"), false);
  //             GeneralNotifier().publishChange(GeneralNotifier.NEW_FAV_ADDED_REMOVED);
  //           }
  //           else if (map['added'] == false) {
  //             isLiked = false;
  //             _showToastWhileDataLoading(context, UtilityMethods.getLocalizedString("remove_from_fav"), false);
  //             GeneralNotifier().publishChange(GeneralNotifier.NEW_FAV_ADDED_REMOVED);
  //           }
  //         });
  //       }
  //     }
  //     else {
  //       _showToastWhileDataLoading(context, UtilityMethods.getLocalizedString("you_must_login") + UtilityMethods.getLocalizedString("before_adding_to_favorites"), true);
  //     }
  //   }
  // }

  

  // Widget bottomActionBarWidget() {
  //   return PropertyProfileBottomButtonActionBar(
  //     isInternetConnected: isInternetConnected,
  //     noInternetOnPressed: checkInternetAndLoadData,
  //     articleLink: _articleLink,
  //     agentDisplayOption: agentDisplayOption,
  //     article: _article,
  //     realtorInfoMap: _realtorInfoMap,
  //     profileBottomButtonActionBarListener: (bool isBottomButtonActionBarDisplayed){
  //       if(isBottomButtonActionBarDisplayed){
  //         showBottomSpace = true;
  //       }else{
  //         showBottomSpace = false;
  //       }
  //     },
  //   );
  // }

  

  

  
}



