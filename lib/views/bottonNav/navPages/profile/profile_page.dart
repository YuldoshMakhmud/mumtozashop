import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mumtozashop/providers/user_provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Widget buildItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor ?? Colors.pinkAccent),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget dividerWidget() {
    return Divider(thickness: 0.8, indent: 16, endIndent: 16);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Profile",
          style: TextStyle(fontSize: 22, color: Colors.pinkAccent),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Consumer<UserProvider>(
              builder: (context, user, child) => Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.pink, Colors.pinkAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        size: 40,
                        color: Colors.pinkAccent,
                      ),
                    ),

                    SizedBox(width: 16),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.nameOfUser,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),

                          Text(
                            user.emailOfUser,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),

                    IconButton(
                      icon: const Icon(
                        Icons.edit_outlined,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, "/edit_profile");
                      },
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),

            buildItem(
              icon: Icons.local_shipping_outlined,
              title: "Orders",
              onTap: () => Navigator.pushNamed(context, "/orders"),
            ),

            dividerWidget(),

            buildItem(
              icon: Icons.discount_outlined,
              title: "Discount & Offers",
              onTap: () => Navigator.pushNamed(context, "/coupons"),
            ),

            dividerWidget(),

            buildItem(
              icon: Icons.logout_outlined,
              title: "Logout",
              iconColor: Colors.grey,
              onTap: () async {
                Provider.of<UserProvider>(
                  context,
                  listen: false,
                ).declineProvider();

                await FirebaseAuth.instance.signOut();

                Navigator.pushNamedAndRemoveUntil(
                  context,
                  "/login",
                  (route) => true,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
