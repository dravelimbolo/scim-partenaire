import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:loading_gifs/loading_gifs.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';



class FullScreenImageView extends StatefulWidget{
  final List<String> imageUrls;
  final String tag;
  final bool floorPlan;

  @override
  State<StatefulWidget> createState() => _FullScreenImageViewState();

  const FullScreenImageView({super.key, 
    required this.imageUrls,
    required this.tag,
    required this.floorPlan,
  });

}

class _FullScreenImageViewState extends State<FullScreenImageView> {

  String currentImage = "";
  String toastMessage = "";

  int progress = 0;
  String? status;
  String? filePath;

  PageController pageController = PageController();
  VoidCallback? downloadManagerListener;

  final _transformationController = TransformationController();
  late TapDownDetails _doubleTapDetails;

  @override
  void initState() {
    super.initState();
  }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Color(0XFF242527),
        statusBarIconBrightness: Brightness.light,
      ),
      // value: AppThemePreferences().appTheme.systemUiOverlayStyle,
      child: Scaffold(
        backgroundColor: const Color(0xFF18191B),
        body: Stack(
          children: [
            GestureDetector(
              onDoubleTapDown: (d) => _doubleTapDetails = d,
              onDoubleTap: _handleDoubleTap,
              child: Center(
                child: InteractiveViewer(
                  transformationController: _transformationController,
                  child: Center(
                    child: widget.floorPlan == true ?
                    imageListPageView(context: context, list: widget.imageUrls)
                    : Hero(
                      tag: widget.tag,
                      child: imageListPageView(context: context, list: widget.imageUrls),
                    ),
                  ),
                ),
              ),
            ),
            widget.floorPlan == true ? Container() : imageIndicatorsWidget(list: widget.imageUrls),
            TopBarWidget(imageUrl: currentImage),
          ],
        ),

      ),
    );
  }

  void _handleDoubleTap() {
    if (_transformationController.value != Matrix4.identity()) {
      _transformationController.value = Matrix4.identity();
    } else {
      final position = _doubleTapDetails.localPosition;
      _transformationController.value = Matrix4.identity()
      // For a 3x zoom
      //   ..translate(-position.dx * 2, -position.dy * 2)
      //   ..scale(3.0);
      // Fox a 2x zoom
      ..translate(-position.dx, -position.dy)
      ..scale(2.0);
    }
  }

  Widget imageListPageView({
  required BuildContext context,
  required List<String> list,
}){
    return PageView(
      controller: pageController,
      children: List.generate(
          list.length, (index) {
        currentImage = list[index];
            return FadeInImage.assetNetwork(
          placeholder: cupertinoActivityIndicatorSmall,
          image: list[index],
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.fitWidth,
        );
          },
      ),

    );
  }

  Widget imageIndicatorsWidget({
    required List<String> list,
  }){
    return Positioned(
      bottom: 10,
      left: 0,
      right: 0,
      child: Center(
        child: list.length > 1 ? SmoothPageIndicator(
          controller: pageController,
          count: list.length,
          effect: const ScrollingDotsEffect(
            dotHeight: 12.0,
            dotWidth: 12.0,
            spacing: 12,
            activeDotColor: Color(0xFFE3C35A),
          ),
        ) : Container(),
      ),
    );
  }
}

class TopBarWidget extends StatelessWidget {
  final String imageUrl;

  const TopBarWidget({
    super.key,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      // top: MediaQuery.of(context).padding.top,
      child: SafeArea(
        child: Container(
          height: 70,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 20.0,
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                      size: 20.0,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                )
              ),
              Expanded(
                flex: 6,
                child: Container(),
              ),
              Expanded(
                flex: 2,
                child:CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 20.0,
                  child: IconButton(
                    icon: const Icon(
                      Icons.file_download_outlined,
                      color: Colors.black,
                      size: 20.0,
                    ),
                    onPressed: () async {
                      try {
                        var file = await DefaultCacheManager().getSingleFile(imageUrl);
                        late Directory appDocumentDir;
                        if (Platform.isAndroid) {
                          appDocumentDir = Directory('/storage/emulated/0/Download');
                        } else if (Platform.isIOS) {
                          appDocumentDir = await getApplicationDocumentsDirectory();
                        }
                        String path = appDocumentDir.path;
                        String fileName = basename(imageUrl);
                        String newPath = '$path/$fileName';

                        var newFile = File(newPath);

                        if (newFile.existsSync()) {
                          var nameWithoutExtension = fileName.split('.').first;
                          var extension = fileName.split('.').last;
                          var count = 1;

                          do {
                            fileName = '$nameWithoutExtension-$count.$extension';
                            newPath = '$path/$fileName';
                            newFile = File(newPath);
                            count++;
                          } while (newFile.existsSync());
                        }

                        try{
                          await file.copy(newPath);
                          // ignore: avoid_print
                          print("image_download_success");

                        } catch (error) {
                          // ignore: avoid_print
                          print("download image error 01: $error");
                          
                        }
                      } catch(error) {
                        // ignore: avoid_print
                        print("download image error 02: $error");
                        
                      }

                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



