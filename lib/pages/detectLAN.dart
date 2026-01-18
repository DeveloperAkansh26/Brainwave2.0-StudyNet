import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:network_info_plus/network_info_plus.dart';

class NetworkHelper {
  final _connectivity = Connectivity();
  final _info = NetworkInfo();

  Future<Map<String, String?>> getNetworkDetails() async {
    final result = await _connectivity.checkConnectivity();
    if (result != ConnectivityResult.wifi) {
      return {"status": "Not on WiFi"};
    }

    final wifiName = await _info.getWifiName(); // SSID
    final wifiBSSID = await _info.getWifiBSSID(); // Router MAC
    final ip = await _info.getWifiIP();

    return {
      "status": "wifi",
      "ssid": wifiName,
      "bssid": wifiBSSID,
      "ip": ip,
    };
  }
}
