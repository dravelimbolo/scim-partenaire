import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scim_partenaire/providers/propriete/propriete.model.dart';
import 'package:scim_partenaire/providers/propriete/propriete.provider.dart';
import '../../screens/home/widgets/card/article_box_design_01.dart';
import '../../screens/home/widgets/card/widgetcard/article.shimer.dart';

class InforCardVerticalList extends StatelessWidget {
  const InforCardVerticalList({super.key});

  @override
  Widget build(BuildContext context) {
    final ProprieteProvider proprieteProvider =
        Provider.of<ProprieteProvider>(context);
    return FutureBuilder(
      future: proprieteProvider.fetchPropriete(),
      builder: (context, snapShot) {
        if (!snapShot.hasData) {
          return ListView.builder(
              scrollDirection: Axis.vertical,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: 2,
              itemBuilder: (_, index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 0.0, right: 0.0),
                  child: shimerarticleBox01(context: context),
                );
              });
        } else {
          List<Propriete> data = snapShot.data!
              .where((propriete) =>
                  propriete.okApprouver && !propriete.desapprouver)
              .toList();

          return ListView.builder(
              scrollDirection: Axis.vertical,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: data.length,
              itemBuilder: (_, index) {
                return ChangeNotifierProvider.value(
                  value: data[index],
                  child: const Padding(
                    padding: EdgeInsets.only(left: 0.0, right: 0.0),
                    child: ArticleBox(),
                  ),
                );
              });
        }
      },
    );
  }
}
