import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';
import '../../../../../config/theme/app_color.dart';
import '../../../../../config/theme/text_styles.dart';
import '../../config/values/asset_image.dart';
import '../../screens/home/home_controller.dart';
import '../../screens/home/widgets/icon_text.dart';

class InforCard extends StatelessWidget {

  InforCard({super.key, this.width, this.height, });

  final double? height;
  final double? width;
  final HomeController controller = HomeController();

  @override
  Widget build(BuildContext context) {
    double widthBox = width ?? 190;

    return ZoomTapAnimation(
      child: InkWell(
        onTap: () {
          // Get.toNamed(
          //   AppRoutes.getPostRoute(post.id!),
          //   arguments: post,
          // );
        },
        splashColor: AppColors.green,
        child: Container(
          width: widthBox,
          height: height ?? 10,
          decoration: BoxDecoration(
            color: AppColors.grey100,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                child: CachedNetworkImage(
                  imageUrl: controller.imgList.first,
                  fit: BoxFit.fill,
                  height: 100,
                  width: widthBox,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "post.title!",
                      style: AppTextStyles.bold12,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    const IconText(
                      icon: Assets.money,
                      text: "5000",
                      color: AppColors.orange,
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    const IconText(
                      icon: Assets.home,
                      text: "30 rue Batéké",
                      color: AppColors.grey500,
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    const IconText(
                      icon: Assets.clock,
                      text: '28/12/2023',
                      color: AppColors.grey500,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
