// ignore_for_file: unnecessary_null_comparison

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:provider/provider.dart';
import '../../../providers/propriete/propriete.provider.dart';
import '../../../providers/user.dart';
import '../../../utils/constant.dart';
import '../../home.dart';
import '../widgets/card/widgetcard/generic_text_widget.dart';
import 'package:drop_down_search_field/drop_down_search_field.dart';

import '../widgets/home_appbar.dart';

class AjouteScreen extends StatefulWidget {

  static const String routeName = '/filtre-screen';
  
  const AjouteScreen({super.key});

  static final List<String> arrondissements = ['Makélékélé','Bacongo','Poto-Poto','Moungali','Ouenzé','Talangaï','Mfilou','Madibou','Djiri',];
  static List<String> getArrondissementsuggestions(String query) {
    List<String> matches = <String>[];
    matches.addAll(arrondissements);

    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }

  static final List<String> typesproorietes = ['Commercial','Résidentiel'];
  static List<String> getTypesproorietesuggestions(String query) {
    List<String> matches = <String>[];
    matches.addAll(typesproorietes);

    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }

  static final List<String> soustypesproorietes = ['Bureau','Magasin','Appartement','Maison','Parcelle','Villa'];
  static List<String> getSousTypesproorietesuggestions(String query) {
    List<String> matches = <String>[];
    matches.addAll(soustypesproorietes);

    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }

  static final List<String> etatproorietes = ['À louer','À vendre'];
  static List<String> getEtatproorietesuggestions(String query) {
    List<String> matches = <String>[];
    matches.addAll(etatproorietes);

    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }

  @override
  State<AjouteScreen> createState() => _AjouteScreenState();
}

class _AjouteScreenState extends State<AjouteScreen> {

  bool aClimatiseur         =   false;
  bool aTelephone           =   false;
  bool aCuisine             =   false;
  bool aGym                 =   false;
  bool aTelevision          =   false;
  bool aWifi                =   false;
  bool aPiscine             =   false;
  bool aGardien             =   false;
  bool aCourant             =   false;
  bool aEau                 =   false;
  bool aParking             =   false;
  bool aBacheAEau           =   false;
  bool aChauffeEau          =   false;
  bool aGroupeElectrogene   =   false;

  String? _nomError;
  String? _prixError1;
  String? _cutionError;
  String? _salonError;
  String? _chambreError;
  String? _addressError;
  String? _quartierError;
  String? _secteurError;
  String? _douchError;
  String? _toileteError;
  String? _descriptionError;

  String? _arrondissementError;

  String? _typesproorieteError;
  String? _soustypesproorieteError;
  String? _etatproorieteError;
  String? _imageError;


  TextEditingController _nomController           =   TextEditingController();
  TextEditingController _salonController         =   TextEditingController();
  TextEditingController _prixController1         =   TextEditingController();
  TextEditingController _cutionController         =   TextEditingController();
  TextEditingController _chambreController       =   TextEditingController();
  TextEditingController _addressController       =   TextEditingController();
  TextEditingController _quartierController      =   TextEditingController();
  TextEditingController _secteurController       =   TextEditingController();
  TextEditingController _doucheController        =   TextEditingController();
  TextEditingController _toileteController       =   TextEditingController();
  TextEditingController _descriptionController   =   TextEditingController();

  @override
  void initState() {
    super.initState();

    _nomController                  =   TextEditingController();
    _salonController                =   TextEditingController();
    _prixController1                =   TextEditingController();
    _cutionController               =   TextEditingController();
    _chambreController              =   TextEditingController();
    _addressController              =   TextEditingController();
    _quartierController             =   TextEditingController();
    _secteurController              =   TextEditingController();
    _doucheController               =   TextEditingController();
    _toileteController              =   TextEditingController();
    _descriptionController          =   TextEditingController();
  }

  @override
  void dispose() {

    _nomController.dispose();
    _salonController.dispose();
    _prixController1.dispose();
    _cutionController.dispose();
    _chambreController.dispose();
    _addressController.dispose();
    _quartierController.dispose();
    _secteurController.dispose();
    _doucheController.dispose();
    _toileteController.dispose();
    _descriptionController.dispose();
    
    super.dispose();
  }

  List<File> imageFiles = [];
  File? documentFile;

  Future<void> _pickImages() async {
    List<XFile>? pickedFiles = await ImagePicker().pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
        imageFiles = pickedFiles.map((file) => File(file.path)).toList();
      });
    }
  }

  Future<void> _pickDocument() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf', 'doc']);
    if (result != null) {
      setState(() {
        documentFile = File(result.files.single.path!);
      });
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

  void showCustomDialog(String message, IconData icon, Color iconColor,{VoidCallback? onPressed}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: iconColor,
                size: 48.0,
              ),
              const SizedBox(height: 16.0),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16.0),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: onPressed ?? () {
                Navigator.of(context).pop(); // Ferme le dialogue par défaut
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  } 

  final TextEditingController _dropdownSearchArrondissementController     = TextEditingController();
  final TextEditingController _dropdownSearchTypesproorieteController     = TextEditingController();
  final TextEditingController _dropdownSearchSousTypesproorieteController = TextEditingController();
  final TextEditingController _dropdownSearchEtatproorieteController      = TextEditingController();

  String? _selectedEtatprooriete;
  String? _selectedArrondissement;
  String? _selectedTypesprooriete;
  String? _selectedSousTypesprooriete;

  SuggestionsBoxController suggestionArrondissementBoxController = SuggestionsBoxController();
  SuggestionsBoxController suggestionTypesproorieteBoxController = SuggestionsBoxController();
  SuggestionsBoxController suggestionEtatproorieteBoxController = SuggestionsBoxController();
  SuggestionsBoxController suggestionSousTypesproorieteBoxController = SuggestionsBoxController();



  @override
  Widget build(BuildContext context) {
    final ProprieteProvider proprieteProvider = Provider.of<ProprieteProvider>(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          backgroundColor: const Color(0xFFE3C35A),
          title: const GenericTextWidget(
            "Ajoutez une  annonce",
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
          child: Stack(
            children:[
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 30.0,
                    ),
                    Container(
                      width: context.width(),
                      // height: MediaQuery.of(context).size.height,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 10.0, right: 10.0, top: 0.0,bottom: 80.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppTextField(
                              controller: _nomController,
                              maxLength: 25,
                              textFieldType: TextFieldType.NAME,
                              decoration: kInputDecoration.copyWith(
                                labelText: "Titre de l'annonce",
                                hintText: "Titre de l'annonce",
                                errorText: _nomError,
                              ),
                              textStyle : TextStyle(fontWeight: FontWeight.w400, color:  Colors.grey[900]),
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: 60.0,
                                    child: DropDownSearchFormField(
                                      textFieldConfiguration: TextFieldConfiguration(
                                        decoration: kInputDecoration.copyWith(
                                          prefixIcon: const Icon(Icons.apartment_outlined),
                                          labelText: "Usage",
                                          hintText: "Selectionnez l'usage",
                                          errorText: _typesproorieteError,
                                        ),
                                        style : TextStyle(fontWeight: FontWeight.w400, color:  Colors.grey[900]),
                                        controller: _dropdownSearchTypesproorieteController,
                                      ),
                                      noItemsFoundBuilder: (context) {
                                        return const ListTile(
                                          title: Text('Aucun usage trouvé.'),
                                          enabled: false,
                                        );
                                      },
                                      suggestionsCallback: (pattern) {
                                        return AjouteScreen.getTypesproorietesuggestions(pattern);
                                      },
                                      itemBuilder: (context, String suggestion) {
                                        return ListTile(
                                          title: Text(suggestion),
                                        );
                                      },
                                      itemSeparatorBuilder: (context, index) {
                                        return Divider(height: 1.0,color: Colors.grey[100]);
                                      },
                                      transitionBuilder: (context, suggestionsBox, controller) {
                                        return suggestionsBox;
                                      },
                                      onSuggestionSelected: (String suggestion) {
                                        _dropdownSearchTypesproorieteController.text = suggestion;
                                        setState(() {
                                          _selectedTypesprooriete = suggestion;
                                        });
                                      },
                                      suggestionsBoxController: suggestionTypesproorieteBoxController,
                                      validator: (value) => value!.isEmpty ? "Veuillez sélectionner l'usage" : null,
                                      onSaved: (value) => _selectedTypesprooriete = value,
                                      displayAllSuggestionWhenTap: true,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 4.0,
                                ),
                                Expanded(
                                  child: SizedBox(
                                    height: 60.0,
                                    child: DropDownSearchFormField(
                                      textFieldConfiguration: TextFieldConfiguration(
                                        decoration: kInputDecoration.copyWith(
                                          prefixIcon: const Icon(Icons.apartment_outlined),
                                          labelText: "Typologie",
                                          hintText: "Selectionnez la typologie",
                                          errorText: _soustypesproorieteError,
                                        ),
                                        style : TextStyle(fontWeight: FontWeight.w400, color:  Colors.grey[900]),
                                        controller: _dropdownSearchSousTypesproorieteController,
                                      ),
                                      noItemsFoundBuilder: (context) {
                                        return const ListTile(
                                          title: Text('Aucune typologie trouvée.'),
                                          enabled: false,
                                        );
                                      },
                                      suggestionsCallback: (pattern) {
                                        return AjouteScreen.getSousTypesproorietesuggestions(pattern);
                                      },
                                      itemBuilder: (context, String suggestion) {
                                        return ListTile(
                                          title: Text(suggestion),
                                        );
                                      },
                                      itemSeparatorBuilder: (context, index) {
                                        return Divider(height: 1.0,color: Colors.grey[100]);
                                      },
                                      transitionBuilder: (context, suggestionsBox, controller) {
                                        return suggestionsBox;
                                      },
                                      onSuggestionSelected: (String suggestion) {
                                        _dropdownSearchSousTypesproorieteController.text = suggestion;
                                        setState(() {
                                          _selectedSousTypesprooriete = suggestion;
                                        });
                                      },
                                      suggestionsBoxController: suggestionSousTypesproorieteBoxController,
                                      validator: (value) => value!.isEmpty ? 'Veuillez sélectionner une typologie' : null,
                                      onSaved: (value) => _selectedSousTypesprooriete = value,
                                      displayAllSuggestionWhenTap: true,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: 60.0,
                                    child: DropDownSearchFormField(
                                      textFieldConfiguration: TextFieldConfiguration(
                                        decoration: kInputDecoration.copyWith(
                                          prefixIcon: const Icon(Icons.apartment_outlined),
                                          labelText: "Catégorie",
                                          hintText: "Selectionnez la catégorie",
                                          errorText: _etatproorieteError,
                                        ),
                                        style : TextStyle(fontWeight: FontWeight.w400, color:  Colors.grey[900]),
                                        controller: _dropdownSearchEtatproorieteController,
                                      ),
                                      noItemsFoundBuilder: (context) {
                                        return const ListTile(
                                          title: Text('Aucun catégorie trouvée.'),
                                          enabled: false,
                                        );
                                      },
                                      suggestionsCallback: (pattern) {
                                        return AjouteScreen.getEtatproorietesuggestions(pattern);
                                      },
                                      itemBuilder: (context, String suggestion) {
                                        return ListTile(
                                          title: Text(suggestion),
                                        );
                                      },
                                      itemSeparatorBuilder: (context, index) {
                                        return Divider(height: 1.0,color: Colors.grey[100]);
                                      },
                                      transitionBuilder: (context, suggestionsBox, controller) {
                                        return suggestionsBox;
                                      },
                                      onSuggestionSelected: (String suggestion) {
                                        _dropdownSearchEtatproorieteController.text = suggestion;
                                        setState(() {
                                          _selectedEtatprooriete = suggestion;
                                        });
                                      },
                                      suggestionsBoxController: suggestionEtatproorieteBoxController,
                                      validator: (value) => value!.isEmpty ? 'Veuillez sélectionner une catégorie' : null,
                                      onSaved: (value) => _selectedEtatprooriete = value,
                                      displayAllSuggestionWhenTap: true,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 4.0,
                                ),
                                Expanded(
                                  child: SizedBox(
                                    height: 60.0,
                                    child: DropDownSearchFormField(
                                      textFieldConfiguration: TextFieldConfiguration(
                                        decoration: kInputDecoration.copyWith(
                                          suffixIcon: const Icon(Icons.location_on_outlined),
                                          labelText: 'Arrondissement',
                                          hintText: 'Selectionnez l\'arrondissement',
                                          errorText: _arrondissementError,
                                        ),
                                        style : TextStyle(fontWeight: FontWeight.w400, color:  Colors.grey[900]),
                                        controller: _dropdownSearchArrondissementController,
                                      ),
                                      noItemsFoundBuilder: (context) {
                                        return const ListTile(
                                          title: Text('Aucun arrondissement trouvé.'),
                                          enabled: false,
                                        );
                                      },
                                      suggestionsCallback: (pattern) {
                                        return AjouteScreen.getArrondissementsuggestions(pattern);
                                      },
                                      itemBuilder: (context, String suggestion) {
                                        return ListTile(
                                          title: Text(suggestion),
                                        );
                                      },
                                      itemSeparatorBuilder: (context, index) {
                                        return Divider(height: 1.0,color: Colors.grey[100]);
                                      },
                                      transitionBuilder: (context, suggestionsBox, controller) {
                                        return suggestionsBox;
                                      },
                                      onSuggestionSelected: (String suggestion) {
                                        _dropdownSearchArrondissementController.text = suggestion;
                                        setState(() {
                                          _selectedArrondissement = suggestion;
                                        });
                                      },
                                      suggestionsBoxController: suggestionArrondissementBoxController,
                                      validator: (value) => value!.isEmpty ? 'Veuillez sélectionner un arrondissement' : null,
                                      onSaved: (value) => _selectedArrondissement = value,
                                      displayAllSuggestionWhenTap: true,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: 60.0,
                                    child: AppTextField(
                                      controller: _addressController,
                                      textFieldType: TextFieldType.NAME,
                                      decoration: kInputDecoration.copyWith(
                                        labelText:  "Addresse",
                                        hintText:   "Addresse",
                                        errorText: _addressError,
                                      ),
                                      textStyle : TextStyle(fontWeight: FontWeight.w400, color:  Colors.grey[900]),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: 60.0,
                                    child: AppTextField(
                                      controller: _quartierController,
                                      textFieldType: TextFieldType.NAME,
                                      decoration: kInputDecoration.copyWith(
                                        labelText:  "Quartier",
                                        hintText:   "Quartier",
                                        errorText: _quartierError,
                                      ),
                                      textStyle : TextStyle(fontWeight: FontWeight.w400, color:  Colors.grey[900]),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 4.0,
                                ),
                                Expanded(
                                  child: SizedBox(
                                    height: 60.0,
                                    child: AppTextField(
                                      controller: _secteurController,
                                      textFieldType: TextFieldType.NAME,
                                      decoration: kInputDecoration.copyWith(
                                        labelText:  "Secteur",
                                        hintText:   "Secteur",
                                        errorText: _secteurError,
                                      ),
                                      textStyle : TextStyle(fontWeight: FontWeight.w400, color:  Colors.grey[900]),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: 60.0,
                                    child: AppTextField(
                                      controller: _prixController1,
                                      textFieldType: TextFieldType.NUMBER,
                                      decoration: kInputDecoration.copyWith(
                                        labelText: "Prix",
                                        hintText: "Prix",
                                        errorText: _prixError1,
                                      ),
                                      textStyle : TextStyle(fontWeight: FontWeight.w400, color:  Colors.grey[900]),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 4.0,
                                ),
                                Expanded(
                                  child: SizedBox(
                                    height: 60.0,
                                    child: AppTextField(
                                      controller: _cutionController,
                                      textFieldType: TextFieldType.NUMBER,
                                      decoration: kInputDecoration.copyWith(
                                        labelText: "Caution",
                                        hintText: "Caution",
                                        errorText: _cutionError,
                                      ),
                                      textStyle : TextStyle(fontWeight: FontWeight.w400, color:  Colors.grey[900]),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: 60.0,
                                    child: AppTextField(
                                      controller: _chambreController,
                                      textFieldType: TextFieldType.NUMBER,
                                      decoration: kInputDecoration.copyWith(
                                        prefixIcon: const Icon(Icons.king_bed_outlined),
                                        suffixIcon: const Icon(Icons.king_bed_outlined),
                                        labelText: "Nombre de chambre",
                                        hintText: "Nombre de chambre",
                                        errorText: _chambreError,
                                      ),
                                      textStyle : TextStyle(fontWeight: FontWeight.w400, color:  Colors.grey[900]),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: 60.0,
                                    child: AppTextField(
                                      controller: _salonController,
                                      textFieldType: TextFieldType.NUMBER,
                                      decoration: kInputDecoration.copyWith(
                                        prefixIcon: const Icon(Icons.weekend_outlined),
                                        suffixIcon: const Icon(Icons.weekend_outlined),
                                        labelText: 'Nombre de salon',
                                        hintText: 'Nombre de salon',
                                        errorText: _salonError,
                                      ),
                                      textStyle : TextStyle(fontWeight: FontWeight.w400, color:  Colors.grey[900]),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: 60.0,
                                    child: AppTextField(
                                      controller: _doucheController,
                                      textFieldType: TextFieldType.NUMBER,
                                      decoration: kInputDecoration.copyWith(
                                        prefixIcon: const Icon(Icons.bathtub_outlined),
                                        labelText: 'Nombre de douche',
                                        hintText: 'Nombre de douche',
                                        errorText: _douchError,
                                      ),
                                      textStyle : TextStyle(fontWeight: FontWeight.w400, color:  Colors.grey[900]),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 4.0,
                                ),
                                Expanded(
                                  child: SizedBox(
                                    height: 60.0,
                                    child: AppTextField(
                                      controller: _toileteController,
                                      textFieldType: TextFieldType.NUMBER,
                                      decoration: kInputDecoration.copyWith(
                                        suffixIcon: const Icon(Icons.wc_outlined),
                                        labelText: 'Nombre de toilettes',
                                        hintText: 'Nombre de toilettes',
                                        errorText: _toileteError,
                                      ),
                                      textStyle : TextStyle(fontWeight: FontWeight.w400, color:  Colors.grey[900]),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Container(
                              height: 50,
                              padding: const EdgeInsets.fromLTRB( 0,0, 0 , 0,),
                              child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: 1,
                                itemBuilder: (context, index) {
                                  return Row(
                                    children: [
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
                                                Checkbox(
                                                  value: aCourant,
                                                  activeColor: Colors.amber,
                                                  checkColor: Colors.white,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      aCourant = !(aCourant);
                                                      // selectedTask.togolCompleteTask();
                                                    });
                                                  },
                                                ),
                                                Container(
                                                  padding: const EdgeInsets.only(top: 0, left: 0),
                                                  child: GenericTextWidget(
                                                    "Courant",
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
                                                Checkbox(
                                                  value: aEau,
                                                  activeColor: Colors.amber,
                                                  checkColor: Colors.white,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      aEau = !(aEau);
                                                      // selectedTask.togolCompleteTask();
                                                    });
                                                  },
                                                ),
                                                Container(
                                                  padding: const EdgeInsets.only(top: 0, left: 0),
                                                  child: GenericTextWidget(
                                                    "Eau",
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
                                                Checkbox(
                                                  value: aParking,
                                                  activeColor: Colors.amber,
                                                  checkColor: Colors.white,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      aParking = !(aParking);
                                                      // selectedTask.togolCompleteTask();
                                                    });
                                                  },
                                                ),
                                                Container(
                                                  padding: const EdgeInsets.only(top: 0, left: 0),
                                                  child: GenericTextWidget(
                                                    "Parking",
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
                                                Checkbox(
                                                  value: aCuisine,
                                                  activeColor: Colors.amber,
                                                  checkColor: Colors.white,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      aCuisine = !(aCuisine);
                                                      // selectedTask.togolCompleteTask();
                                                    });
                                                  },
                                                ),
                                                Container(
                                                  padding: const EdgeInsets.only(top: 0, left: 0),
                                                  child: GenericTextWidget(
                                                    "Cuisine",
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
                                                Checkbox(
                                                  value: aClimatiseur,
                                                  activeColor: Colors.amber,
                                                  checkColor: Colors.white,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      aClimatiseur = !(aClimatiseur);
                                                      // selectedTask.togolCompleteTask();
                                                    });
                                                  },
                                                ),
                                                Container(
                                                  padding: const EdgeInsets.only(top: 0, left: 0),
                                                  child: GenericTextWidget(
                                                    "Climatiseur",
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
                                                Checkbox(
                                                  value: aChauffeEau,
                                                  activeColor: Colors.amber,
                                                  checkColor: Colors.white,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      aChauffeEau = !(aChauffeEau);
                                                      // selectedTask.togolCompleteTask();
                                                    });
                                                  },
                                                ),
                                                Container(
                                                  padding: const EdgeInsets.only(top: 0, left: 0),
                                                  child: GenericTextWidget(
                                                    "Chauffe-eau",
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
                                                Checkbox(
                                                  value: aBacheAEau,
                                                  activeColor: Colors.amber,
                                                  checkColor: Colors.white,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      aBacheAEau = !(aBacheAEau);
                                                      // selectedTask.togolCompleteTask();
                                                    });
                                                  },
                                                ),
                                                Container(
                                                  padding: const EdgeInsets.only(top: 0, left: 0),
                                                  child: GenericTextWidget(
                                                    "Bâche à eau",
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
                                                Checkbox(
                                                  value: aWifi,
                                                  activeColor: Colors.amber,
                                                  checkColor: Colors.white,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      aWifi = !(aWifi);
                                                      // selectedTask.togolCompleteTask();
                                                    });
                                                  },
                                                ),
                                                Container(
                                                  padding: const EdgeInsets.only(top: 0, left: 0),
                                                  child: GenericTextWidget(
                                                    "Wifi",
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
                                                Checkbox(
                                                  value: aPiscine,
                                                  activeColor: Colors.amber,
                                                  checkColor: Colors.white,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      aPiscine = !(aPiscine);
                                                      // selectedTask.togolCompleteTask();
                                                    });
                                                  },
                                                ),
                                                Container(
                                                  padding: const EdgeInsets.only(top: 0, left: 0),
                                                  child: GenericTextWidget(
                                                    "Piscine",
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
                                                Checkbox(
                                                  value: aGardien,
                                                  activeColor: Colors.amber,
                                                  checkColor: Colors.white,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      aGardien = !(aGardien);
                                                      // selectedTask.togolCompleteTask();
                                                    });
                                                  },
                                                ),
                                                Container(
                                                  padding: const EdgeInsets.only(top: 0, left: 0),
                                                  child: GenericTextWidget(
                                                    "Gardien",
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
                                                Checkbox(
                                                  value: aTelevision,
                                                  activeColor: Colors.amber,
                                                  checkColor: Colors.white,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      aTelevision = !(aTelevision);
                                                      // selectedTask.togolCompleteTask();
                                                    });
                                                  },
                                                ),
                                                Container(
                                                  padding: const EdgeInsets.only(top: 0, left: 0),
                                                  child: GenericTextWidget(
                                                    "Télévision",
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
                                                Checkbox(
                                                  value: aTelephone,
                                                  activeColor: Colors.amber,
                                                  checkColor: Colors.white,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      aTelephone = !(aTelephone);
                                                      // selectedTask.togolCompleteTask();
                                                    });
                                                  },
                                                ),
                                                Container(
                                                  padding: const EdgeInsets.only(top: 0, left: 0),
                                                  child: GenericTextWidget(
                                                    "Téléphone",
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
                                                Checkbox(
                                                  value: aGym,
                                                  activeColor: Colors.amber,
                                                  checkColor: Colors.white,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      aGym = !(aGym);
                                                      // selectedTask.togolCompleteTask();
                                                    });
                                                  },
                                                ),
                                                Container(
                                                  padding: const EdgeInsets.only(top: 0, left: 0),
                                                  child: GenericTextWidget(
                                                    "Gym",
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
                                                Checkbox(
                                                  value: aGroupeElectrogene,
                                                  activeColor: Colors.amber,
                                                  checkColor: Colors.white,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      aGroupeElectrogene = !(aGroupeElectrogene);
                                                      // selectedTask.togolCompleteTask();
                                                    });
                                                  },
                                                ),
                                                Container(
                                                  padding: const EdgeInsets.only(top: 0, left: 0),
                                                  child: GenericTextWidget(
                                                    "Groupe électrogène",
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

                                    ],
                                  );
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: 100.0,
                                    child: IconButton(
                                      onPressed:_pickImages,
                                      icon: const Icon(Icons.camera_alt_rounded),
                                      tooltip: 'Sélectionner les images',
                                      iconSize: 50.0,
                                      style: ButtonStyle(
                                        shape: MaterialStateProperty.all<OutlinedBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10.0),
                                          ),
                                        ),
                                        side: MaterialStateProperty.all(BorderSide(color: kBorderColorTextField, width: 1)),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            _buildError(),
                            const SizedBox(height: 10),
                            _buildImagePreviews(),
                            const SizedBox(
                              height: 20.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: 100.0,
                                    child: IconButton(
                                      onPressed:_pickDocument,
                                      icon: const Icon(Icons.description_rounded),
                                      // tooltip: 'Sélectionner le document',
                                      iconSize: 50.0,
                                      style: ButtonStyle(
                                        shape: MaterialStateProperty.all<OutlinedBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10.0),
                                          ),
                                        ),
                                        side: MaterialStateProperty.all(BorderSide(color: kBorderColorTextField, width: 1)),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            _buildDocumentPreview(),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: 150.0,
                                    child: AppTextField(
                                      controller: _descriptionController,
                                      textFieldType: TextFieldType.MULTILINE,
                                      decoration: kInputDecoration.copyWith(
                                        labelText: "Description de l'annonce",
                                        hintText: "Description de l'annonce",
                                        errorText: _descriptionError,
                                      ),
                                      textStyle : TextStyle(fontWeight: FontWeight.w400, color:  Colors.grey[900]),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
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
                      Container(
                        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          children: [
                            const SizedBox(width: 0),
                            Expanded(
                              flex: 1,
                              child: SizedBox(
                                height: 50.0,
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: ()  async {
                                    setState(() {
                                      _nomError = null;
                                      _typesproorieteError = null;
                                      _soustypesproorieteError = null;
                                      _etatproorieteError = null;
                                      _arrondissementError = null;
                                      _addressError = null;
                                      _quartierError = null;
                                      _secteurError = null;
                                      _prixError1 = null;
                                      _cutionError = null;
                                      _chambreError = null;
                                      _salonError = null;
                                      _douchError = null;
                                      _toileteError = null;
                                      _imageError = null;
                                      _descriptionError = null;
                                    });
                                    
                                    if (_nomController.text.isEmpty) {
                                      setState(() {
                                        _nomError = "Indiquez le titre de l'annonce.";
                                      });
                                    }

                                    if (_selectedTypesprooriete == null) {
                                      setState(() {
                                        _typesproorieteError = "Indiquez l'usage.";
                                      });
                                    }

                                    if (_selectedSousTypesprooriete == null) {
                                      setState(() {
                                        _soustypesproorieteError = "Indiquez la typologie.";
                                      });
                                    }

                                    if (_selectedEtatprooriete == null) {
                                      setState(() {
                                        _etatproorieteError = "Indiquez la catégorie.";
                                      });
                                    }

                                    if (_selectedArrondissement == null) {
                                      setState(() {
                                        _arrondissementError = "Indiquez l'arrondissement.";
                                      });
                                    }

                                    if (_addressController.text.isEmpty) {
                                      setState(() {
                                        _addressError = "Indiquez l'addresse.";
                                      });
                                    }

                                    if (_quartierController.text.isEmpty) {
                                      setState(() {
                                        _quartierError = "Indiquez le quartier.";
                                      });
                                    }

                                    if (_secteurController.text.isEmpty) {
                                      setState(() {
                                        _secteurError = "Indiquez le secteur.";
                                      });
                                    }

                                    if (_prixController1.text.isEmpty) {
                                      setState(() {
                                        _prixError1 = "Indiquez le prix.";
                                      });
                                    }

                                    if (_prixController1.text.isNotEmpty && int.parse(_prixController1.text.trim()) < 1000 ) {
                                      setState(() {
                                        _prixError1 = "Indiquez un prix positif.";
                                      });
                                    }

                                    if (_cutionController.text.isEmpty) {
                                      setState(() {
                                        _cutionError = "Indiquez la caution.";
                                      });
                                    }

                                    if (_cutionController.text.isNotEmpty && int.parse(_cutionController.text.trim()) < 1 ) {
                                      setState(() {
                                        _cutionError = "Indiquez une caution positif.";
                                      });
                                    }

                                    if (_chambreController.text.isEmpty) {
                                      setState(() {
                                        _chambreError = "Indiquez le nombre de chambre.";
                                      });
                                    }

                                    if (_chambreController.text.isNotEmpty && int.parse(_chambreController.text.trim()) < 0 ) {
                                      setState(() {
                                        _chambreError = "Le nombre doit être => 0.";
                                      });
                                    }

                                    if (_salonController.text.isEmpty) {
                                      setState(() {
                                        _salonError = "Indiquez le nombre de salon.";
                                      });
                                    }

                                    if (_salonController.text.isNotEmpty && int.parse(_salonController.text.trim()) < 0 ) {
                                      setState(() {
                                        _salonError = "Le nombre doit être => 0.";
                                      });
                                    }

                                    if (_doucheController.text.isEmpty) {
                                      setState(() {
                                        _douchError = "Indiquez le nombre de douche.";
                                      });
                                    }

                                    if (_doucheController.text.isNotEmpty && int.parse(_doucheController.text.trim()) < 0 ) {
                                      setState(() {
                                        _douchError = "Le nombre doit être => 0.";
                                      });
                                    }

                                    if (_toileteController.text.isEmpty) {
                                      setState(() {
                                        _toileteError = "Indiquez le nombre de toilette.";
                                      });
                                    }

                                    if (_toileteController.text.isNotEmpty && int.parse(_toileteController.text.trim()) < 0 ) {
                                      setState(() {
                                        _toileteError = "Le nombre doit être => 0.";
                                      });
                                    }

                                    if (imageFiles.isEmpty) {
                                      setState(() {
                                        _imageError = "Veuillez indiquer des images.";
                                      });
                                    }

                                    if (_descriptionController.text.isEmpty) {
                                      setState(() {
                                        _descriptionError = "Veuillez indiquer la description.";
                                      });
                                    }

                                    if (
                                    _nomController.text.isNotEmpty &&
                                    _selectedTypesprooriete != null &&
                                    _selectedSousTypesprooriete != null &&
                                    _selectedEtatprooriete != null &&
                                    _selectedArrondissement != null &&
                                    _addressController.text.isNotEmpty &&
                                    _quartierController.text.isNotEmpty &&
                                    _secteurController.text.isNotEmpty &&
                                    _prixController1.text.isNotEmpty && int.parse(_prixController1.text.trim()) >= 1000 &&
                                    _cutionController.text.isNotEmpty && int.parse(_cutionController.text.trim()) >= 1 &&
                                    _chambreController.text.isNotEmpty && int.parse(_chambreController.text.trim()) >= 0 &&
                                    _salonController.text.isNotEmpty && int.parse(_salonController.text.trim()) >= 0 &&
                                    _doucheController.text.isNotEmpty && int.parse(_doucheController.text.trim()) >= 0 &&
                                    _toileteController.text.isNotEmpty && int.parse(_toileteController.text.trim()) >= 0 &&
                                    imageFiles.isNotEmpty && _descriptionController.text.isNotEmpty) {
                                      final ProgressDialog pr = ProgressDialog(
                                        context,
                                        isDismissible: false,
                                      );

                                      pr.style(
                                        message: 'Opération en cours...',
                                        progressWidget: const CircularProgressIndicator(),
                                      );

                                      await pr.show();
                                      String etatProScim = _selectedEtatprooriete == 'À louer' ? 'louer' : 'vendre';
                                      String typesprooriete = _selectedTypesprooriete == 'Commercial' ? 'commercial' : 'residentiel';

                                      try {
                                        await proprieteProvider.addPropriete(
                                          _nomController.text.trim(),
                                          _cutionController.text.trim(),
                                          _prixController1.text.trim(),
                                          etatProScim,
                                          typesprooriete,
                                          _selectedSousTypesprooriete!,
                                          _addressController.text.trim(),
                                          _quartierController.text.trim(),
                                          _selectedArrondissement!,
                                          _secteurController.text.trim(),
                                          _chambreController.text.trim(),
                                          _salonController.text.trim(),
                                          _doucheController.text.trim(),
                                          _toileteController.text.trim(),
                                          aClimatiseur,
                                          aTelephone,
                                          aCuisine,
                                          aGym,
                                          aTelevision,
                                          aWifi,
                                          aPiscine,
                                          aGardien,
                                          aCourant,
                                          aEau,
                                          aParking,
                                          aBacheAEau,
                                          aChauffeEau,
                                          aGroupeElectrogene,
                                          _descriptionController.text.trim(),
                                          imageFiles,
                                          documentFile
                                        );


                                        _nomController.clear();
                                        _salonController.clear();
                                        _prixController1.clear();
                                        _cutionController.clear();
                                        _chambreController.clear();
                                        _addressController.clear();
                                        _quartierController.clear();
                                        _secteurController.clear();
                                        _doucheController.clear();
                                        _toileteController.clear();
                                        _descriptionController.clear();


                                        _dropdownSearchArrondissementController.clear();
                                        _dropdownSearchTypesproorieteController.clear();
                                        _dropdownSearchSousTypesproorieteController.clear();
                                        _dropdownSearchEtatproorieteController.clear();


                                        _selectedArrondissement       =   null;
                                        _selectedTypesprooriete       =   null;
                                        _selectedSousTypesprooriete   =   null;
                                        _selectedEtatprooriete        =   null;


                                        aClimatiseur         =   false;
                                        aTelephone           =   false;
                                        aCuisine             =   false;
                                        aGym                 =   false;
                                        aTelevision          =   false;
                                        aWifi                =   false;
                                        aPiscine             =   false;
                                        aGardien             =   false;
                                        aCourant             =   false;
                                        aEau                 =   false;
                                        aParking             =   false;
                                        aBacheAEau           =   false;
                                        aChauffeEau          =   false;
                                        aGroupeElectrogene   =   false;

                                        imageFiles.clear();
                                        documentFile = null;
                                        
                                        await pr.hide();
                                        
                                        // ignore: use_build_context_synchronously
                                        showCustomDialog(
                                          'Votre annonce a été ajoutée avec succès !', 
                                          Icons.check, 
                                          Colors.green,
                                          onPressed: () {
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => const Home(),
                                              ),
                                            );
                                          },
                                        );

                                      } catch (error) {

                                        await pr.hide(); // Cache le ProgressDialog en cas d'erreur
                                        showCustomDialog("Une erreur s'est produite lors de lajout de l'annonce.", Icons.error, Colors.red);
                                      
                                      }
                                    }
                                  },
                                  style:  ElevatedButton.styleFrom(
                                    elevation: 0.0, backgroundColor: const Color(0xFFE3C35A),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.zero,
                                          child: GenericTextWidget(
                                            "Ajouter",
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
                            const SizedBox(width: 0),
                          ],
                        ),
                      ),

                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _removeImage(int index) {
    setState(() {
      imageFiles.removeAt(index);
    });
  }

  Widget _buildError() {
    if (_imageError != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          _imageError!,
          style: const TextStyle(color: Colors.red),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildImagePreviews() {
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemCount: imageFiles.length,
      itemBuilder: (context, index) {
        return Stack(
          children: [
            Image.file(
              imageFiles[index],
              height: 100,
              width: 100,
              fit: BoxFit.cover,
            ),
            Positioned(
              top: 0,
              right: 0,
              child: GestureDetector(
                onTap: () => _removeImage(index),
                child: const CircleAvatar(
                  radius: 12,
                  backgroundColor: Colors.red,
                  child: Icon(
                    Icons.close,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDocumentPreview() {
    return documentFile != null
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Document Preview:'),
              const SizedBox(height: 10),
              Text('File Name: ${documentFile!.path.split('/').last}'),
            ],
          )
        : Container();
  }
}
