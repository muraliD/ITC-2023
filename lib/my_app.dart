import 'package:flutter/material.dart';
import 'package:itc_community/screens/authentication/fogot_page.dart';
import 'package:itc_community/screens/splash/splash_screen.dart';
import 'package:itc_community/utils/my_colors.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:itc_community/utils/config.dart';
import 'package:itc_community/screens/authentication/login_page.dart';
import 'package:itc_community/screens/authentication/registration_page.dart';
import 'package:itc_community/screens/authentication/viewmember_page.dart';
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyApp createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: Config.appName,
      initialRoute: Config.splashRouteName,
      theme: ThemeData(
        primaryColor: HexColor(MyColors.colorPrimary),
        backgroundColor: HexColor(MyColors.colorPrimary),
        fontFamily: Config.fontFamilyPoppinsRegular,
        appBarTheme: AppBarTheme(
          backgroundColor: HexColor(MyColors.navColor),
        ),
      ),
      routes: {

        Config.splashRouteName: (ctx) => const SplashScreen(),
        Config.loginRouteName: (ctx) => const LoginScreen(),
        Config.registrationRouteName: (ctx) => const Registration(),
        Config.forgotRouteName: (ctx) => const ForgotScreen(),
        Config.viewMemRouteName: (ctx) => const ViewMemberScreen()


      },
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );
      },
    );
  }

  // rajesh changes
}
