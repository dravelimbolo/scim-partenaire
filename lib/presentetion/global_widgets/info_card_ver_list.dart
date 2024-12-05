import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:super_paging/super_paging.dart';
import '../../providers/propriete/propriete.model.dart';
import '../../providers/propriete/propriete.provider.dart';
import '../../screens/home/widgets/card/article_box_design_01.dart';

class InforCardVerticalList extends StatelessWidget {
  const InforCardVerticalList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProprieteProvider>(
      builder: (context, provider, child) {
        return PagingListView<int, Propriete>(
          pager: provider.pager,
          itemBuilder: (context, index) {
            final propriete = provider.pager.items.elementAt(index);
            return ChangeNotifierProvider.value(
              value: propriete,
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: ArticleBox(),
              ),
            );
          },
          loadingBuilder: (context) => const Center(child: CircularProgressIndicator.adaptive()),
          errorBuilder: (context, error) => Center(child: Text('Erreur: $error')),
          emptyBuilder: (context) => const Center(child: Text('Aucune propriété trouvée')),
        );
      },
    );
  }
}
