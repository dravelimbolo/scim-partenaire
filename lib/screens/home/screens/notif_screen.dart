import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/notification/notification.provider.dart';
import '../widgets/card/widgetcard/generic_text_widget.dart';

class Screen3 extends StatefulWidget {

  static const String routeName = '/notificat-screen';


  final  dynamic typenotife;
  final  dynamic notificat;
  final  dynamic codeNotification;
  

  const Screen3({super.key, required this.notificat, required this.typenotife, required this.codeNotification});

  @override
  Screen3State createState() => Screen3State();
}

class Screen3State extends State<Screen3> {
  
  @override
  Widget build(BuildContext context) {
    final NotificatProvider notificatprovider = Provider.of<NotificatProvider>(context);
    notificatprovider.updateNotification(widget.codeNotification.toString());
    return Scaffold(
      appBar: AppBar( 
        backgroundColor: const Color(0xFFE3C35A),
        title:  GenericTextWidget(
          widget.typenotife.toString() == "approuver" 
          ? "Approbation" 
          : widget.typenotife.toString() == "desapprover" 
          ? "Désapprobation" 
          : "Type inconnu",
          strutStyle: const  StrutStyle(height: 1),
          style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400, color:Colors.white),
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
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Flexible(
            child: Row(
              children: [
                Container(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white,
                    child: ListView(
                      children: [
                        messageFormatting(widget.notificat.toString(), "not me"),
                      ],
                    ))
              ],
            ),
          ),
          buildInput()
        ],
      ),
    );
  }

  Widget buildInput() {
    return Container(
      width: double.infinity,
      height: 80.0,
      decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey, width: 0.5)),
          color: Colors.white),
      child: Row(
        children: <Widget>[
          // Edit text
          const Flexible(
            child: Padding(
              padding: EdgeInsets.all(4.0),
              child: Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: TextField(
                  style: TextStyle(color: Colors.black, fontSize: 15.0),
                  decoration: InputDecoration(
                    suffixIcon: Icon(Icons.camera_alt, color: Colors.grey),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(6.0)),
                      borderSide: BorderSide(color: Colors.grey, width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(6.0)),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    hintText: 'Tapez votre message...',
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ),
          ),

          // Button send message
          Material(
            color: Colors.white,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              child: IconButton(
                icon: const Icon(Icons.send, color: Color(0xFFE3C35A)),
                color: Colors.red,
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget messageFormatting(message, sentBy) {
    return sentBy == "me"
        ? Container(
            margin: const EdgeInsets.all(5),
            padding: const EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFE3C35A),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(18),
                        topLeft: Radius.circular(18),
                        topRight: Radius.circular(18)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(
                      15,
                    ),
                    child: SizedBox(
                      width: message.length > 100 ? 160 : null,
                      child: Text(message,
                          overflow: TextOverflow.clip,
                          softWrap: true,
                          style: const TextStyle(color: Colors.white)),
                    ),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Container(
                      height: 35,
                      width: 35,
                      decoration: const BoxDecoration(
                          color: Colors.grey, shape: BoxShape.circle),
                    ))
              ],
            ),
          )
        : Container(
            margin: const EdgeInsets.all(5),
            padding: const EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Container(
                    height: 35,
                    width: 35,
                    decoration: const BoxDecoration(
                        color: Colors.grey, shape: BoxShape.circle),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(18),
                        topLeft: Radius.circular(18),
                        topRight: Radius.circular(18)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(
                      15,
                    ),
                    child: SizedBox(
                      width: message.length > 80 ? 260 : null,
                      child: Text(message,
                          overflow: TextOverflow.clip,
                          softWrap: true,
                          style: TextStyle(color: Colors.grey[700])),
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
