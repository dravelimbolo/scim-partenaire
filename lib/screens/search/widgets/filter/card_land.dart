/* import 'package:flutter/material.dart';

import '../../../../../../config/theme/app_color.dart';
import '../../../../../../config/theme/text_styles.dart';
import '../../search_controller.dart';
import 'category_box_check.dart';

class CardLand extends StatelessWidget {
  final MySearchController searchController;
  const CardLand(this.searchController, {super.key});

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
            title: "Type de terrain",
            categorys: searchController.landTypes.checkListItems,
            multipleSelected: searchController.landTypes.multipleSelected,
            onChanged: searchController.landTypes.onChange,
          ),
          const SizedBox(height: 10),
          CategoryBoxCheck(
            title: "Caractéristiques maison/terrain",
            categorys: searchController.landCharacteristics.checkListItems,
            multipleSelected:
                searchController.landCharacteristics.multipleSelected,
            onChanged: searchController.landCharacteristics.onChange,
          ),
          const SizedBox(height: 10),
          CategoryBoxCheck(
            title: "Orientation terrestre",
            categorys: searchController.landDirection.checkListItems,
            multipleSelected: searchController.landDirection.multipleSelected,
            onChanged: searchController.landDirection.onChange,
          ),
          const SizedBox(height: 10),
          CategoryBoxCheck(
            title: "Documents juridiques",
            categorys: searchController.landLegalDocuments.checkListItems,
            multipleSelected:
                searchController.landLegalDocuments.multipleSelected,
            onChanged: searchController.landLegalDocuments.onChange,
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
 */