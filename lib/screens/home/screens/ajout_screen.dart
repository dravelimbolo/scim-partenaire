import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:provider/provider.dart';
import '../../../providers/propriete/propriete.provider.dart';
import '../../../providers/user.dart';
import '../../../utils/constant.dart';
import '../widgets/card/widgetcard/generic_text_widget.dart';
import 'package:drop_down_search_field/drop_down_search_field.dart';

import '../widgets/home_appbar.dart';
import 'reslut_screen.dart';

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


  bool  iscomplete = false;
  String? _nomError;
  String? _prixError1;
  String? _cutionError;
  String? _salonError;
  String? _chambreError;
  String? _addressError;
  String? _quartierError;
  String? _secteurError;

  String? _arrondissementError;

  String? _typesproorieteError;

  TextEditingController _nomController           =   TextEditingController();
  TextEditingController _salonController         =   TextEditingController();
  TextEditingController _prixController1         =   TextEditingController();
  TextEditingController _cutionController         =   TextEditingController();
  TextEditingController _chambreController       =   TextEditingController();
  TextEditingController _addressController       =   TextEditingController();
  TextEditingController _quartierController      =   TextEditingController();
  TextEditingController _secteurController       =   TextEditingController();

  @override
  void initState() {
    super.initState();

    _nomController                  =   TextEditingController();
    _salonController                =   TextEditingController();
    _prixController1                =   TextEditingController();
    _cutionController                =   TextEditingController();
    _chambreController              =   TextEditingController();
    _addressController              =   TextEditingController();
    _quartierController             =   TextEditingController();
    _secteurController              =   TextEditingController();
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
    
    super.dispose();
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

  void showCustomDialog(String message, IconData icon, Color iconColor) {
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
              onPressed: () {
                Navigator.of(context).pop(); // Ferme le dialogue
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
            "Ajoutes une  propriété",
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
                              textFieldType: TextFieldType.NAME,
                              decoration: kInputDecoration.copyWith(
                                labelText: 'Nom de la popriété',
                                hintText: 'Nom de la popriété',
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
                                          labelText: 'Type de la propriété',
                                          hintText: 'Selectionnez le type de la propriété',
                                          errorText: _typesproorieteError,
                                        ),
                                        style : TextStyle(fontWeight: FontWeight.w400, color:  Colors.grey[900]),
                                        controller: _dropdownSearchTypesproorieteController,
                                      ),
                                      noItemsFoundBuilder: (context) {
                                        return const ListTile(
                                          title: Text('Aucun type trouvé.'),
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
                                      validator: (value) => value!.isEmpty ? 'Veuillez sélectionner un type' : null,
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
                                          labelText: 'Sous type de la propriété',
                                          hintText: 'Selectionnez le sous de la propriété',
                                          errorText: _typesproorieteError,
                                        ),
                                        style : TextStyle(fontWeight: FontWeight.w400, color:  Colors.grey[900]),
                                        controller: _dropdownSearchSousTypesproorieteController,
                                      ),
                                      noItemsFoundBuilder: (context) {
                                        return const ListTile(
                                          title: Text('Aucun sous type trouvé.'),
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
                                      validator: (value) => value!.isEmpty ? 'Veuillez sélectionner un sous type' : null,
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
                                          labelText: 'Etat de la propriété',
                                          hintText: 'Selectionnez le état de la propriété',
                                          errorText: _typesproorieteError,
                                        ),
                                        style : TextStyle(fontWeight: FontWeight.w400, color:  Colors.grey[900]),
                                        controller: _dropdownSearchEtatproorieteController,
                                      ),
                                      noItemsFoundBuilder: (context) {
                                        return const ListTile(
                                          title: Text('Aucun état trouvé.'),
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
                                      validator: (value) => value!.isEmpty ? 'Veuillez sélectionner un état' : null,
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
                                          labelText: 'Arrondissement de la proprité',
                                          hintText: 'Selectionnez l\'arrondissement de la proprité',
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
                                        labelText:  'Addresse de la propriété',
                                        hintText:   'Addresse de la propriété',
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
                                      controller: _quartierController,
                                      textFieldType: TextFieldType.NAME,
                                      decoration: kInputDecoration.copyWith(
                                        labelText:  'Quartier de la propriété',
                                        hintText:   'Quartier de la propriété',
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
                                        labelText:  'Secteur de la propriété',
                                        hintText:   'Secteur de la propriété',
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
                                        labelText: 'Prix de la propriété',
                                        hintText: 'Prix de la propriété',
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
                                        labelText: 'Caution de la propriété',
                                        hintText: 'Caution de la propriété',
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
                                        labelText: 'Nombre de chambre',
                                        hintText: 'Nombre de chambre',
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
                                      controller: _prixController1,
                                      textFieldType: TextFieldType.NUMBER,
                                      decoration: kInputDecoration.copyWith(
                                        prefixIcon: const Icon(Icons.bathtub_outlined),
                                        labelText: 'Nombre de douche',
                                        hintText: 'Nombre de douche',
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
                                        suffixIcon: const Icon(Icons.wc_outlined),
                                        labelText: 'Nombre de toilettes',
                                        hintText: 'Nombre de toilettes',
                                        errorText: _cutionError,
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
                                                  value: iscomplete,
                                                  activeColor: Colors.amber,
                                                  checkColor: Colors.white,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      iscomplete = !(iscomplete as bool);
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
                                                  value: iscomplete,
                                                  activeColor: Colors.amber,
                                                  checkColor: Colors.white,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      iscomplete = !(iscomplete as bool);
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
                                                  value: iscomplete,
                                                  activeColor: Colors.amber,
                                                  checkColor: Colors.white,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      iscomplete = !(iscomplete as bool);
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
                                                  value: iscomplete,
                                                  activeColor: Colors.amber,
                                                  checkColor: Colors.white,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      iscomplete = !(iscomplete as bool);
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
                                    ],
                                  );
                                },
                              ),
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
                      // !widget.isInternetConnected ? NoInternetBottomActionBarWidget(onPressed: ()=> widget.noInternetOnPressed!) :
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
                                      
                                    final ProgressDialog pr = ProgressDialog(
                                      context,
                                      isDismissible: false,
                                    );

                                    pr.style(
                                      message: 'Opération en cours...', // Message affiché dans le dialogue
                                      progressWidget: const CircularProgressIndicator(), // Widget de progression (un cercle de progression)
                                    );

                                    await pr.show();
                                    try {
                                      await proprieteProvider.fetchRechPropriete(
                                        _selectedArrondissement,
                                        _selectedTypesprooriete,
                                        int.tryParse(_chambreController.text.trim()),
                                        int.tryParse(_salonController.text.trim()), // Utilisez _salonController.text.trim() s'il s'agit du bon contrôleur
                                        _prixController1.text.trim(),
                                        _cutionController.text.trim(),
                                      );
                                      _salonController.clear();
                                      _chambreController.clear();
                                      _prixController1.clear();
                                      _cutionController.clear();
                                      _dropdownSearchArrondissementController.clear();
                                      _dropdownSearchTypesproorieteController.clear();
                                      _selectedArrondissement = null;
                                      _selectedTypesprooriete = null;
                                      
                                      await pr.hide();
                                      // ignore: use_build_context_synchronously
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => ResultatScreen(
                                            proprietes: proprieteProvider.proprietes,
                                          ),
                                        ),
                                      );
                                    } catch (error) {

                                      await pr.hide(); // Cache le ProgressDialog en cas d'erreur
                                      showCustomDialog('Une erreur s\'est produite lors de l\'ajout du produit.', Icons.error, Colors.red);
                                    
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
                                            "Rechercher",
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
}
