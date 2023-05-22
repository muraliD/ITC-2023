import 'dart:ffi';
import 'dart:math';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:itc_community/utils/my_colors.dart';
import 'package:hexcolor/hexcolor.dart';

import 'package:itc_community/models/dashboard_response.dart';
import "package:itc_community/models/price_response.dart";

import 'package:itc_community/utils/config.dart';
import 'package:itc_community/utils/util_class.dart';
import 'package:itc_community/services//repository.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/services.dart';
import 'package:itc_community/data/preferences.dart';
import 'package:itc_community/models/userCheck_response.dart';
import 'package:itc_community/models/login_response.dart';
import 'package:itc_community/models/withdraw_response.dart';
import 'package:itc_community/screens/home/fragments/changePassword_page.dart';
import 'package:itc_community/screens/home/fragments/loginHistory_page.dart';
import 'package:itc_community/screens/home/fragments/referals_page.dart';
import 'package:itc_community/screens/home/fragments/referralsQr_page.dart';

class ProfileFragment extends StatefulWidget {
  const ProfileFragment({Key? key}) : super(key: key);

  @override
  State<ProfileFragment> createState() => _WithdrawsFragmentState();
}

class _WithdrawsFragmentState extends State<ProfileFragment> {
  DashboardResponse? dashboardData;
  PriceResponse? priceData;
  UserL? userdatas;

  TextEditingController addressController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  //  _formKey and _autoValidate
  var _formKey = GlobalKey<FormState>();
  var isLoading = false;
  var agree = false;
  String selectedValue = "Select1";
  String selectedValue1 = "Select2";
  String _selectedText = "SSD";
  String selectedtype = "1";

  late String userCheck = "Please Enter the  valid user ";
  late String amountCheck = "";
  late bool userError = true;
  late bool amountError = false;
  late String userId;
  late String password;
  late String name;
  late String plan;
  late String email;
  late String contact;
  late String profilepic;
  late bool isload = false;

  List<DropdownMenuItem<String>> menuItems = [
    DropdownMenuItem(child: Text("Select Withdraw Type"), value: "Select1"),
    DropdownMenuItem(child: Text("Self"), value: "Self1"),
    DropdownMenuItem(child: Text("External"), value: "External1"),
    DropdownMenuItem(child: Text("Internal"), value: "Internal1")
  ];

  List<DropdownMenuItem<String>> walletItems = [
    DropdownMenuItem(
        child: Text("Select From And To wallet"), value: "Select2"),
  ];

  dropdownItemsWallets() {

    selectedValue1 = "Select2";
    walletItems = [];
    if (selectedValue == "Self1") {
      walletItems = [
        DropdownMenuItem(child: Text("Select"), value: "Select2"),
        DropdownMenuItem(child: Text("Bonus Wallet to E-Wallet"), value: "BEW"),
        DropdownMenuItem(child: Text("E-Wallet to Game Wallet"), value: "EG"),
      ];
    } else if (selectedValue == "Internal1") {
      walletItems = [
        DropdownMenuItem(
            child: Text("Select From And To wallet"), value: "Select2"),
        DropdownMenuItem(child: Text("E-Wallet to E-Wallet"), value: "EE"),
        DropdownMenuItem(
            child: Text("Game Wallet to Game Wallet"), value: "GG"),
      ];
    } else if (selectedValue == "External1") {
      walletItems = [
        DropdownMenuItem(
            child: Text("Select From And To wallet"), value: "Select2"),
        DropdownMenuItem(
            child: Text(
                "Bonus Wallet to External Wallet (TRON / ITC Wallet Address only)"),
            value: "BE"),
      ];
    } else {
      walletItems = [
        DropdownMenuItem(
            child: Text("Select From And To wallet"), value: "Select2")
      ];
    }
  }

  String priceValue = "";
  List<Map<String, dynamic>> gridData = [
    {
      'color': [Colors.indigoAccent, Colors.indigo],
      "amount": "",
      'title': "E-Wallet",
      'subtitle': "Deposits & Internal Transfers",
      "type": "amount"
    },
    {
      'color': [Colors.teal, Colors.tealAccent],
      "amount": "",
      'title': "Bonus Wallet",
      'subtitle': "Level, LTG & Other earnings",
      "type": "amount"
    },
    {
      'color': [Colors.orangeAccent, Colors.orange],
      "amount": "",
      'title': "Upgrade Credits",
      'subtitle': "Used to upgrade Ranks",
      "type": "amount"
    },
    {
      'color': [Colors.indigo, Colors.indigoAccent],
      "amount": "",
      'title': "Arch Coins",
      'subtitle': "Free Air Drop",
      "type": "amount"
    },
    {
      'color': [Colors.green, Colors.greenAccent],
      "amount": "",
      'title': "Game Wallet",
      'subtitle': "Play Games",
      "type": "amount"
    },
    {
      'color': [Colors.pinkAccent, Colors.pink],
      "amount": "",
      'title': "Win Wallet",
      'subtitle': "Won on Games",
      "type": "amount"
    }
  ];

  iconByName(name) {
    if (name == "Total Bonus") {
      return Icon(size: 50.0, Icons.account_balance, color: Colors.white);
    } else if (name == "E-Wallet") {
      return Icon(
          size: 50.0, Icons.account_balance_wallet, color: Colors.white);
    } else if (name == "Bonus Wallet") {
      return Icon(size: 50.0, Icons.add_business, color: Colors.white);
    } else if (name == "Upgrade Credits") {
      return Icon(size: 50.0, Icons.wallet_travel, color: Colors.white);
    } else if (name == "Arch Coins") {
      return Icon(size: 50.0, Icons.card_giftcard, color: Colors.white);
    } else if (name == "Game Wallet") {
      return Icon(size: 50.0, Icons.videogame_asset, color: Colors.white);
    } else if (name == "Win Wallet") {
      return Icon(size: 50.0, Icons.price_change_outlined, color: Colors.white);
    } else if (name == "ITC CONNECT") {
      return Icon(size: 50.0, Icons.self_improvement, color: Colors.white);
    }

    return Icon(size: 50.0, Icons.abc_rounded, color: Colors.cyan);
  }

  @override
  void initState() {
    var user = Preferences.getUserDetails();
    var decoded = json.decode(user!);
    userdatas = UserL.fromJson(decoded);
    userId = (userdatas?.id).toString();
    password = (userdatas?.password).toString();
    name = (userdatas?.name).toString();
    plan = (userdatas?.plan_name).toString();

    email = (userdatas?.email).toString();
    contact = (userdatas?.mobile).toString();
    profilepic = (userdatas?.profilePic).toString();
    _callProdutDetailsAPI(userId);
    super.initState();
  }

  _callProdutDetailsAPI(String id) async {
    var internet = await UtilClass.checkInternet();
    if (internet) {
      UtilClass.showProgress(context: context);
      await Future.wait([
        Repository.getDashboardData(userid: userId),
      ]).then((value) {
        UtilClass.hideProgress(context: context);

        dashboardData = value[0];

        Preferences.setReferralLink(json.encode(dashboardData?.data?.user?.referralCode) );






        setState(() {});
      }, onError: (err) {
        UtilClass.showAlertDialog(context: context, message: err.toString());
      });
    } else {
      UtilClass.showAlertDialog(context: context, message: Config.kNoInternet);
    }
  }

  _userCheckAPIs(String name) async {}
  void _submit() {
    // final isValid = _formKey.currentState?.validate();
    // if (isValid == false) {
    //   return;
    // }
    // _formKey.currentState?.save();
  }

  dynamic getType(type) {
    var amountE = RegExp(r'^[0-9]+$').hasMatch(amountCheck);

    if (type == 1 || type == 2) {
      if (amountE == false) {
        return false;
      }
      return true;
    } else  if (type == 3 || type == 4) {
      if ((amountE == true) && (userError == false)) {
        return true;
      } else {
        return false;
      }
    }else{
      if((amountE == true) && (addressController.text.length>=0)){
        return true;
      }else{
        return false;
      }


    }
  }

  void navigateToReferal(){


    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ReferralsQRFragment()));



  }
  void navigateToHistory(){


    Navigator.of(context).push(MaterialPageRoute(builder: (context) => HistoryFragment()));



  }
  void navigateToChangePassword(){
    debugPrint("murakiii");

    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChangePasswordScreen()));



  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor(MyColors.colorLogin),
      body: Container(
        color: Colors.transparent,
        child: SingleChildScrollView(
          child: Column(
            children: [

              Container(
                height: 220,
                width: MediaQuery.of(context).size.width,
                padding:
                const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                child: Card(
                  margin: const EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  elevation: 5,
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          //<-- SEE HERE
                          color: Colors.greenAccent,
                          blurRadius: 10.0,
                        ),
                      ],
                      gradient: LinearGradient(colors: [
                        HexColor(MyColors.colorLogin),
                        HexColor(MyColors.colorLogin).withOpacity(0.7),


                    
                        HexColor(MyColors.colorLogin)
                      ]),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical:8.0 ,horizontal: 8.0),
                                child: CircleAvatar(
                                  radius: 45,
                                  backgroundColor: Colors.grey.shade200,
                                  child: CircleAvatar(
                                    radius: 40,
                                    backgroundImage: NetworkImage(profilepic),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 1,
                                right: 1,
                                child: Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Icon(Icons.add_a_photo, color: Colors.black),
                                  ),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 3,
                                        color: Colors.white,
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(
                                          50,
                                        ),
                                      ),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          offset: Offset(2, 4),
                                          color: Colors.black.withOpacity(
                                            0.3,
                                          ),
                                          blurRadius: 3,
                                        ),
                                      ]),
                                ),
                              ),

                            ],
                          ),

                          Container(

                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical:6.0 ,horizontal: 8.0),
                              child: Text(
                                name,
                                style: TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                          Container(

                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical:2.0 ,horizontal: 8.0),
                              child: Text(
                               plan,
                                style: TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                          Container(

                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical:2.0 ,horizontal: 8.0),
                              child: Text(
                                "ITC " + userId ,
                                style: TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white),
                              ),
                            ),
                          ),





                        ],
                      ),
                    ),
                  ),
                ),
              ),

              Container(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                  child: Text(
                    textAlign: TextAlign.left,
                    "Contact Details ",
                    style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.normal,
                        color: Colors.white),
                  ),
                ),
              ),

              Container(
                margin:
                const EdgeInsets.only(left: 10.0, right: 10.0, top: 2.0),
                padding:
                const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                child: InkWell(
                  splashColor: Colors.blue.withAlpha(30),
                  onTap: () {
                    // showInformationDialog(context, 1);
                  },
                  child: Card(
                    margin: const EdgeInsets.all(2),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    elevation: 5,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [HexColor(MyColors.white), Colors.white]),
                      ),
                      child: ListTile(
                        leading: Icon(Icons.email,color: HexColor(MyColors.colorLogin)),
                        title: Text(
                          email,
                          style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),

                      ),
                    ),
                  ),
                ),
              ),
              Container(
                margin:
                const EdgeInsets.only(left: 10.0, right: 10.0, top: 2.0),
                padding:
                const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                child: InkWell(
                  splashColor: Colors.blue.withAlpha(30),
                  onTap: () {
                    // showInformationDialog(context, 1);
                  },
                  child: Card(
                    margin: const EdgeInsets.all(2),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    elevation: 5,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [HexColor(MyColors.white), Colors.white]),
                      ),
                      child: ListTile(
                        leading: Icon(Icons.phone,color: HexColor(MyColors.colorLogin)),
                        title: Text(
                          contact,
                          style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),

                      ),
                    ),
                  ),
                ),
              ),

              Container(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                  child: Text(
                    textAlign: TextAlign.left,
                    "Referrals ",
                    style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.normal,
                        color: Colors.white),
                  ),
                ),
              ),
              Container(
                margin:
                const EdgeInsets.only(left: 10.0, right: 10.0, top: 2.0),
                padding:
                const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                child: InkWell(
                  onTap: () {
                    navigateToReferal();
                  },
                  child: Card(
                    margin: const EdgeInsets.all(2),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    elevation: 5,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [HexColor(MyColors.white), Colors.white]),
                      ),
                      child: ListTile(
                        leading: Icon(Icons.transcribe_outlined,color: HexColor(MyColors.colorLogin)),
                        title: Text(
                          'Referral Link',
                          style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                              color: HexColor(MyColors.colorLogin)),
                        ),
                        trailing: Icon(Icons.arrow_forward_ios_sharp,color: HexColor(MyColors.colorLogin)),
                      ),
                    ),
                  ),
                ),
              ),
              // Container(
              //   margin:
              //   const EdgeInsets.only(left: 10.0, right: 10.0, top: 2.0),
              //   padding:
              //   const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
              //   child: InkWell(
              //     onTap: () {
              //       navigateToHistory();
              //     },
              //     child: Card(
              //       margin: const EdgeInsets.all(2),
              //       shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(10)),
              //       clipBehavior: Clip.antiAliasWithSaveLayer,
              //       elevation: 5,
              //       child: Container(
              //         decoration: BoxDecoration(
              //           gradient: LinearGradient(
              //               colors: [HexColor(MyColors.white), Colors.white]),
              //         ),
              //         child: ListTile(
              //           leading: Icon(Icons.history,color: HexColor(MyColors.colorLogin)),
              //           title: Text(
              //             'Login History',
              //             style: TextStyle(
              //                 fontSize: 12.0,
              //                 fontWeight: FontWeight.bold,
              //                 color: HexColor(MyColors.colorLogin)),
              //           ),
              //           trailing: Icon(Icons.arrow_forward_ios_sharp,color: HexColor(MyColors.colorLogin)),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              Container(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                  child: Text(
                    textAlign: TextAlign.left,
                    "Settings ",
                    style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.normal,
                        color: Colors.white),
                  ),
                ),
              ),
              Container(
                margin:
                const EdgeInsets.only(left: 10.0, right: 10.0, top: 2.0),
                padding:
                const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                child: InkWell(
                  onTap: () {
                    navigateToChangePassword();
                  },
                  child: Card(
                    margin: const EdgeInsets.all(2),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    elevation: 5,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [HexColor(MyColors.white), Colors.white]),
                      ),
                      child: ListTile(
                        leading: Icon(Icons.password,color: HexColor(MyColors.colorLogin)),
                        title: Text(
                          'Change Password',
                          style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                              color: HexColor(MyColors.colorLogin)),
                        ),
                        trailing: Icon(Icons.arrow_forward_ios_sharp,color: HexColor(MyColors.colorLogin)),
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20)
            ],
          ),
        ),
      ),
    );
  }
}
