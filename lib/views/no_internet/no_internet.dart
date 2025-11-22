import 'package:flutter/material.dart';
import 'package:mumtozashop/service/connectivity_service.dart';

// Internet yo'q sahifasi
class NoInternetPage extends StatelessWidget {
  const NoInternetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Internet yo'q ikonka
              Icon(
                Icons.wifi_off_rounded,
                size: 120,
                color: Colors.grey.shade400,
              ),
              SizedBox(height: 32),

              // Sarlavha
              Text(
                "Internet yo'q",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),

              // Matn
              Text(
                "Iltimos, internet ulanishini tekshiring va qayta urinib ko'ring",
                style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),

              // Qayta urinish tugmasi
              ElevatedButton.icon(
                onPressed: () async {
                  ConnectivityService connectivityService =
                      ConnectivityService();
                  bool hasInternet = await connectivityService
                      .hasInternetConnection();

                  if (hasInternet) {
                    // Internet bo'lsa, orqaga qaytish
                    Navigator.pop(context);
                  } else {
                    // Internet yo'q bo'lsa xabar ko'rsatish
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Hali ham internet yo'q"),
                        backgroundColor: Colors.red.shade400,
                      ),
                    );
                  }
                },
                icon: Icon(Icons.refresh, color: Colors.white),
                label: Text(
                  "Qayta urinish",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pinkAccent,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
