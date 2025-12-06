import 'package:flutter/material.dart';
import 'package:mumtozashop/views/bottonNav/navPages/defaultPage/bannerContainer/banner_container.dart';
import 'package:mumtozashop/views/bottonNav/navPages/defaultPage/category_container.dart';
import 'package:mumtozashop/views/bottonNav/navPages/defaultPage/coupon_container.dart';
import 'package:mumtozashop/views/bottonNav/navPages/defaultPage/promo_carousel_slider_container.dart';
import 'package:mumtozashop/views/widgets/segment_title.dart';

class DefaultPage extends StatefulWidget {
  const DefaultPage({super.key});

  @override
  State<DefaultPage> createState() => _DefaultPageState();
}

class _DefaultPageState extends State<DefaultPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFDD5D79),
        title: Column(
          children: [
            SizedBox(height: 5),
            Image.asset(
              "assets/images/icon.png",
              width: 140,
              color: Color(0xFFFFF5E1),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 11, vertical: 11),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 9),
              SegmentTitle(titleSegment: "Exclusive Offers"),
              SizedBox(height: 9),
              PromoCarouselSliderContainer(),
              SizedBox(height: 21),

              SegmentTitle(titleSegment: "Special Offers"),
              SizedBox(height: 9),
              CouponContainer(),
              SizedBox(height: 21),

              SegmentTitle(titleSegment: "Shop by Category"),
              SizedBox(height: 9),
              CategoryContainer(),
              SizedBox(height: 21),

              SegmentTitle(titleSegment: "Top Picks for You"),
              SizedBox(height: 9),
              BannerContainer(),
              SizedBox(height: 21),
            ],
          ),
        ),
      ),
    );
  }
}
