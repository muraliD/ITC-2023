// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:itc_community/data/preferences.dart';
import 'package:itc_community/utils/config.dart';
import 'package:itc_community/utils/util_class.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../utils/my_colors.dart';
import 'package:itc_community/services//repository.dart';
import 'package:itc_community/models/registration_response.dart';

class ForgotScreen extends StatefulWidget {
  const ForgotScreen({Key? key}) : super(key: key);

  @override
  _ForgotScreen createState() => _ForgotScreen();
}

class _ForgotScreen extends State<ForgotScreen> {
  var username;
  TextEditingController userController = TextEditingController();

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
    final isValid = _formKey.currentState?.validate();
    if (isValid == false) {
      return;
    }

    _formKey.currentState?.save();

    callLoginAPI();
  }

  resetForm() {
    setState(() {
      userController.text = "";
    });
  }

  void callLoginAPI() async {
    var internet = await UtilClass.checkInternet();
    if (internet) {
      UtilClass.showProgress(context: context);
      await Repository.forgot(
        username: userController.text.toString().trim(),
      ).then((value) {
        RegistrationResponse response = value;
        UtilClass.hideProgress(context: context);

        if ((response.status!.type == "Success") ||
            (response.status!.type == "pending")) {
          UtilClass.showAlertDialog(
              context: context,
              message: response.status!.message ?? "Server Error",
              onOkClick: (() => {resetForm()}));
        } else {
          UtilClass.showAlertDialog(
              context: context,
              message: response.status!.message ?? "Server Error");
        }
      });
    } else {
      UtilClass.showAlertDialog(context: context, message: Config.kNoInternet);
    }
  }

  void resetState() {
    username = "";
    isLoading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Forgot Password"),
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
                    controller: userController,
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

                      if (value?.isEmpty == true) {
                        return 'Enter a valid username!';
                      }

                      return null;
                    },
                  ),

                  //box styling
                  SizedBox(
                    height: 30,
                  ),

                  ElevatedButton(
                    onPressed: () => _submit(),
                    child: const Text(Config.send),
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
}
