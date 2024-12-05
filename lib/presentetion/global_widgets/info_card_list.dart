import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scim_partenaire/providers/propriete/propriete.model.dart';
import 'package:scim_partenaire/providers/propriete/propriete.provider.dart';
import '../../screens/home/widgets/card/article_box_design_01.dart';
import '../../screens/home/widgets/card/widgetcard/article.shimer.dart';

class InforCardHorizentalList extends StatelessWidget {
  const InforCardHorizentalList({super.key});

  @override
  Widget build(BuildContext context) {
    final ProprieteProvider proprieteProvider = Provider.of<ProprieteProvider>(context);
    // final Propriete task = Provider.of<Propriete>(context, listen: false);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FutureBuilder(
          future: proprieteProvider.fetchRechPropriete("","",0,0,"",""),
          builder: (context, snapShot) {
            if (!snapShot.hasData) {
              return SizedBox(
                height: 160,
                child: PageView.builder(
                  controller: PageController(viewportFraction: 0.96),
                  dragStartBehavior:DragStartBehavior.start,
                  itemCount: 3,
                  itemBuilder: (BuildContext context, int itemIndex) {
                    return shimerarticleBox01(context: context);
                  },
                ),
              );
            } else {
              List<Propriete> data = proprieteProvider.proprietes;
              return SizedBox(
                height: 160,
                child: PageView.builder(
                  controller: PageController(viewportFraction: 0.96),
                  dragStartBehavior:DragStartBehavior.start,
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int itemIndex) {
                    return ChangeNotifierProvider.value(
                      value: proprieteProvider.proprietes[itemIndex],
                      child: const ArticleBox()
                      );
                  },
                ),
              );
            }
          },
        ),
      ],
    );
  }
}
