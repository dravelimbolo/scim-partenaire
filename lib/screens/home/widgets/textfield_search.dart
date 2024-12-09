import 'package:flutter/material.dart';
import '../home_controller.dart';
import '../screens/ajout_screen.dart';
import 'card/widgetcard/generic_text_widget.dart';

class TextFiedSearch extends StatelessWidget {
  TextFiedSearch({super.key});
  final HomeController controller = HomeController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      height: 45,
      child: Row(
        children: [
          Expanded(
            flex: 7,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AjouteScreen(),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.only(right: 0,left: 10),
                height: 45,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  border: Border.all(color:Colors.grey[100]!, width: 0),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(5),
                    bottomLeft: Radius.circular(5),
                    topRight: Radius.circular(0),
                    bottomRight: Radius.circular(0),
                    //
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.search, size: 18.0, color: Colors.black54),
                    Padding(
                      padding: EdgeInsets.only(
                          right: 10,
                          left:  10),
                      child: GenericTextWidget(
                        "Recherche",
                        style: TextStyle(fontSize: 14, color: Colors.black54, fontWeight: FontWeight.w400),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AjouteScreen(),
                  ),
                );
              },
              child: Container(
                height: 45,
                padding: const EdgeInsets.only(right: 0, left:  10),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  border: Border.all(
                      color:
                      Colors.grey[100]!,
                      width: 0),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(0),
                    bottomLeft:  Radius.circular(0),
                    topRight: Radius.circular(5),
                    bottomRight: Radius.circular(5),
                  ),
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AjouteScreen(),
                      ),
                    );
                  },
                  child: const Icon(Icons.tune, size: 18.0, color: Colors.black54)
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
