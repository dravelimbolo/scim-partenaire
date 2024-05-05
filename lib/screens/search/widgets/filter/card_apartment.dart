/* import 'package:flutter/material.dart';
import '../../../../../../config/theme/app_color.dart';
import '../../../../../../config/theme/text_styles.dart';
import '../../search_controller.dart';
import 'category_box_check.dart';
import 'category_box_radio.dart';

class CardApartment extends StatelessWidget {
  final MySearchController searchController;
  const CardApartment(this.searchController, {super.key});

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
          CategoryBoxRadio(
            title: "Statut",
            categorys: searchController.apartmentStatus.values,
            selected: searchController.apartmentStatus.selectedValue,
            onChanged: searchController.apartmentStatus.onChange,
          ),
          const SizedBox(height: 10),
          CategoryBoxCheck(
            title: "Type d'appartement",
            categorys: searchController.apartmentTypes.checkListItems,
            multipleSelected: searchController.apartmentTypes.multipleSelected,
            onChanged: searchController.apartmentTypes.onChange,
          ),
          const SizedBox(height: 10),
          CategoryBoxRadio(
            title: "Caractéristiques de l'appartement",
            categorys: searchController.apartmentCharacteristics.values,
            selected: searchController.apartmentCharacteristics.selectedValue,
            onChanged: searchController.apartmentCharacteristics.onChange,
          ),
          const SizedBox(height: 10),
          CategoryBoxCheck(
            title: "Nombre de chambres",
            categorys: searchController.apartmentBedroomNumber.checkListItems,
            multipleSelected:
                searchController.apartmentBedroomNumber.multipleSelected,
            onChanged: searchController.apartmentBedroomNumber.onChange,
          ),
          const SizedBox(height: 10),
          CategoryBoxCheck(
            title: "Sens de la porte principale",
            categorys: searchController.apartmentMainDirection.checkListItems,
            multipleSelected:
                searchController.apartmentMainDirection.multipleSelected,
            onChanged: searchController.apartmentMainDirection.onChange,
          ),
          const SizedBox(height: 10),
          CategoryBoxCheck(
            title: "Orientation balcon",
            categorys:
                searchController.apartmentBalconyDirection.checkListItems,
            multipleSelected:
                searchController.apartmentBalconyDirection.multipleSelected,
            onChanged: searchController.apartmentBalconyDirection.onChange,
          ),
          const SizedBox(height: 10),
          CategoryBoxCheck(
            title: "Actes légaux",
            categorys: searchController.apartmentLegalDocuments.checkListItems,
            multipleSelected:
                searchController.apartmentLegalDocuments.multipleSelected,
            onChanged: searchController.apartmentLegalDocuments.onChange,
          ),
          const SizedBox(height: 10),
          CategoryBoxCheck(
            title: "État intérieur",
            categorys: searchController.apartmentInteriorStatus.checkListItems,
            multipleSelected:
                searchController.apartmentInteriorStatus.multipleSelected,
            onChanged: searchController.apartmentInteriorStatus.onChange,
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
 */