/* import 'package:flutter/material.dart';
import '../../../../../../config/theme/app_color.dart';
import '../../../../../../config/theme/text_styles.dart';
import '../../search_controller.dart';
import 'category_box_check.dart';

class CardOffice extends StatelessWidget {
  final MySearchController searchController;
  const CardOffice(this.searchController, {super.key});

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
            title: "Type de bureau",
            categorys: searchController.officeType.checkListItems,
            multipleSelected: searchController.officeType.multipleSelected,
            onChanged: searchController.officeType.onChange,
          ),
          const SizedBox(height: 10),
          CategoryBoxCheck(
            title: "Sens de la porte principale",
            categorys: searchController.officeDirection.checkListItems,
            multipleSelected: searchController.officeDirection.multipleSelected,
            onChanged: searchController.officeDirection.onChange,
          ),
          const SizedBox(height: 10),
          CategoryBoxCheck(
            title: "Actes légaux",
            categorys: searchController.officeLegalDocuments.checkListItems,
            multipleSelected:
                searchController.officeLegalDocuments.multipleSelected,
            onChanged: searchController.officeLegalDocuments.onChange,
          ),
          const SizedBox(height: 10),
          CategoryBoxCheck(
            title: "État intérieur",
            categorys: searchController.officeInteriorStatus.checkListItems,
            multipleSelected:
                searchController.officeInteriorStatus.multipleSelected,
            onChanged: searchController.officeInteriorStatus.onChange,
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
 */