import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mumtozashop/viewModel/category_view_model.dart';
import 'package:mumtozashop/viewModel/promo_banner_view_model.dart';
import 'package:mumtozashop/views/bottonNav/navPages/defaultPage/bannerContainer/banner_products.dart';
import 'package:mumtozashop/views/widgets/banner_ui.dart';
import '../../../../../models/category_model.dart';

class BannerContainer extends StatefulWidget {
  const BannerContainer({super.key});

  @override
  State<BannerContainer> createState() => _BannerContainerState();
}

class _BannerContainerState extends State<BannerContainer> {
  PromoBannerViewModel promoBannerModel = PromoBannerViewModel();
  CategoryViewModel categoryViewModel = CategoryViewModel();

  int minLength = 0;

  int minCalculator(int totalCategories, int totalBanners) {
    return minLength = totalCategories > totalBanners
        ? totalBanners
        : totalCategories;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: categoryViewModel.fetchCategories(),
      builder: (context, categorySnapshot) {
        if (categorySnapshot.hasData) {
          List<CategoryModel> categories = CategoryModel.fromJsonList(
            categorySnapshot.data!.docs,
          );

          if (categories.isEmpty) {
            return SizedBox();
          } else {
            return StreamBuilder(
              stream: promoBannerModel.fetchPromoBanner(false),
              builder: (context, bannerSnapshot) {
                if (bannerSnapshot.hasData) {
                  final int length = minCalculator(
                    categorySnapshot.data!.docs.length,
                    bannerSnapshot.data!.docs.length,
                  );

                  return Column(
                    children: [
                      for (int i = 0; i < length; i++)
                        Column(
                          children: [
                            //display products
                            BannerProducts(
                              categoryName:
                                  categorySnapshot.data!.docs[i]["name"],
                            ),

                            //display banners
                            BannerUi(
                              image: base64Decode(
                                bannerSnapshot.data!.docs[i]["image"],
                              ),
                              category:
                                  bannerSnapshot.data!.docs[i]["category"],
                            ),
                          ],
                        ),
                    ],
                  );
                } else {
                  return Container(color: Colors.pinkAccent);
                }
              },
            );
          }
        } else {
          return CircularProgressIndicator(color: Colors.pinkAccent);
        }
      },
    );
  }
}
