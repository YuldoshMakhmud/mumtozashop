import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();

  // Internet bormi yo'qmi tekshirish
  Future<bool> hasInternetConnection() async {
    try {
      var connectivityResult = await _connectivity.checkConnectivity();

      // Agar WiFi yoki mobile data bo'lsa
      if (connectivityResult.contains(ConnectivityResult.mobile) ||
          connectivityResult.contains(ConnectivityResult.wifi)) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // Internet o'zgarishini kuzatish (stream)
  Stream<bool> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged.map((result) {
      return result.contains(ConnectivityResult.mobile) ||
          result.contains(ConnectivityResult.wifi);
    });
  }
}
