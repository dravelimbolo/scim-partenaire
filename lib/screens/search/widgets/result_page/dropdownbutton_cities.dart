/* import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nhagiare_mobile/config/theme/app_color.dart';
import 'package:nhagiare_mobile/features/presentation/modules/search/search_controller.dart';

import '../../../../../../config/theme/text_styles.dart';
import '../../../../../domain/enums/navigate_type.dart';

class DropdownButtonCities extends StatefulWidget {
  const DropdownButtonCities({super.key});

  @override
  State<DropdownButtonCities> createState() => _DropdownButtonCitiesState();
}

class _DropdownButtonCitiesState extends State<DropdownButtonCities> {
  final MySearchController searchController = Get.find<MySearchController>();
  late List<DropdownMenuItem<String>> dropDownMenuItems;

  @override
  void initState() {
    searchController.getProvinceNames();
    searchController
        .changeSelectedProvince(searchController.provinceNames[0]['name']);
    dropDownMenuItems = searchController.provinceNames
        .map(
          (Map<String, dynamic> value) => DropdownMenuItem<String>(
            value: value['name'],
            child: Text(
              value['name'],
              style: AppTextStyles.regular14.copyWith(color: AppColors.black),
            ),
          ),
        )
        .toList();

    if (searchController.typeNavigate == TypeNavigate.province) {
      searchController.changeSelectedProvince(searchController.provinceHome!);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => DropdownButtonHideUnderline(
        child: DropdownButton2(
          isExpanded: true,
          value: searchController.selectedProvince!.value,
          style: AppTextStyles.regular14.copyWith(color: AppColors.black),
          onChanged: (String? newValue) {
            if (newValue != null) {
              searchController.changeSelectedProvince(newValue);
            }
          },
          items: dropDownMenuItems,
          buttonStyleData: const ButtonStyleData(
            height: 40,
            width: 160,
          ),
          menuItemStyleData: const MenuItemStyleData(
            height: 40,
          ),
          dropdownStyleData: const DropdownStyleData(
            maxHeight: 400,
          ),
        ),
      ),
    );
  }
}
 */