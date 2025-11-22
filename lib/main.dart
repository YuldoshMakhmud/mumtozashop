import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mumtozashop/views/bottonNav/navPages/profile/support_page.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:mumtozashop/providers/cart_provider.dart';
import 'package:mumtozashop/providers/user_provider.dart';
import 'package:mumtozashop/views/auth/check_user_status.dart';
import 'package:mumtozashop/views/auth/create_account_page.dart';
import 'package:mumtozashop/views/auth/login_page.dart';
import 'package:mumtozashop/views/bottonNav/home_page.dart';
import 'package:mumtozashop/views/bottonNav/navPages/cart_page.dart';
import 'package:mumtozashop/views/bottonNav/navPages/orders/order_details_page.dart';
import 'package:mumtozashop/views/bottonNav/navPages/orders/orders_page.dart';
import 'package:mumtozashop/views/bottonNav/navPages/profile/edit_profile_page.dart';
import 'package:mumtozashop/views/checkout/checkout_page.dart';
import 'package:mumtozashop/views/coupons/coupons_page.dart';
import 'package:mumtozashop/views/products/product_details_page.dart';
import 'package:mumtozashop/views/products/show_products_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await EasyLocalization.ensureInitialized(); // <-- easy_localization

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('uz'), Locale('en'), Locale('ru')],
      path: 'assets/translation',
      fallbackLocale: const Locale('uz'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: MaterialApp(
        title: 'Mumtoza shop',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Sen-VariableFont_wght',
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFFF0F5)),
          useMaterial3: true,
        ),
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        routes: {
          "/": (context) => CheckUserStatus(),
          "/login": (context) => LoginPage(),
          "/signup": (context) => CreateAccountPage(),
          "/home": (context) => HomePage(),
          "/show_specific_products": (context) => ShowProductsPage(),
          "/product_details": (context) => ProductDetailsPage(),
          "/coupons": (context) => CouponsPage(),
          "/cart": (context) => CartPage(),
          "/checkout": (context) => CheckoutPage(),
          "/edit_profile": (context) => EditProfilePage(),
          "/support": (context) => SupportPage(),
          "/orders": (context) => OrdersPage(),
          "/order_details": (context) => OrderDetailsPage(),
        },
      ),
    );
  }
}
