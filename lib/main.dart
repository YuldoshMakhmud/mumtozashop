import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mumtozashop/providers/cart_provider.dart';
import 'package:mumtozashop/providers/user_provider.dart';
import 'package:mumtozashop/views/auth/check_user_status.dart';
import 'package:mumtozashop/views/auth/create_account_page.dart';
import 'package:mumtozashop/views/auth/login_page.dart';
import 'package:mumtozashop/views/bottonNav/home_page.dart';
import 'package:mumtozashop/views/bottonNav/navPages/cart_page.dart';
import 'package:mumtozashop/views/bottonNav/navPages/profile/edit_profile_page.dart';
import 'package:mumtozashop/views/checkout/checkout_page.dart';
import 'package:mumtozashop/views/coupons/coupons_page.dart';
import 'package:mumtozashop/views/products/product_details_page.dart';
import 'package:mumtozashop/views/products/show_products_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => CartProvider()),
      ],
      child: MaterialApp(
        title: 'Snap & Shop eCommerce App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Couture',
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
          useMaterial3: true,
        ),
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
        },
      ),
    );
  }
}
