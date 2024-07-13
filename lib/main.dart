import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

import './providers/user.dart';

import './screens/login_screen.dart';
import './screens/registration_screen.dart';
import './screens/loading_screen.dart';
import 'providers/bannier/bannier.provider.dart';
import 'providers/client/client.provider.dart';
import 'providers/propriete/propriete.provider.dart';
import 'screens/home.dart';
import 'screens/home/screens/ajout_screen.dart';
import 'screens/home/screens/home_screen.dart';
import 'screens/home/screens/profil/apropos_screen.dart';
import 'screens/home/screens/profil/confidentialite_screen.dart';
import 'screens/home/screens/rejet_screen.dart';


// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/launcher_icon');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static MaterialColor myColor = _createMaterialColor(const Color(0xFFE3C35A));

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (cntxt) => User(),
        ),
        ChangeNotifierProxyProvider<User, ClientProvider>(
          create: (cntxt) => ClientProvider(email: null, token: null, clients: []),
          update: (cntxt, userData, previousClients) => ClientProvider(
            email: userData.getEmail(),
            token: userData.getToken(),
            clients: previousClients != null ? previousClients.clients : [],
          ),
        ),
        ChangeNotifierProxyProvider<User, ProprieteProvider>(
          create: (cntxt) => ProprieteProvider(email: null, token: null, proprietes: []),
          update: (cntxt, userData, previousProprietes) => ProprieteProvider(
            email: userData.getEmail(),
            token: userData.getToken(),
            proprietes: previousProprietes != null ? previousProprietes.proprietes : [],
          ),
        ),
        ChangeNotifierProxyProvider<User, BannierProvider>(
          create: (cntxt) => BannierProvider(email: null, token: null, banniers: []),
          update: (cntxt, userData, previousBanniers) => BannierProvider(
            email: userData.getEmail(),
            token: userData.getToken(),
            banniers: previousBanniers != null ? previousBanniers.banniers : [],
          ),
        ),
      ],
      child: Consumer<User>(
        builder: (cnntxt, user, child) {
          SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'SCIM IMMO',
            theme: ThemeData(
              inputDecorationTheme: const InputDecorationTheme(
                fillColor: Color(0xFFE3C35A),
              ),
              appBarTheme: const AppBarTheme(systemOverlayStyle: SystemUiOverlayStyle(statusBarBrightness: Brightness.light)),
              brightness: Brightness.light,
              primaryColor: const Color(0xFFE3C35A),
              iconTheme: const IconThemeData(color: Color(0xFFE3C35A)),
              scaffoldBackgroundColor: Colors.white,
              fontFamily:'Rubik',
              dividerColor: const Color(0x1F000000),
              bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                backgroundColor: Color(0xFFFAFAFA),
                selectedItemColor: Color(0xFFE3C35A),
                unselectedItemColor: Color(0xFF737373),
              ),
              cardTheme: const CardTheme(surfaceTintColor: Colors.white),
              colorScheme: ColorScheme.fromSwatch(primarySwatch: myColor).copyWith(background: Colors.white),
            ),
            home: user.token != null
                ? const Home()
                : FutureBuilder(
                    future: user.tryAutoLogin(),
                    builder: (cntxt, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const LoadingScreen();
                      } else {
                        return const LoginScreen();
                      }
                    },
                  ),
            routes: {
              Home.routeName: (cntxt) => const Home(),
              HomeScreen.routeName: (cntxt) =>  HomeScreen(),
              AjouteScreen.routeName: (cntxt) =>  const AjouteScreen(),
              RejetScreen.routeName: (cntxt) =>  RejetScreen(),
              LoginScreen.routeName: (cntxt) => const LoginScreen(),
              ApropoScreen.routeName: (cntxt) => const ApropoScreen(),
              PoliticScreen.routeName: (cntxt) => const PoliticScreen(),
              RegistrationScreen.routeName: (cntxt) => const RegistrationScreen(),
            },
          );
        },
      ),
    );
  }
  static MaterialColor _createMaterialColor(Color color) {
    return MaterialColor(color.value, {
      50: color.withAlpha(50),
      100: color.withAlpha(100),
      200: color.withAlpha(200),
      300: color.withAlpha(300),
      400: color.withAlpha(400),
      500: color,
      600: color.withAlpha(600),
      700: color.withAlpha(700),
      800: color.withAlpha(800),
      900: color.withAlpha(900),
    });
  }
}
