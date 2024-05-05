import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:scim_partenaire/screens/home/widgets/detailarticle/pagedetail.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../card/widgetcard/generic_text_widget.dart';

class PropertyDetailPageImages extends StatefulWidget {

  final List<String> imageUrlsList;

  const PropertyDetailPageImages({
    super.key, required this.imageUrlsList,
  });

  

  @override
  State<PropertyDetailPageImages> createState() => PropertyDetailPageImagesState();
}

class PropertyDetailPageImagesState extends State<PropertyDetailPageImages> {

  int currentImageIndex = 0;
  PageController pageController = PageController(initialPage: 0);


  @override
  Widget build(BuildContext context) {
    
    return Stack(
      children: <Widget>[
        articleImagesWidget(),
        imageIndicators(),
        imageCountIndicator(),
      ],
    );
  }

  Widget articleImagesWidget() {
    return SizedBox(
      height: 300,
      child: PageView(
        controller: pageController,
        onPageChanged: (int page) {
          setState(() {
            currentImageIndex = page;
          });
        },
        children: List.generate(
          widget.imageUrlsList.length,
          (index) {
            return GestureDetector(
              child: CachedNetworkImage(
                imageUrl: widget.imageUrlsList[index],
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        FullScreenImageView(
                          imageUrls: widget.imageUrlsList,
                          tag: "widget.heroId",
                          floorPlan: false,
                        ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }


  Widget imageIndicators() {
    return Positioned(
      bottom: 10,
      left: 0,
      right: 0,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: widget.imageUrlsList.length > 1
            ? SmoothPageIndicator(
          controller: pageController,
          count: widget.imageUrlsList.length,
          effect: ScrollingDotsEffect(
            dotHeight: 10.0,
            dotWidth: 10.0,
            spacing: 10,
            dotColor: Colors.grey[400]!,
            activeDotColor: const Color(0xFFE3C35A),
          ),
        )
            : Container(),
      ),
    );
  }

  Widget imageCountIndicator() {
    return Positioned(
      bottom: 30,
      left:  10 ,
      right: 10,
      child: Align(
        alignment: Alignment.bottomRight,
        child: widget.imageUrlsList.length > 1
            ? Container(
          width: 55,
          padding: const EdgeInsets.all(5),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.photo_camera_outlined, size: 20.0, color:  Colors.black),
              GenericTextWidget(
                " ${currentImageIndex + 1}/${widget.imageUrlsList.length}",
                style: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.w400, color:  Colors.black),
              ),
            ],
          ),
        )
            : Container(),
      ),
    );
  }


}