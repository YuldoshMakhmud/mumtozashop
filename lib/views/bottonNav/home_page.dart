import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mumtozashop/providers/user_provider.dart';

import 'navPages/cart_page.dart';
import 'navPages/defaultPage/default_page.dart';
import 'navPages/orders/orders_page.dart';
import 'navPages/profile/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int chosenIndex = 0;

  List navPages = [DefaultPage(), OrdersPage(), CartPage(), ProfilePage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navPages[chosenIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: chosenIndex,
        onTap: (index) {
          setState(() {
            chosenIndex = index;
          });
        },
        selectedItemColor: Color(0xFFFFF0F5),
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(
            backgroundColor: Color(0xFFDD5D79),
            icon: Icon(Icons.home_outlined),
            label: "Home".tr(),
          ),
          BottomNavigationBarItem(
            backgroundColor: Color(0xFFDD5D79),
            icon: Icon(Icons.local_shipping_outlined),
            label: "Orders".tr(),
          ),
          BottomNavigationBarItem(
            backgroundColor: Color(0xFFDD5D79),
            icon: Icon(Icons.shopping_cart_outlined),
            label: "Cart".tr(),
          ),
          BottomNavigationBarItem(
            backgroundColor: Color(0xFFDD5D79),
            icon: Icon(Icons.manage_accounts_outlined),
            label: "Profile".tr(),
          ),
        ],
      ),
    );
  }
}
