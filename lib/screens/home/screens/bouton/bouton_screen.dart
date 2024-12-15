import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scim_partenaire/providers/propriete/propriete.model.dart';
import 'package:scim_partenaire/providers/propriete/propriete.provider.dart';
import 'package:scim_partenaire/providers/user.dart';
import 'package:scim_partenaire/screens/home/home_controller.dart';
import 'package:scim_partenaire/screens/home/screens/profil/apropos_screen.dart';
import 'package:scim_partenaire/screens/home/widgets/card/widgetcard/generic_text_widget.dart';
import 'package:super_paging/super_paging.dart';

import '../../../home.dart';
import '../../widgets/card/article_box_design_01.dart';

class BoutonScreen extends StatelessWidget {

  static const String routeName = '/bouton-screen';

  final String propriete;

  BoutonScreen({super.key, required this.propriete});

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
            propriete,
            strutStyle: const StrutStyle(height: 1),
            style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400, color:Colors.white),
          ),
          elevation:1.0,
          leading: Builder(
            builder: (context) {
              return IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Home(),
                      ),
                    );
                  },
                );
            }
          ),
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
        child: RefreshIndicator(
          onRefresh: () {
            if (propriete == "À louer") {
              return proprieteProvider.refchealouer();
            } else if (propriete == "À vendre") {
              return proprieteProvider.refcheavendre();
            } else if (propriete == "Loué") {
              return proprieteProvider.refcheloue();
            } else {
              return proprieteProvider.refchevendu();
            }
          },
          child: Column(
            children: [
              const SizedBox(height: 10),
              Consumer<ProprieteProvider>(
              builder: (context, provider, child) {
          
                Pager<int, Propriete> page;
                
                if(propriete=="À louer"){
                  
                  page  = provider.alouer;
          
                }else if(propriete=="À vendre"){
          
                  page  = provider.avendre;
          
                }else if(propriete=="Loué"){
          
                  page  = provider.loue;
          
                }else{
                  
                  page  = provider.vendu;
          
                }
                return Expanded(
                  child: PagingListView<int, Propriete>(
                    pager: page,
                    itemBuilder: (context, index) {
                      final annonce = page.items.elementAt(index);
                      return Dismissible(
                        key: Key(annonce.codeScim),
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 16.0),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          provider.deletePropriete(annonce.codeScim);
                        },
                        child: ChangeNotifierProvider.value(
                          value: annonce,
                          child: const Padding(
                            padding: EdgeInsets.only(left: 0.0, right: 0.0),
                            child: ArticleBox(),
                          ),
                        ),
                      );
                    },
                    loadingBuilder: (context) => const Center(child: CircularProgressIndicator.adaptive()),
                    errorBuilder: (context, error) => Center(child: Text('Erreur: $error')),
                    emptyBuilder: (context) => const Center(child: Text('Aucune annonce trouvée')),
                  ),
                );
              },
            ),
            ],
          ),
        ),
      ),
    );
  }
}
