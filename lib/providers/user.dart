import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart' show Response;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/io.dart';
import '../screens/home/screens/rejet_screen.dart';
import '../utils/http_exception.dart';


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

class User with ChangeNotifier {
  static const String domain = 'http://192.168.100.186:8000/';
  String? email;
  String? token;
  Timer? logoutTimer;
  IOWebSocketChannel? _channel;

  String? getEmail() => email;
  String? getToken() => token;


  Future<void> loginUser(String email, String password) async {
    Map<String, String> user = {'username': email, 'password': password};
    try {
      final Uri url = Uri.parse('${domain}api-token-auth/');
      final Response response = await http
          .post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(user),
      )
          .timeout(
        const Duration(seconds: 60),
        onTimeout: () {
          return http.Response('{"error": "Request TimeOut"}', 408);
        },
      );
      Map<String, dynamic> responseBody = json.decode(response.body);
      if (responseBody.containsKey('token') == true) {
        /// Create the user 'emain & token ID', when the user login successfully
        this.email = email;
        token = responseBody['token'];
        _autologout();
        notifyListeners();
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        final Map<String, String> userAuth = {
          'email': email,
          'token': token as String,
        };
        prefs.setString('userAuth', json.encode(userAuth));
      } else if (responseBody.containsKey('non_field_errors') == true) {
        /// Wrong username or password
        throw HttpException(responseBody['non_field_errors'][0]);
      } else if (responseBody.containsKey('error') == true) {
        throw HttpException(responseBody['error']);
      } else if (responseBody.containsKey('username') == true) {
        throw HttpException(responseBody['username'][0]);
      } else if (responseBody.containsKey('password') == true) {
        throw HttpException(responseBody['password'][0]);
      }
    } on HttpException catch (error) {
      throw HttpException(error.toString());
    } catch (error) {
      /// throw ERROR, when any errors occurs.
      throw error.toString();
    }
  }


  Future<bool> tryAutoLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey('userAuth') == false) {
      return false;
    } else {
      final Map<String, dynamic> userAuth =
          json.decode(prefs.getString('userAuth') as String);

      token = userAuth['token'];
      email = userAuth['email'];
      notifyListeners();
      _autologout();
      return true;
    }
  }


  Future<void> createNewUser(
    String firstName, String lastName, String email, String password) async {
    Map<String, String> user = {
      'first_name': firstName,
      'last_name': lastName,
      'username': email,
      'password': password,
    };

    try {
      final Uri url = Uri.parse('${domain}create-user/');
      final Response response = await http
          .post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(user),
      )
          .timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          return http.Response('{"error": "Request TimeOut"}', 408);
        },
      );
      Map<String, dynamic> responseBody = json.decode(response.body);
      if (responseBody.containsKey('username') == true &&
          responseBody['username'] != email) {
        throw HttpException(responseBody['username'][0]);
      } else if (responseBody.containsKey('email') == true &&
          responseBody['email'] != email) {
        throw HttpException(responseBody['email'][0]);
      } else if (responseBody.containsKey('error') == true) {
        throw HttpException(responseBody['error']);
      }
    } on HttpException catch (error) {
      throw HttpException(error.toString());
    } catch (error) {
      /// throw ERROR, when any errors occurs.
      throw error.toString();
    }
  }


  Future<void> logout() async {
    if (logoutTimer != null) {
      logoutTimer!.cancel();
      logoutTimer = null;
    }
    email = null;
    token = null;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('userAuth');
    notifyListeners();

    if (_channel != null) {
      _channel!.sink.close();
      _channel = null;
    }
  }

  void _autologout() {
    if (logoutTimer != null) {
      logoutTimer!.cancel();
    }

    final int days = DateTime.now().add(const Duration(days: 1)).day;
    logoutTimer = Timer(Duration(days: days), logout);
  }

  

  void connectWebSocket() {
    try {
      _channel = IOWebSocketChannel.connect(
        'ws://192.168.100.186:8000/ws/notifications/',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'TOKEN $token',
        },
      );
      _channel!.stream.listen((message) {
        _showNotification(message);
      }, onError: (error) {
        // Handle WebSocket error here
      }, onDone: () {
        // Handle WebSocket connection closed
      });
    } catch (e) {
      // Handle connection error
    }
  }


  
  Future<void> _showNotification(String message) async {
    Map<String, dynamic> data = jsonDecode(message);
    message = data["message"];
    String indenti  = data["indenti"];
    DateTime now = DateTime.now();
    int idnotif = int.parse("${now.day}${now.hour}${now.minute}${now.second}");
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.show(
      idnotif,
      indenti,
      message,
      platformChannelSpecifics,
      payload: RejetScreen.routeName,
    );
  }
}











