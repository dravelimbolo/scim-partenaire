import 'package:flutter/material.dart';
import 'package:scim_partenaire/config/theme/app_color.dart';
import 'package:scim_partenaire/core/extensions/textstyle_ex.dart';

import 'text_styles.dart';

ThemeData appTheme() {
  return ThemeData(
    scaffoldBackgroundColor: AppColors.white,
    //fontFamily: 'Muli',
    appBarTheme: appBarTheme(),
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.green),
    useMaterial3: true,
  );
}

AppBarTheme appBarTheme() {
  return AppBarTheme(
    backgroundColor: Colors.white,
    elevation: 0,
    centerTitle: true,
    iconTheme: const IconThemeData(color: AppColors.black),
    titleTextStyle: AppTextStyles.semiBold18.colorEx(AppColors.green),
  );
}
