import 'package:flutter/material.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:provider/provider.dart';

import '../providers/user.dart';

import '../utils/constant.dart';
import '../utils/http_exception.dart';

class RegistrationScreen extends StatefulWidget {
  static const String routeName = "/registration-screen";
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();

  TextEditingController? _passwordController;
  FocusNode? _confirmPasswordFocusNode;
  bool _passwordVisibilityOff = true;
  bool _isTimeOut = false;
  String? _username, _emailErrorMessage, _passwordErrorMessage;
  String? _firstName, _lastName;
  String? _password;

  @override
  void initState() {
    _passwordController = TextEditingController();
    _confirmPasswordFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _passwordController!.dispose();
    _confirmPasswordFocusNode!.dispose();
    super.dispose();
  }

  bool _isValid() {
    if (_form.currentState!.validate() == false) {
      return false;
    }
    return true;
  }

  Future<void> submitForm() async {
    if (_isValid() == false) {
      return;
    }

    _form.currentState!.save();
    final ProgressDialog pr = ProgressDialog(
      context,
      isDismissible: false,
    );

    pr.style(
      message: 'Opération en cours...', // Message affiché dans le dialogue
      progressWidget: const CircularProgressIndicator(), // Widget de progression (un cercle de progression)
    );
    
    User userProvider = Provider.of<User>(context, listen: false);
    await pr.show();
    try {
      await userProvider.createNewUser(_firstName.toString(),_lastName.toString(), _username as String, _password!.trim());

      _emailErrorMessage = null;
      _passwordErrorMessage = null;
      _isTimeOut = false;
      setState(() {});
      await pr.hide();
      _showSuccessMessage();
      

    } on HttpException catch (error) {
      if (error.toString().contains('username already exists')) {
        setState(() {
          _emailErrorMessage = 'Le numéro de téléphone existe déjà.';
        });
      } else if (error.toString().contains('Request TimeOut')) {
        _emailErrorMessage = null;
        _passwordErrorMessage = null;
        _isTimeOut = true;
        setState(() {});
      }
      await pr.hide();
      _showAlertDialog(error.toString());
    } catch (error) {
      _emailErrorMessage = null;
      _passwordErrorMessage = null;
      _isTimeOut = false;
      setState(() {});
      await pr.hide();
      _showAlertDialog(error.toString());
    }
  }

  void _showSuccessMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('La création du compte a réussi. Vous pouvez maintenant vous connecter.'),
      ),
    );
  }

  Future<bool?> _showAlertDialog(String error) {
    return showDialog<bool?>(
      context: context,
      builder: (cntxt) {
        return AlertDialog(
          title: const Text('Erreur interne!'),
          content: Text(error),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Fermer'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFFE3C35A),          
          title: const Center(child: Text('Inscription',style: TextStyle(color: Colors.white),)),
          leading: Navigator.canPop(context)
          ? IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          : null,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 15),
            child: Column(
              children: <Widget>[
                Form(
                  key: _form,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        decoration:  kInputDecoration.copyWith(
                          prefixIcon: const Icon(Icons.person),
                          labelText: 'Prénom',
                        ),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value == null || value.isEmpty == true) {
                            return 'Entrez votre prénom.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _firstName = value;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        decoration:  kInputDecoration.copyWith(
                          prefixIcon: const Icon(Icons.person),
                          labelText: 'Nom de famille',
                        ),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value == null || value.isEmpty == true) {
                            return 'Entrez votre nom de famille.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _lastName = value;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        decoration: kInputDecoration.copyWith(
                          prefixIcon: const Icon(Icons.email),
                          labelText: 'Numéro de téléphone',
                          errorText: _emailErrorMessage,
                        ),
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value == null || value.isEmpty == true) {
                            return 'Entrez votre numéro de téléphone.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _username = value;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        obscureText: _passwordVisibilityOff,
                        controller: _passwordController,
                        decoration: kInputDecoration.copyWith(
                          prefixIcon: const Icon(Icons.password),
                          labelText: '"Mot de passe"',
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _passwordVisibilityOff =
                                    !_passwordVisibilityOff;
                              });
                            },
                            icon: Icon(_passwordVisibilityOff == true
                                ? Icons.visibility
                                : Icons.visibility_off),
                          ),
                          errorText: _passwordErrorMessage,
                        ),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        maxLength: 20,
                        validator: (value) {
                          if (value == null || value.isEmpty == true) {
                            return 'Entrez votre mot de passe.';
                          } else if (value.length < 8) {
                            return 'Le mot de passe doit comporter au moins 8 caractères.';
                          }
                          return null;
                        },
                        onEditingComplete: () {
                          FocusScope.of(context)
                              .requestFocus(_confirmPasswordFocusNode);
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        obscureText: _passwordVisibilityOff,
                        focusNode: _confirmPasswordFocusNode,
                        decoration: kInputDecoration.copyWith(
                          prefixIcon: const Icon(Icons.password),
                          labelText: 'Confirmez le mot de passe.',
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _passwordVisibilityOff =
                                    !_passwordVisibilityOff;
                              });
                            },
                            icon: Icon(_passwordVisibilityOff == true
                                ? Icons.visibility
                                : Icons.visibility_off),
                          ),
                          errorText: _passwordErrorMessage,
                        ),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                        maxLength: 20,
                        validator: (value) {
                          if (value == null || value.isEmpty == true) {
                            return 'Entrez le mot de passe de confirmation.';
                          } else if (value.length < 8) {
                            return 'Le mot de passe doit comporter au moins 8 caractères.';
                          } else if (_passwordController!.text.trim() !=
                              value.trim()) {
                            return 'Le mot de passe et la confirmation du mot de passe doivent être identiques.';
                          }

                          return null;
                        },
                        onEditingComplete: () {
                          _isValid();
                        },
                        onSaved: (value) {
                          _password = value;
                        },
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                if (_isTimeOut)
                  const Text(
                    'Temps imparti dépassé, veuillez réessayer ultérieurement.',
                    style: TextStyle(color: Colors.red),
                  ),
                const SizedBox(height: 15),
                buildButton('Inscrivez-vous', () {
                  submitForm();
                }),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Vous avez déjà de compte ?',
                      style: TextStyle(
                          color: Colors.black, fontSize: 14.0),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Connectez-vous',
                        style: TextStyle(
                            color: kMainColor, fontSize: 14.0),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildButton(String buttonText, VoidCallback onSubmit) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.93,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFE3C35A),
          elevation: 1,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0), // Définir le rayon des coins
          ),
        ),
        onPressed: onSubmit,
        child: Text(
          buttonText,
          style: const TextStyle(
            fontSize: 15,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}