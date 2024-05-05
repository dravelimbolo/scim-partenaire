// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget shimerarticleBox01({
  required BuildContext context,
}) {
  return Container(
    decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10))),
    height: 155,
    child: Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: BorderSide.none,
      ),
      elevation: 1.0,
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShimmerImageWidget(),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerPropertyTitleWidget(),
                  ShimmerPropertyTagsWidget(),
                  ShimmerPropertyAddressWidget(),
                  ShimmerPropertyFeaturesWidget(),
                  ShimmerPropertyDetailsWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

// Utilisez la même approche pour envelopper chaque composant avec Shimmer
Widget ShimmerImageWidget() {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: Padding(
      padding: const EdgeInsets.all(10),
      child: SizedBox(
        height: 150,
        width: 120,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Container(color: Colors.grey[300]),
        ),
      ),
    ),
  );
}

Widget ShimmerPropertyTitleWidget() {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Container(height: 18, color: Colors.grey[300]),
    ),
  );
}

Widget ShimmerPropertyTagsWidget() {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Container(height: 14, color: Colors.grey[300]),
    ),
  );
}

Widget ShimmerPropertyAddressWidget() {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(height: 12, width: 17, color: Colors.grey[300]),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Container(height: 12, color: Colors.grey[300]),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget ShimmerPropertyFeaturesWidget() {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(height: 12, width: 17, color: Colors.grey[300]),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: Container(height: 12, color: Colors.grey[300]),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0),
            child: Row(
              children: [
                Container(height: 12, width: 17, color: Colors.grey[300]),
                Padding(
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  child: Container(height: 12, color: Colors.grey[300]),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                 Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                    child: Container(height: 12, width: 17, color: Colors.grey[300]),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(height: 12, color: Colors.grey[300]),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget ShimmerPropertyDetailsWidget() {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(right: 5),
              child: Container(height: 12, color: Colors.grey[300]),
            ),
          ),
          Container(height: 12, color: Colors.grey[300]),
        ],
      ),
    ),
  );
}
