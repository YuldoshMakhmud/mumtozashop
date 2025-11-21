import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
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
  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Language'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Text('🇺🇸'),
                title: Text('English'),
                onTap: () {
                  context.setLocale(Locale('en'));
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Text('🇺🇿'),
                title: Text('O\'zbekcha'),
                onTap: () {
                  context.setLocale(Locale('uz'));
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Text('🇷🇺'),
                title: Text('Русский'),
                onTap: () {
                  context.setLocale(Locale('ru'));
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

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
        actions: [
          IconButton(
            icon: Icon(Icons.language, color: Color(0xFFFFF5E1)),
            onPressed: _showLanguageDialog,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 11, vertical: 11),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 9),
              SegmentTitle(titleSegment: "exclusive_offers".tr()),
              SizedBox(height: 9),
              PromoCarouselSliderContainer(),
              SizedBox(height: 21),

              SegmentTitle(titleSegment: "special_offers".tr()),
              SizedBox(height: 9),
              CouponContainer(),
              SizedBox(height: 21),

              SegmentTitle(titleSegment: "shop_by_category".tr()),
              SizedBox(height: 9),
              CategoryContainer(),
              SizedBox(height: 21),

              SegmentTitle(titleSegment: "top_picks_for_you".tr()),
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

// Alternative: Dropdown button in AppBar
class LanguageDropdownButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<Locale>(
      value: context.locale,
      underline: Container(),
      icon: Icon(Icons.arrow_drop_down, color: Color(0xFFFFF5E1)),
      dropdownColor: Color(0xFFDD5D79),
      items: [
        DropdownMenuItem(
          value: Locale('en'),
          child: Text('EN', style: TextStyle(color: Color(0xFFFFF5E1))),
        ),
        DropdownMenuItem(
          value: Locale('uz'),
          child: Text('UZ', style: TextStyle(color: Color(0xFFFFF5E1))),
        ),
        DropdownMenuItem(
          value: Locale('ru'),
          child: Text('RU', style: TextStyle(color: Color(0xFFFFF5E1))),
        ),
      ],
      onChanged: (Locale? locale) {
        if (locale != null) {
          context.setLocale(locale);
        }
      },
    );
  }
}
