import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:provider/provider.dart';
import 'package:scim_partenaire/providers/client/client.provider.dart';

import '../../../../providers/propriete/propriete.provider.dart';
import '../../../../providers/user.dart';
import '../../../../utils/constant.dart';
import '../../../home.dart';
import '../../widgets/card/widgetcard/generic_text_widget.dart';

enum   SelectedOptions { logout }

class EditProfile extends StatefulWidget {

  static const String routeName = '/editpofil-screen';
  
  final String image;

  const EditProfile({super.key, required  this.image});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {


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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Home(),
                  ),
                );
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  String? _passnouveaError;

  // Image? _selectedImage;
  ImageProvider<Object>? _selectedImage;
  File? _selectedPhoto;
  TextEditingController _passnouveaController         =   TextEditingController();
  TextEditingController _passconfimController         =   TextEditingController();

  @override
  void initState() {
    super.initState();
    _passnouveaController                             =   TextEditingController();
    _passconfimController                             =   TextEditingController();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedPhoto = File(pickedFile.path);
        _selectedImage = FileImage(_selectedPhoto!);
      });
    }
  }

  @override
  void dispose() {
    _passnouveaController.dispose();
    _passconfimController.dispose();
    
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final ProprieteProvider proprieteProvider = Provider.of<ProprieteProvider>(context);
    return Scaffold(
      appBar: AppBar( 
        backgroundColor: const Color(0xFFE3C35A),
        title:  const GenericTextWidget(
          "Modification ",
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
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: context.width(),
                  height: context.height(),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 40.0,
                      ),
                      GestureDetector(
                        onTap: _pickImage,
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 60.0,
                              backgroundImage: _selectedImage ?? NetworkImage(widget.image),
                              backgroundColor: Colors.white,
                            ),
                            Positioned(
                              bottom: -10.0,
                              right: -10.0,
                              child: Image.asset('assets/images/editpicicon.png'),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 10.0,
                          right: 10.0,
                          bottom: 10.0,
                          top: 30.0,
                        ),
                        child: AppTextField(
                          controller: _passnouveaController,
                          textFieldType: TextFieldType.PASSWORD,
                          suffixIconColor: Colors.black45,
                          decoration: kInputDecoration.copyWith(
                            labelText: 'Nouveau mot de passe',
                            hintText: 'Entrez nouveau mot de passe',
                            errorText: _passnouveaError,
                          ),
                          maxLength: 20,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 10.0,
                          right: 10.0,
                          bottom: 10.0,
                          top: 20.0,
                        ),
                        child: AppTextField(
                          suffixIconColor: Colors.black45,
                          controller: _passconfimController,
                          textFieldType: TextFieldType.PASSWORD,
                          decoration: kInputDecoration.copyWith(
                            labelText: 'Confirmer le nouveau mot de passe',
                            hintText: 'Confirmer le nouveau mot de passe',
                            errorText: _passnouveaError,
                          ),
                          maxLength: 20,
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                    ],
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
                                setState(() {
                                  _passnouveaError          =   null;
                                });

                                final passnouvea          =   _passnouveaController.text.length;
                                final passconfim          =   _passconfimController.text.length;
                                
                                
                                if(_passnouveaController.text.isNotEmpty || _passconfimController.text.isNotEmpty || _selectedPhoto != null ){

                                  if(_selectedPhoto == null){
                                    if (_passnouveaController.text.isEmpty || _passconfimController.text.isEmpty && _selectedPhoto == null) {
                                      setState(() {
                                        _passnouveaError    =   'Veuillez remplir les trois champs';
                                      });
                                    } else if (_passnouveaController.text != _passconfimController.text){
                                      setState(() {
                                          _passnouveaError = 'Les valeurs des de ces deux champs doivent se correspondent';
                                        });

                                    } else {
                                      if (passnouvea < 6 || passconfim < 6 ) {
                                        setState(() {
                                          _passnouveaError = 'Le mot de pass doit contenir au moins 6 caractères';
                                        });
                                      }
                                    }
                                  }

                                  final ProgressDialog pr = ProgressDialog(
                                    context,
                                    isDismissible: false,
                                  );

                                  pr.style(
                                    message: 'Opération en cours...', // Message affiché dans le dialogue
                                    progressWidget: const CircularProgressIndicator(), // Widget de progression (un cercle de progression)
                                  );

                                  await pr.show();
                                  // ignore: use_build_context_synchronously
                                  final ClientProvider clientProvider = Provider.of<ClientProvider>(context, listen: false);
                                  try {
                                    if(passnouvea >= 6 && passconfim >= 6 && _passnouveaController.text.isNotEmpty && _passconfimController.text.isNotEmpty && (_passnouveaController.text == _passconfimController.text)){
                                      await clientProvider.updateMonProfil(
                                        _passnouveaController.text.trim(),
                                      );
                                      _passnouveaController.clear();
                                      _passconfimController.clear();
                                    }
                                    if(_selectedPhoto != null){
                                      await clientProvider.editImageProfil(
                                        _selectedPhoto!,
                                      );
                                      setState(() {
                                        _selectedImage = null;
                                      });
                                    }
                                    await pr.hide(); // Cache le ProgressDialog lorsque l'opération est terminée
                                    showCustomDialog('Opération ruessie avec succès.', Icons.check, Colors.green);

                                  } catch (error) {

                                    await pr.hide(); // Cache le ProgressDialog en cas d'erreur
                                    showCustomDialog('Une erreur s\'est produite.', Icons.error, Colors.red);
                                  
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
                                        "Modifier",
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
    );
  }
}
