import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:network_info_plus/network_info_plus.dart';

class NetworkHelper {
  final _connectivity = Connectivity();
  final _info = NetworkInfo();

  /// Get current network details
  Future<Map<String, String?>> getNetworkDetails() async {
    // Check current connectivity
    final result = await _connectivity.checkConnectivity();

    if (result != ConnectivityResult.wifi) {
      return {"status": "Not on WiFi"};
    }

    // Fetch WiFi details
    final wifiName = await _info.getWifiName() ?? "";
    final wifiBSSID = await _info.getWifiBSSID() ?? "";
    final ip = await _info.getWifiIP() ?? "";

    // If SSID or IP is empty, WiFi info is not available
    if (wifiName.isEmpty || ip.isEmpty) {
      return {"status": "wifi_no_info"};
    }

    return {
      "status": "wifi",
      "ssid": wifiName,
      "bssid": wifiBSSID,
      "ip": ip,
    };
  }
}
