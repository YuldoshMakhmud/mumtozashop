import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mumtozashop/providers/user_provider.dart';
import 'package:mumtozashop/views/auth/check_user_status.dart';
import 'package:mumtozashop/views/auth/create_account_page.dart';
import 'package:mumtozashop/views/auth/login_page.dart';
import 'package:mumtozashop/views/bottonNav/home_page.dart';
import 'package:provider/provider.dart';

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
      providers: [ChangeNotifierProvider(create: (context) => UserProvider())],
      child: MaterialApp(
        title: 'Mumtoza Shop',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Sen-VariableFont_wght',
          colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFFDD5D79)),
          useMaterial3: true,
        ),
        routes: {
          "/": (context) => CheckUserStatus(),
          "/login": (context) => LoginPage(),
          "/signup": (context) => CreateAccountPage(),
          "/home": (context) => HomePage(),
        },
      ),
    );
  }
}
