import 'package:flutter/material.dart';
import '../../../../../config/theme/text_styles.dart';
import '../home_controller.dart';
import 'image_button.dart';

class NearbyLocation extends StatelessWidget {
  NearbyLocation({super.key});
  final HomeController controller = HomeController();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Arrondissements',
          style: AppTextStyles.bold14,
        ),
        const SizedBox(height: 10),
        SizedBox(
          child: GridView.count(
              shrinkWrap: true,
              crossAxisCount: 4,
              mainAxisSpacing: 4.0,
              crossAxisSpacing: 4.0,
              children: controller.locationNearby.asMap().entries.map((e) {
                int i = e.key;
                String title = e.value;
                return ImageButton(i, title);
              }).toList()),
        )
      ],
    );
  }
}
