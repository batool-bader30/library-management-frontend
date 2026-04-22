import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class NetworkInfo {
  static Future<bool> get isConnected async {
    return await InternetConnection().hasInternetAccess;
  }
  static Stream<InternetStatus> get onStatusChange => 
      InternetConnection().onStatusChange;
}