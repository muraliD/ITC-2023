import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:itc_community/data/preferences.dart';
import 'package:itc_community/utils/config.dart';
import 'package:itc_community/utils/my_colors.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:itc_community/screens/home/menu_page.dart';
import 'dart:convert';
import 'package:itc_community/models/login_response.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Preferences.initSharedPreference();

    startTimer();
  }

  startTimer() {
    var duration = const Duration(
      seconds: 3,
    );
    return Timer(duration, checkConditions);
  }

  checkConditions() {



    var user = Preferences.getUserDetails();
    try{
      var decoded = json.decode(user!);
      final payload = UserL.fromJson(decoded);


        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
            MenuScreen()), (Route<dynamic> route) => false);



    }catch(err){
      navigateToLogin();

    }











    // if (Preferences.getAuthCode() != null &&
    //     Preferences.getAuthCode()!.isNotEmpty) {
    //   if (Preferences.getRoleID() == "4") {
    //     navigateToUserHome();
    //   } else if (Preferences.getRoleID() == "3") {
    //     navigateToVendorHome();
    //   }
    // } else {
    //   navigateToLogin();
    // }
  }

  void navigateToLogin() {
    Navigator.of(context).pushReplacementNamed(
      Config.loginRouteName,
    );
  }

  void navigateToVendorHome() {
    Navigator.of(context).pushReplacementNamed(
      Config.vendorHomeRouteName,
    );
  }

  void navigateToUserHome() {
    Navigator.of(context).pushReplacementNamed(
      Config.userHomeRouteName,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: HexColor(MyColors.colorLogin),
        body: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Center(
            child: Image.asset("assets/images/itc_logo.png"),
          ),
        ),
      ),
    );
  }
}
