import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectionsNetwork {
  static Future<bool> isConnected() async {
    List<ConnectivityResult> connectivityResult = await (Connectivity()
        .checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi)) {
      return true;
    }
    if (connectivityResult.contains(ConnectivityResult.none)) {
      return false;
    }

    return false;
  }
}
