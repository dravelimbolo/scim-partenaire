import 'package:flutter/material.dart';
import 'home/screens/ajout_screen.dart';
import 'home/screens/home_screen.dart';
import 'home/screens/profil_screen.dart';
import 'home/screens/rejet_screen.dart';
import 'home/widgets/bouton/bottonnavy.dart';
import 'home/widgets/card/widgetcard/generic_text_widget.dart';

class Home extends StatefulWidget {
  static const String routeName = '/home';

  const Home({Key? key}) : super(key: key);

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {

  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[

    HomeScreen(),
    const AjouteScreen(),
    RejetScreen(),
    const Profil(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavyBar(
        showElevation: true,
        backgroundColor: const Color(0xFFFAFAFA),
        selectedIndex: _selectedIndex,
        onItemSelected:  (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items:  [
          BottomNavyBarItem(
            icon:  const Icon(Icons.home_rounded),
            title:  const GenericTextWidget("Accueil"),
            activeColor: const Color(0xFFE3C35A),
            inactiveColor: const Color(0xFF737373),
          ),
          BottomNavyBarItem(
            icon: const Icon(Icons.add_home_rounded),
            title:  const GenericTextWidget("Ajouter"),
            activeColor: const Color(0xFFE3C35A),
            inactiveColor: const Color(0xFF737373),
          ),
          BottomNavyBarItem(
            icon: const Icon(Icons.close),
            title:  const GenericTextWidget("Rejetées"),
            activeColor: const Color.fromARGB(255, 224, 42, 42),
            inactiveColor: const Color(0xFF737373),
          ),
          BottomNavyBarItem(
            icon: const Icon(Icons.person),
            title:  const GenericTextWidget("Profil"),
            activeColor: const Color(0xFFE3C35A),
            inactiveColor: const Color(0xFF737373),
          ),
        ],
        curve: Curves.ease,
      ),
    );
  }
}
