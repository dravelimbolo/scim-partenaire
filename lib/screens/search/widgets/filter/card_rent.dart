/* import 'package:flutter/material.dart';
import '../../../../../../config/theme/app_color.dart';
import '../../../../../../config/theme/text_styles.dart';
import '../../search_controller.dart';
import 'category_box_check.dart';

class CardRent extends StatelessWidget {
  final MySearchController searchController;
  const CardRent(this.searchController, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 15),
      width: double.infinity,
      color: AppColors.white,
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 10,
              left: 16,
            ),
            child: Text(
              "Caractéristiques techniques",
              style: AppTextStyles.semiBold16.copyWith(color: AppColors.black),
            ),
          ),
          const SizedBox(height: 10),
          CategoryBoxCheck(
            title: "État intérieur",
            categorys: searchController.rentInteriorStatus.checkListItems,
            multipleSelected:
                searchController.rentInteriorStatus.multipleSelected,
            onChanged: searchController.rentInteriorStatus.onChange,
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
 */