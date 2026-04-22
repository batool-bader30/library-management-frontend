import 'package:flutter/material.dart';

import '../../core/utils/navigator_utils.dart';
import '../../core/utils/network_connection.dart';

class SplashScreen extends StatefulWidget {
  final bool isLoggedIn;
  const SplashScreen({super.key, required this.isLoggedIn});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    startSplash();
  }

  ///  هاي الدالة مسؤولة عن الفحص والتنقّل
  void startSplash() async {
    //  نتحقق من الاتصال بالإنترنت
    bool isConnected = await ConnectionsNetwork.isConnected();

    //  ننتظر 3 ثواني لعرض السبلاتش
    await Future.delayed(const Duration(seconds: 3));

    if (!isConnected) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("No internet connection")));
      return;
    } else if (widget.isLoggedIn) {
      NavigatorUtils.navigateToHomeScreen(context);}
      else{
              NavigatorUtils.navigateToLogInScreen(context);}

      }
      
      
  

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SizedBox.expand(
        child: Image(
          image: AssetImage("assets/images/splash.png"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

}