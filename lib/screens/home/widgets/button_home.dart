import 'package:flutter/material.dart';
import 'package:scim_partenaire/core/extensions/textstyle_ex.dart';
import '../../../../../config/theme/app_color.dart';
import '../../../../../config/theme/text_styles.dart';

class ButtonHome extends StatelessWidget {
  const ButtonHome({
    required this.title,
    required this.icon,
    required this.type,
    required this.onTap,
    super.key,
  });

  final String title;
  final String icon;
  final bool type;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => onTap(),
      style: ElevatedButton.styleFrom(
        backgroundColor: type ? AppColors.green : AppColors.white,
        padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 10),
        textStyle: const TextStyle(color: AppColors.white),
        elevation: 0,
        minimumSize: const Size(35, 30),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      child: Row(
        children: [
          Image.asset(
            icon,
            width: 20,
            height: 20,
          ),
          const SizedBox(width: 5),
          Text(
            title,
            style: AppTextStyles.medium14
                .colorEx(type ? AppColors.white : AppColors.green),
          ),
        ],
      ),
    );
  }
}
