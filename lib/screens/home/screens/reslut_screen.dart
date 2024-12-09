import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:super_paging/super_paging.dart';
import '../../../providers/propriete/propriete.model.dart';
import '../../../providers/propriete/propriete.provider.dart';
import '../../../providers/user.dart';
import '../home_controller.dart';
import '../widgets/card/article_box_design_01.dart';
import '../widgets/card/widgetcard/generic_text_widget.dart';

enum   SelectedOptions { logout }

class ToutScreen extends StatelessWidget {

  static const String routeName = '/tout-screen';

  ToutScreen({super.key});

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
        title:  const GenericTextWidget(
          "Propriétés rejetées",
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
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => proprieteProvider.refche(),
          child: Column(
            children: [
              Consumer<ProprieteProvider>(
                builder: (context, provider, child) {
                  return Expanded(
                    child: PagingListView<int, Propriete>(
                      pager: provider.pager,
                      itemBuilder: (context, index) {
                        final propriete = provider.pager.items.elementAt(index);
                        return Dismissible(
                          key: Key(propriete.codeScim),
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
                            provider.deletePropriete(propriete.codeScim);
                          },
                          child: ChangeNotifierProvider.value(
                            value: propriete,
                            child: const Padding(
                              padding: EdgeInsets.only(left: 0.0, right: 0.0),
                              child: ArticleBox(),
                            ),
                          ),
                        );
                      },
                      loadingBuilder: (context) => const Center(child: CircularProgressIndicator.adaptive()),
                      errorBuilder: (context, error) => Center(child: Text('Erreur: $error')),
                      emptyBuilder: (context) => const Center(child: Text('Aucune propriété trouvée')),
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