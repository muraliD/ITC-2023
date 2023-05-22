// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

import 'package:itc_community/data/preferences.dart';

import 'package:itc_community/utils/config.dart';
import 'package:itc_community/utils/util_class.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../utils/my_colors.dart';
import 'package:itc_community/screens/home/menu_page.dart';
import 'package:itc_community/services//repository.dart';
import 'package:itc_community/models/login_response.dart';
import 'dart:convert';

class ViewMemberScreen extends StatefulWidget {
  const ViewMemberScreen({Key? key}) : super(key: key);

  @override
  _ViewMemberScreen createState() => _ViewMemberScreen();
}

class _ViewMemberScreen extends State<ViewMemberScreen> {
  var username, password;
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  //  _formKey and _autoValidate
  var _formKey = GlobalKey<FormState>();
  var isLoading = false;

  @override
  void initState() {
    super.initState();
    Preferences.initSharedPreference();
  }

  void navigateToRegister() {
    debugPrint("murakiii");

    Navigator.of(context).pushNamed(
      Config.registrationRouteName,
    );
  }

  void _submit() {
    // final isValid = _formKey.currentState?.validate();
    // if (isValid == false) {
    //   return;
    // }
    //
    //
    // _formKey.currentState?.save();
    //
    // debugPrint(username);
    // debugPrint(password);
    // callLoginAPI();
  }
  void callLoginAPI() async {
    var internet = await UtilClass.checkInternet();
    if (internet) {
      UtilClass.showProgress(context: context);
      await Repository.getLogin(
        email: emailController.text.toString().trim(),
        password: passController.text.toString().trim(),
      ).then((value) {
        LoginResponse response = value;
        UtilClass.hideProgress(context: context);

        if (response.status!.type == "Success") {
          Preferences.setUserDetails(json.encode(response.data!.user));

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => MenuScreen(),
            ),
          );
        } else {
          UtilClass.showAlertDialog(
            context: context,
            message: Config.emailPasswordInvalid,
          );
        }
      });
    } else {
      UtilClass.showAlertDialog(context: context, message: Config.kNoInternet);
    }
  }

  void resetState() {
    username = "";
    password = "";

    isLoading = false;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Member Details"),
      ),
      backgroundColor: HexColor(MyColors.colorLogin),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
          padding: const EdgeInsets.all(10),
          child: Container(
            margin: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
            padding: const EdgeInsets.all(10),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  buildLogo(),
                  //styling
                  SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        borderSide: BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                      filled: true,
                      prefixIcon: const Icon(
                        Icons.email,
                        color: Color(0xFF666666),
                        size: 15,
                      ),
                      fillColor: const Color(0xFFF2F3F5),
                      hintStyle: TextStyle(
                        color: const Color(0xFF666666),
                        fontFamily: Config.fontFamilyPoppinsMedium,
                      ),
                      hintText: Config.enterEmailPhoneNumber,
                    ),
                    keyboardType: TextInputType.emailAddress,
                    onFieldSubmitted: (value) {
                      //Validator
                    },
                    validator: (value) {
                      username = value;

                      final bool emailValid = RegExp(
                              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                          .hasMatch(username);

                      if (value?.isEmpty == true) {
                        return 'Enter a valid email!';
                      }
                      // if (!emailValid ) {
                      //
                      //   return 'Enter a valid email!';
                      // }

                      return null;
                    },
                  ),

                  //box styling
                  SizedBox(
                    height: 30,
                  ),

                  ElevatedButton(
                    onPressed: () => _submit(),
                    child: const Text(Config.views),
                    style: ElevatedButton.styleFrom(
                        shadowColor: Colors.grey,
                        elevation: 3,
                        shape: const BeveledRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(2.5))),
                        minimumSize: const Size(double.infinity, 45)),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  buildLogo() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      alignment: Alignment.topCenter,
      child: Image.asset(
        "assets/images/itc_logo1.png",
        height: 100,
      ),
    );
  }

  buildHeading() {
    return Container(
      alignment: Alignment.center,
      transformAlignment: Alignment.bottomLeft,
      child: Text(
        "Login",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontFamily: Config.fontFamilyPoppinsBold,
          fontSize: 20,
        ),
      ),
    );
  }

  buildLoginText() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      alignment: Alignment.centerLeft,
      child: InkWell(
        // onTap: () => navigateToSignUpLogin(),
        child: Text(
          Config.createNew,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontFamily: Config.fontFamilyPoppinsRegular,
          ),
        ),
      ),
    );
  }

  buildEmailEditText() {
    return TextField(
      controller: emailController,
      showCursor: true,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 15.0),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          borderSide: BorderSide(
            width: 0,
            style: BorderStyle.none,
          ),
        ),
        filled: true,
        prefixIcon: const Icon(
          Icons.mail_outline,
          color: Color(0xFF666666),
          size: 15,
        ),
        fillColor: const Color(0xFFF2F3F5),
        hintStyle: TextStyle(
          color: const Color(0xFF666666),
          fontFamily: Config.fontFamilyPoppinsMedium,
        ),
        hintText: Config.enterEmailPhoneNumber,
      ),
      keyboardType: TextInputType.emailAddress,
    );
  }

  buildPasswordEditText() {
    return TextField(
      controller: passController,
      showCursor: true,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 15.0),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          borderSide: BorderSide(
            width: 0,
            style: BorderStyle.none,
          ),
        ),
        filled: true,
        prefixIcon: const Icon(
          Icons.lock_outline,
          color: Color(0xFF666666),
          size: 16,
        ),
        suffixIcon: const Icon(
          Icons.remove_red_eye,
          color: Color(0xFF666666),
          size: 18,
        ),
        fillColor: const Color(0xFFF2F3F5),
        hintStyle: TextStyle(
          color: const Color(0xFF666666),
          fontFamily: Config.fontFamilyPoppinsMedium,
        ),
        hintText: Config.password,
      ),
      keyboardType: TextInputType.visiblePassword,
    );
  }

  buildForgotPasswordReset() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      alignment: Alignment.centerRight,
      child: Text(
        Config.forgotPassword,
        style: TextStyle(
          color: Colors.grey,
          fontSize: 14,
          fontWeight: FontWeight.normal,
          fontFamily: Config.fontFamilyPoppinsMedium,
        ),
      ),
    );
  }

  ElevatedButton buildLoginButton() {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MenuScreen()));
      },
      child: const Text(Config.login),
      style: ElevatedButton.styleFrom(
          shadowColor: Colors.grey,
          elevation: 3,
          shape: const BeveledRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(2.5))),
          minimumSize: const Size(double.infinity, 45)),
    );
  }

  SizedBox buildViewButton() {
    return SizedBox(
      height: 40,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          primary: HexColor(MyColors.colorYellow),
        ),

        onPressed: () {},
        icon: Icon(
          // <-- Icon
          color: Colors.white,
          Icons.camera_front_outlined,
          size: 24.0,
        ),
        label: Text(
          'View Any Member',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontFamily: Config.fontFamilyPoppinsRegular,
            fontWeight: FontWeight.w200,
          ),
        ), // <-- Text
      ),
    );
  }

  buildSkipNowText() {
    return InkWell(
      // onTap: () => navigateToVendorHome(),
      child: Text(
        Config.skipNow,
        style: TextStyle(
          color: Colors.grey,
          fontSize: 14,
          fontFamily: Config.fontFamilyPoppinsRegular,
          fontWeight: FontWeight.w200,
        ),
      ),
    );
  }

  notMember() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () => navigateToRegister(),
        child: Text(
          Config.register,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 14,
            fontFamily: Config.fontFamilyPoppinsRegular,
            fontWeight: FontWeight.w200,
          ),
        ),
      ),
    );
  }

  buildLoginViaOtpText() {
    return InkWell(
      // onTap: () => navigateToPhoneLogin(),
      child: Text(
        Config.loginViaOtp,
        style: TextStyle(
          color: Colors.cyan,
          fontSize: 14,
          fontFamily: Config.fontFamilyPoppinsMedium,
        ),
      ),
    );
  }
}
