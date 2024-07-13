import 'package:flutter/material.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:provider/provider.dart';

import '../providers/user.dart';

import '../utils/constant.dart';
import '../utils/http_exception.dart';
import 'registration_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login-screen';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();

  bool _passwordVisibilityOff = true;
  bool _isRequestTimeOut = false;
  String? _username;
  String? _password;
  String? _emalErrorMessage, _passwordErrorMessage;

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
    
    User user = Provider.of<User>(context, listen: false);

    await pr.show();
    try {
      await user.loginUser(_username as String, _password!.trim());
      await pr.hide();
    } on HttpException catch (error) {
      if (error
          .toString()
          .contains('Unable to log in with provided credentials')) {
        _emalErrorMessage = 'Le numéro de téléphone ou le mot de passe est invalide.';
        _passwordErrorMessage = _emalErrorMessage;
        _isRequestTimeOut = false;
        setState(() {});
      } else if (error.toString().contains('Request TimeOut')) {
        _isRequestTimeOut = true;
        _emalErrorMessage = null;
        _passwordErrorMessage = _emalErrorMessage;
        setState(() {});
      }
      await pr.hide();
      _showAlertDialog(error.toString());
    } catch (error) {
      await pr.hide();
      _showAlertDialog(error.toString());
    }
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
          title: const Center(child: Text('Connexion',style: TextStyle(color: Colors.white),)),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Column(
              children: <Widget>[
                
                const SizedBox(
                  height: 30,
                ),
                Form(
                  key: _form,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        decoration: kInputDecoration.copyWith(
                          prefixIcon: const Icon(Icons.email),
                          labelText: 'Numéro de téléphone',
                          errorText: _emalErrorMessage,
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
                      const SizedBox(height: 30),
                      TextFormField(
                        obscureText: _passwordVisibilityOff,
                        decoration: kInputDecoration.copyWith(
                          prefixIcon: const Icon(Icons.password),
                          labelText: 'Mot de passe',
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
                            return 'Entrer votre mot de passe';
                          } else if (value.length < 8) {
                            return 'Le mot de passe doit comporter au moins 8 caractères.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _password = value;
                        },
                        onEditingComplete: () {
                          _isValid();
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                if (_isRequestTimeOut)
                  const Text(
                    'Temps imparti dépassé, veuillez réessayer ultérieurement.',
                    style: TextStyle(color: Colors.red),
                  ),
                const SizedBox(height: 15),
                buildButton('Connectez-vous', () {
                  submitForm();
                }),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Vous n\'avez pas de compte ?',
                      style: TextStyle(
                          color: Colors.black, fontSize: 14.0),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegistrationScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Inscrivez-vous',
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
          backgroundColor:  const Color(0xFFE3C35A),          elevation: 1,
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