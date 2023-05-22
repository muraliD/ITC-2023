// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

import 'package:itc_community/data/preferences.dart';

import 'package:itc_community/utils/config.dart';
import 'package:itc_community/utils/util_class.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:itc_community/utils/my_colors.dart';
import 'package:itc_community/screens/home/menu_page.dart';
import 'package:itc_community/services//repository.dart';
import 'package:itc_community/models/login_response.dart';
import 'package:itc_community/models/changePassword_response.dart';
import 'dart:convert';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  _ChangePasswordScreen createState() => _ChangePasswordScreen();
}

class _ChangePasswordScreen extends State<ChangePasswordScreen> {

  var opassword, npassword, cnpassword;
  bool passenable = true;
  bool passenablen = true;
  bool passenablecn = true;
  TextEditingController oldPassController = TextEditingController(text: '');
  TextEditingController newPassController = TextEditingController(text: '');
  TextEditingController cNewpassController = TextEditingController(text: '');

  //  _formKey and _autoValidate
  var _formKey = GlobalKey<FormState>();
  var isLoading = false;
  late String userId;

  @override
  void initState() {
    super.initState();
    Preferences.initSharedPreference();
    var user = Preferences.getUserDetails();
    var decoded = json.decode(user!);
    final payload = UserL.fromJson(decoded);
    userId = (payload.id).toString();
  }

  void navigateToRegister(){


    Navigator.of(context).pushNamed(
      Config.registrationRouteName,
    );


  }
  void navigateToForgot(){


    Navigator.of(context).pushNamed(
      Config.forgotRouteName,
    );


  }
  void navigateToViewMem(){


    Navigator.of(context).pushNamed(
      Config.viewMemRouteName,
    );


  }
  void _submit() {
    final isValid = _formKey.currentState?.validate();
    if (isValid == false) {
      return;
    }


    _formKey.currentState?.save();


     callChangePwdAPI();



  }

  void callChangePwdAPI() async {
    var internet = await UtilClass.checkInternet();
    if (internet) {
      UtilClass.showProgress(context: context);
      await Repository.changePassword(userid: userId, password: oldPassController.text, newPassword: newPassController.text, cNewpassword: cNewpassController.text).then((value) {

        ChangePassword response = value;
        UtilClass.hideProgress(context: context);

        if(response.status!.type == "Success"){

          var message  = response?.data?.message ?? "Password Changed Successfully";
          UtilClass.showAlertDialog(
            context: context,
            message: message,
          );
        }else{

          var message  = response?.data?.message ?? "Server Error";
          UtilClass.showAlertDialog(
            context: context,
            message: message,
          );

        }


        // if (value == Config.emailPasswordInvalid) {
        //   UtilClass.showAlertDialog(
        //     context: context,
        //     message: Config.emailPasswordInvalid,
        //   );
        // } else {
        //
        // }
      });
    } else {

      UtilClass.showAlertDialog(context: context, message: Config.kNoInternet);
    }
  }

  void resetState() {

    opassword = "";
    npassword = "";
    cnpassword = "";

    isLoading = false;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Change Password"),
      ),
      backgroundColor: HexColor(MyColors.colorLogin),
      body: SingleChildScrollView(
        child: Container(

          margin: const EdgeInsets.only(left: 10.0, right: 10.0, top: 20.0),
          padding: const EdgeInsets.all(10),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[


                SizedBox(
                  height: 5,
                ),

                //text input
                TextFormField(
                  obscureText: passenable,
                  textAlignVertical: TextAlignVertical.center,
                  controller: oldPassController,
                  decoration: InputDecoration(
                      isDense: true,
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
                        Icons.lock,
                        color: Color(0xFF666666),
                        size: 18,
                      ),
                      fillColor: const Color(0xFFF2F3F5),
                      hintStyle: TextStyle(
                        color: const Color(0xFF666666),
                        fontFamily: Config.fontFamilyPoppinsMedium,
                      ),
                      hintText: "Old Password",
                      suffixIcon: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                        child: GestureDetector(
                          onTap: (){ //add Icon button at end of TextField
                            setState(() { //refresh UI
                              if(passenable){ //if passenable == true, make it false
                                passenable = false;
                              }else{
                                passenable = true; //if passenable == false, make it true
                              }
                            });
                          },
                          child: Icon(
                            passenable
                                ? Icons.visibility_off_rounded
                                : Icons.visibility_rounded,
                            size: 24,
                          ),
                        ),
                      )
                    // suffix: IconButton( splashRadius: 24.0, constraints: BoxConstraints(maxHeight: 10),iconSize: 20.0,onPressed: (){ //add Icon button at end of TextField
                    //   setState(() { //refresh UI
                    //     if(passenable){ //if passenable == true, make it false
                    //       passenable = false;
                    //     }else{
                    //       passenable = true; //if passenable == false, make it true
                    //     }
                    //   });
                    // }, icon: Icon(passenable == true?Icons.remove_red_eye:Icons.password))
                  ),
                  keyboardType: TextInputType.visiblePassword,
                  onFieldSubmitted: (value) {
                    //Validator
                  },
                  validator: (value) {
                    int? length = value?.length;

                    if (value?.isEmpty == true ) {
                      return 'Enter a valid password!';
                    }
                    if (length! < 6) {
                      return 'Password Should be minimum six characters ';
                    }
                    opassword = value;
                    return null;
                  },
                ),

                //box styling
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  obscureText: passenablen,
                  textAlignVertical: TextAlignVertical.center,
                  controller: newPassController,
                  decoration: InputDecoration(
                      isDense: true,
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
                        Icons.lock,
                        color: Color(0xFF666666),
                        size: 18,
                      ),
                      fillColor: const Color(0xFFF2F3F5),
                      hintStyle: TextStyle(
                        color: const Color(0xFF666666),
                        fontFamily: Config.fontFamilyPoppinsMedium,
                      ),
                      hintText: "New Password",
                      suffixIcon: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                        child: GestureDetector(
                          onTap: (){ //add Icon button at end of TextField
                            setState(() { //refresh UI
                              if(passenablen){ //if passenable == true, make it false
                                passenablen = false;
                              }else{
                                passenablen = true; //if passenable == false, make it true
                              }
                            });
                          },
                          child: Icon(
                            passenablen
                                ? Icons.visibility_off_rounded
                                : Icons.visibility_rounded,
                            size: 24,
                          ),
                        ),
                      )
                    // suffix: IconButton( splashRadius: 24.0, constraints: BoxConstraints(maxHeight: 10),iconSize: 20.0,onPressed: (){ //add Icon button at end of TextField
                    //   setState(() { //refresh UI
                    //     if(passenable){ //if passenable == true, make it false
                    //       passenable = false;
                    //     }else{
                    //       passenable = true; //if passenable == false, make it true
                    //     }
                    //   });
                    // }, icon: Icon(passenable == true?Icons.remove_red_eye:Icons.password))
                  ),
                  keyboardType: TextInputType.visiblePassword,
                  onFieldSubmitted: (value) {
                    //Validator
                  },
                  validator: (value) {
                    int? length = value?.length;
                    if (value?.isEmpty == true ) {
                      return 'Enter a valid password!';
                    }
                    if (length! < 6) {
                      return 'Password Should be minimum six characters ';
                    }
                    npassword = value;
                    return null;
                  },
                ),




                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  obscureText: passenablecn,
                  textAlignVertical: TextAlignVertical.center,
                  controller: cNewpassController,
                  decoration: InputDecoration(
                      isDense: true,
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
                        Icons.lock,
                        color: Color(0xFF666666),
                        size: 18,
                      ),
                      fillColor: const Color(0xFFF2F3F5),
                      hintStyle: TextStyle(
                        color: const Color(0xFF666666),
                        fontFamily: Config.fontFamilyPoppinsMedium,
                      ),
                      hintText: "Confirm New Password",
                      suffixIcon: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                        child: GestureDetector(
                          onTap: (){ //add Icon button at end of TextField
                            setState(() { //refresh UI
                              if(passenablecn){ //if passenable == true, make it false
                                passenablecn = false;
                              }else{
                                passenablecn = true; //if passenable == false, make it true
                              }
                            });
                          },
                          child: Icon(
                            passenablecn
                                ? Icons.visibility_off_rounded
                                : Icons.visibility_rounded,
                            size: 24,
                          ),
                        ),
                      )
                    // suffix: IconButton( splashRadius: 24.0, constraints: BoxConstraints(maxHeight: 10),iconSize: 20.0,onPressed: (){ //add Icon button at end of TextField
                    //   setState(() { //refresh UI
                    //     if(passenable){ //if passenable == true, make it false
                    //       passenable = false;
                    //     }else{
                    //       passenable = true; //if passenable == false, make it true
                    //     }
                    //   });
                    // }, icon: Icon(passenable == true?Icons.remove_red_eye:Icons.password))
                  ),
                  keyboardType: TextInputType.visiblePassword,
                  onFieldSubmitted: (value) {
                    //Validator
                  },
                  validator: (value) {
                    int? length = value?.length;
                    if (value?.isEmpty == true ) {
                      return 'Enter a valid password!';
                    }
                    if (length! < 6) {
                      return 'Password Should be minimum six characters ';
                    }
                    if(newPassController.text != cNewpassController.text){
                      return 'New and confirm new  passwords should be same';

                    }
                    cnpassword = value;
                    return null;
                  },
                ),

                SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  onPressed: () => _submit(),
                  child: const Text("Change Password"),
                  style: ElevatedButton.styleFrom(
                      shadowColor: Colors.grey,
                      elevation: 3,
                      shape: const BeveledRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(2.5))),
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



  // buildForgotPasswordReset() {
  //   return Container(
  //     margin: const EdgeInsets.symmetric(horizontal: 10),
  //     alignment: Alignment.centerRight,
  //     child: Text(
  //       Config.forgotPassword,
  //       style: TextStyle(
  //         color: Colors.grey,
  //         fontSize: 14,
  //         fontWeight: FontWeight.normal,
  //         fontFamily: Config.fontFamilyPoppinsMedium,
  //       ),
  //     ),
  //   );
  // }

  buildForgotPasswordReset(){
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: InkWell(
          onTap: () => navigateToForgot(),
          child: Text(
            Config.forgotPassword,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
              fontFamily: Config.fontFamilyPoppinsRegular,
              fontWeight: FontWeight.w200,
            ),
          ),
        ),
      ),
    );

  }

  ElevatedButton buildLoginButton() {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>MenuScreen()));
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

        onPressed: () {navigateToViewMem();},
        icon: Icon( // <-- Icon
          color: Colors.white,
          Icons.camera_front_outlined,
          size: 24.0,
        ),
        label: Text('View Any Member',style: TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontFamily: Config.fontFamilyPoppinsRegular,
          fontWeight: FontWeight.w200,
        ),), // <-- Text
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
  notMember(){
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
