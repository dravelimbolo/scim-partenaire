import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/propriete/propriete.model.dart';
import '../../../providers/propriete/propriete.provider.dart';
import '../../../providers/user.dart';
import '../home_controller.dart';
import '../widgets/card/article_box_design_01.dart';
import '../widgets/card/widgetcard/article.shimer.dart';
import '../widgets/card/widgetcard/generic_text_widget.dart';
import '../widgets/textfield_search.dart';

enum   SelectedOptions { logout }

class RejetScreen extends StatelessWidget {

  static const String routeName = '/sauvegarde-screen';

  RejetScreen({super.key});

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
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            children: [
              const SizedBox(height: 10),
              TextFiedSearch(),
              const SizedBox(height: 10),
                    // List<Propriete> data = spanshot.data!;
                FutureBuilder(
                  future: proprieteProvider.fetchPropriete(),
                  builder: (context, snapShot) {
                    if (!snapShot.hasData) {
                      return ListView.builder(
                        scrollDirection: Axis.vertical,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: 3,
                        itemBuilder: (_, index) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 0.0, right: 0.0),
                            child: shimerarticleBox01(context: context),
                          );
                        }
                      );
                    } else {
                      final List<Propriete> data = snapShot.data!.where((propriete) => propriete.desapprouver && !propriete.okApprouver).toList();
                      return  ListView.builder(
                        scrollDirection: Axis.vertical,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: data.length,
                        itemBuilder: (_, index) {
                          return Dismissible(
                            key: Key(data[index].codeScim),
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
                              proprieteProvider.deletePropriete(data[index].codeScim);
                            },
                            child: ChangeNotifierProvider.value(
                              value: data[index],
                              child: const Padding(
                                padding: EdgeInsets.only(left: 0.0, right: 0.0),
                                child: ArticleBox(),
                              ),
                            ),
                          );
                        }
                      );
                    }
                  },
                )
            ],
          ),
        ),
      ),
    );
  }
}
