import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  final String phoneNumber = "+998909882781";
  final String emailAddress = "yuldoshevcoder@gmail.com";

  void _launchPhone() async {
    final Uri url = Uri(scheme: 'tel', path: phoneNumber);
    if (!await launchUrl(url)) throw 'Could not launch $url';
  }

  void _launchEmail() async {
    final Uri url = Uri(scheme: 'mailto', path: emailAddress);
    if (!await launchUrl(url)) throw 'Could not launch $url';
  }

  Widget _buildContactCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
          child: Row(
            children: [
              Icon(icon, color: iconColor ?? Colors.pinkAccent, size: 32),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 20, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Support".tr(),
          style: const TextStyle(color: Colors.pinkAccent),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.pinkAccent),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 24),
          _buildContactCard(
            icon: Icons.phone_outlined,
            title: phoneNumber,
            onTap: _launchPhone,
            iconColor: Colors.green,
          ),
          _buildContactCard(
            icon: Icons.telegram,
            title: "@EnglishTeacherPE",
            onTap: () {},
            iconColor: Colors.blue,
          ),
          _buildContactCard(
            icon: Icons.email_outlined,
            title: emailAddress,
            onTap: _launchEmail,
            iconColor: Colors.orange,
          ),
        ],
      ),
    );
  }
}
