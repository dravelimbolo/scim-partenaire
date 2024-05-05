import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scim_partenaire/providers/propriete/propriete.model.dart';
import 'package:scim_partenaire/providers/propriete/propriete.provider.dart';
import 'package:scim_partenaire/providers/user.dart';
import 'package:scim_partenaire/screens/home/home_controller.dart';
import 'package:scim_partenaire/screens/home/screens/profil/apropos_screen.dart';
import 'package:scim_partenaire/screens/home/widgets/card/article_box_design_01.dart';
import 'package:scim_partenaire/screens/home/widgets/card/widgetcard/generic_text_widget.dart';

class BoutonScreen extends StatelessWidget {

  static const String routeName = '/bouton-screen';

  final List<Propriete> proprietes;

  BoutonScreen({super.key, required this.proprietes});

  final HomeController controller = HomeController();

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

  @override
  Widget build(BuildContext context) {

    final ProprieteProvider proprieteProvider = Provider.of<ProprieteProvider>(context);

    return Scaffold(
      appBar: AppBar( 
          backgroundColor: const Color(0xFFE3C35A),
          title:  GenericTextWidget(
            proprietes.length < 2 ?
            "${proprietes.length.toString()} résultat":
            "${proprietes.length.toString()} résultats",
            strutStyle: const StrutStyle(height: 1),
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            children: [
              const SizedBox(height: 10),
                ListView.builder(
                scrollDirection: Axis.vertical,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: proprietes.length,
                itemBuilder: (_, index) {
                  return ChangeNotifierProvider.value(
                    value: proprietes[index],
                    child: const Padding(
                      padding: EdgeInsets.only(left: 0.0, right: 0.0),
                      child: ArticleBox(),
                    ),
                  );
                }
              )
            ],
          ),
        ),
      ),
    );
  }
}
