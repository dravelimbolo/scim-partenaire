import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scim_partenaire/providers/bannier/bannier.model.dart';
import 'package:scim_partenaire/providers/bannier/bannier.provider.dart';
import '../../../presentetion/global_widgets/carousel_ad.dart';
import '../../../presentetion/global_widgets/info_card_ver_list.dart';
import '../../home.dart';
import '../home_controller.dart';
import '../widgets/bouton/bottoncercle.dart';
import '../widgets/card/widgetcard/generic_text_widget.dart';
import '../widgets/home_appbar.dart';
import 'package:scim_partenaire/screens/home/widgets/textfield_search.dart';

class HomeScreen extends StatelessWidget {

  static const String routeName = '/list-screen';

  HomeScreen({super.key});

  final HomeController controller = HomeController();

  @override
  Widget build(BuildContext context) {

    final BannierProvider bannierProvider = Provider.of<BannierProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            children: [
              // Appbar
              const HomeAppbar(),
              // search
              const SizedBox(height: 10),
              TextFiedSearch(),
              const SizedBox(height: 10),
              FutureBuilder(
                future: bannierProvider.fetchBannier(),
                builder: (cntxt, spanshot) {
                  if (spanshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }else if (spanshot.hasData){
                    List<Bannier> banniers = spanshot.data!;
                    return CarouselAd(
                      imgList: banniers.map((bannier) => bannier.image).toList(),
                      aspectRatio: 2.59,
                      indicatorSize: 6,
                    );
                  }else{
                    return const Center(child: CircularProgressIndicator());
                  }
                }
              ),
              const SizedBox(height: 10),
              const TermWithIconsWidget(),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            padding: const EdgeInsets.all(0.0),
                            child: GenericTextWidget(
                              'Vos annonces',
                              strutStyle: const StrutStyle(height: 1.5),
                              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, color:  Colors.grey[600]),
                            ),
                          ),
                        )
                      ),
                      Expanded(
                        child: GestureDetector(
                          // onTap: () {
                          //   setRouteToNavigate();
                          // },
                          child: const Padding(
                            padding: EdgeInsets.only(left : 0,right:  8.0,top: 5),
                            child: GenericTextWidget(
                              "Voir plus >",
                              style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500, color:Color(0xFFE3C35A)),
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const InforCardVerticalList(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
