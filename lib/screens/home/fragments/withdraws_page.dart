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
import 'package:flutter/services.dart';
import 'package:itc_community/data/preferences.dart';
import 'package:itc_community/models/userCheck_response.dart';
import 'package:itc_community/models/login_response.dart';
import 'package:itc_community/models/withdraw_response.dart';

class WithdrawsFragment extends StatefulWidget {
  const WithdrawsFragment({Key? key}) : super(key: key);

  @override
  State<WithdrawsFragment> createState() => _WithdrawsFragmentState();
}

class _WithdrawsFragmentState extends State<WithdrawsFragment> {
  DashboardResponse? dashboardData;
  PriceResponse? priceData;

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
  late bool isload = false;
  dynamic currentWalletAmountIndex = 0;

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
      "amount": "0.00",
      'title': "E-Wallet",
      'subtitle': "Deposits & Internal Transfers",
      "type": "amount"
    },
    {
      'color': [Colors.teal, Colors.tealAccent],
      "amount": "0.00",
      'title': "Bonus Wallet",
      'subtitle': "Level, LTG & Other earnings",
      "type": "amount"
    },
    {
      'color': [Colors.orangeAccent, Colors.orange],
      "amount": "0.00",
      'title': "Upgrade Credits",
      'subtitle': "Used to upgrade Ranks",
      "type": "amount"
    },
    {
      'color': [Colors.indigo, Colors.indigoAccent],
      "amount": "0.00",
      'title': "Arch Coins",
      'subtitle': "Free Air Drop",
      "type": "amount"
    },
    {
      'color': [Colors.green, Colors.greenAccent],
      "amount": "0.00",
      'title': "Game Wallet",
      'subtitle': "Play Games",
      "type": "amount"
    },
    {
      'color': [Colors.pinkAccent, Colors.pink],
      "amount": "0.00",
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
    final payload = UserL.fromJson(decoded);
    userId = (payload.id).toString();
    password = (payload.password).toString();

    _callProdutDetailsAPI(userId);
    super.initState();
  }

  _callProdutDetailsAPI(String id) async {
    var internet = await UtilClass.checkInternet();
    if (internet) {
      UtilClass.showProgress(context: context);
      await Future.wait([
        Repository.getDashboardData(userid: userId),
        Repository.getItcPriceApi()
      ]).then((value) {
        UtilClass.hideProgress(context: context);

        dashboardData = value[0];
        priceData = value[1];

        if (priceData?.status!.type == "Success") {
          String? dataPrice = priceData?.data?.tokenInfo?.value;
          dynamic data = dataPrice != null ? dataPrice : "0.00";
          dynamic currency = priceData?.data?.tokenInfo?.valueShownIn ?? "";
          double? tbonus = double.parse(data);
          priceValue = tbonus != null ? tbonus.toString() + " " + currency : "";
          setState(() {});
        } else {
          priceValue = "";
        }

        if (dashboardData?.status!.type == "Success") {
          final data = dashboardData?.data?.user;

          Wallets? walData = dashboardData?.data?.user?.wallets;

          TotalEarnings? earnings = dashboardData?.data?.user?.totalEarnings;

          double? tbonus = (earnings?.totalBonus).toDouble();
          String? ewallet = walData?.eWalletBalance;
          String? bwallet = walData?.bonusWalletBalance;
          String? upgradeCredits = walData?.upgradeCreditsWalletBalance;
          String? arcCoins = walData?.archCoinsWalletBalance;
          String? gameWallet = walData?.gameWalletBalance;
          String? winWallet = walData?.winWallet;

          var tbonusData = tbonus != null ? tbonus.toStringAsFixed(2) : "";
          var ewalletData =
              ewallet != null ? (double.parse(ewallet)).toStringAsFixed(2) : "";
          var bonusData =
              bwallet != null ? (double.parse(bwallet)).toStringAsFixed(2) : "";
          var upgradeData = upgradeCredits != null
              ? (double.parse(upgradeCredits)).toStringAsFixed(2)
              : "";
          var arcCoinsData = arcCoins != null
              ? (double.parse(arcCoins)).toStringAsFixed(2)
              : "";
          var gamewalletData = gameWallet != null
              ? (double.parse(gameWallet)).toStringAsFixed(2)
              : "";
          var winWalletData = winWallet != null
              ? (double.parse(winWallet)).toStringAsFixed(2)
              : "";

          AdditionalEarnings? additionalEarnins =
              dashboardData?.data?.user?.additionalEarnings;

          String? itcConnectEarnings = additionalEarnins?.itcconnectBalance;

          var itc = itcConnectEarnings != null
              ? (double.parse(itcConnectEarnings)).toStringAsFixed(2)
              : "";

          String? referalCode = data?.referralCode;

          var referal = referalCode != null ? referalCode : "";

          Deposits? deposits = dashboardData?.data?.user?.deposits;
          String? deposit = deposits?.walletAddress;
          var depositData = deposit != null ? deposit : "";

          gridData = [
            {
              'color': [Colors.indigoAccent, Colors.indigo],
              "amount": ewalletData,
              'title': "E-Wallet",
              'subtitle': "Deposits & Internal Transfers",
              "type": "amount"
            },
            {
              'color': [Colors.teal, Colors.tealAccent],
              "amount": bonusData,
              'title': "Bonus Wallet",
              'subtitle': "Level, LTG & Other earnings",
              "type": "amount"
            },
            {
              'color': [Colors.orangeAccent, Colors.orange],
              "amount": upgradeData,
              'title': "Upgrade Credits",
              'subtitle': "Used to upgrade Ranks",
              "type": "amount"
            },
            {
              'color': [Colors.indigo, Colors.indigoAccent],
              "amount": arcCoinsData,
              'title': "Arch Coins",
              'subtitle': "Free Air Drop",
              "type": "amount"
            },
            {
              'color': [Colors.green, Colors.greenAccent],
              "amount": gamewalletData,
              'title': "Game Wallet",
              'subtitle': "Play Games",
              "type": "amount"
            },
            {
              'color': [Colors.pinkAccent, Colors.pink],
              "amount": winWalletData,
              'title': "Win Wallet",
              'subtitle': "Won on Games",
              "type": "amount"
            }
          ];

          setState(() {});
        }
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
    } else if (type == 3 || type == 4) {
      if ((amountE == true) && (userError == false)) {
        return true;
      } else {
        return false;
      }
    } else {
      if ((amountE == true) && (addressController.text.length >= 0)) {
        return true;
      } else {
        return false;
      }
    }
  }

  Future<void> showInformationDialog(BuildContext context, int type) async {
    String titleVal = "";
    String userInputtxt = "User Details";
    bool ismultiple = false;

    if (type == 1) {
      currentWalletAmountIndex = 1;
      titleVal = "Bonus Wallet to E-Wallet";
    }
    if (type == 2) {
      titleVal = "E-Wallet to Game Wallet";
      currentWalletAmountIndex = 0;
    }
    if (type == 3) {
      titleVal = "E-Wallet to E-Wallet";
      currentWalletAmountIndex = 0;
      ismultiple = true;
    }
    if (type == 4) {
      currentWalletAmountIndex = 4;
      titleVal = "Game Wallet to Game Wallet";
      ismultiple = true;
    }
    if (type == 5) {
      currentWalletAmountIndex = 1;
      titleVal =
          "Bonus Wallet to External Wallet (TRON / ITC Wallet Address only)";
      userInputtxt = "TRON / ITC Wallet Address";
      ismultiple = true;
    }

    return await showDialog(
        context: context,
        builder: (context) {
          bool isChecked = false;
          return StatefulBuilder(builder: (context, setState) {
            return Scaffold(
              appBar: AppBar(
                  backgroundColor: HexColor(MyColors.colorLogin),
                  centerTitle: true,
                  leading: IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  title: Text(
                    "Withdraw",
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Overpass',
                        fontSize: 20),
                  ),
                  elevation: 0.0),
              backgroundColor: HexColor(MyColors.colorLogin),
              body: SingleChildScrollView(
                child: Container(
                  margin:
                      const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
                  padding: const EdgeInsets.all(10),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Text(
                          titleVal,
                          style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),

                        Container(
                          height: 180,
                          width: 250,
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
                                  HexColor(MyColors.colorLogin)
                                      .withOpacity(0.8),
                                  HexColor(MyColors.colorLogin).withOpacity(0.8)
                                ]),
                              ),
                              child: Center(
                                child: InkWell(
                                  splashColor: Colors.blue.withAlpha(30),
                                  onTap: () {
                                    debugPrint('Card tapped.');
                                  },
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      //Center Column contents vertically,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        iconByName(
                                            gridData[currentWalletAmountIndex]
                                                ["title"]),
                                        Text(
                                          gridData[currentWalletAmountIndex]
                                              ["title"],
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.normal,
                                              color: Colors.white),
                                        ),
                                        Container(
                                          alignment: Alignment.center,
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Text(
                                              gridData[currentWalletAmountIndex]
                                                  ["amount"],
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          alignment: Alignment.center,
                                          child: Text(
                                            gridData[currentWalletAmountIndex]
                                                ["subtitle"],
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 11.0,
                                                fontWeight: FontWeight.normal,
                                                color: Colors.white70),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        //styling
                        SizedBox(
                          height: 15,
                        ),

                        Visibility(
                          visible: ismultiple,
                          child: TextFormField(
                            controller: addressController,
                            onChanged: (text) async {
                              print('First text field: $text');
                              if (type == 3 || type == 4) {
                                isload = true;
                                var internet = await UtilClass.checkInternet();
                                if (internet) {
                                  userError = false;
                                  userCheck = "Checking......";
                                  setState(() {});
                                  await Future.wait([
                                    Repository.userCheckApi(
                                        from: userId, to: text)
                                  ]).then((value) {
                                    isload = false;
                                    UtilClass.hideProgress(context: context);

                                    UserCheckResponse? responses = value[0];

                                    if (responses?.status?.error == "false") {
                                      String? userChecks =
                                          responses?.data?.toUser!;
                                      setState(() {
                                        userCheck =
                                            "You are trying to transfer to " +
                                                userChecks!;
                                        userError = false;
                                      });
                                    } else {
                                      userError = true;
                                      userCheck =
                                          "Please Enter the valid user ";
                                      setState(() {});
                                    }
                                  }, onError: (err) {
                                    isload = false;
                                    userError = true;
                                    userCheck =
                                        "Please check the user details and try again";
                                    setState(() {});
                                    UtilClass.showAlertDialog(
                                        context: context,
                                        message: err.toString());
                                  });
                                } else {
                                  UtilClass.showAlertDialog(
                                      context: context,
                                      message: Config.kNoInternet);
                                }
                              }
                            },
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: userError && type != 5
                                        ? Colors.red
                                        : Colors.white,
                                    width: 1.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: userError && type != 5
                                        ? Colors.red
                                        : Colors.white,
                                    width: 1.0),
                              ),
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 15.0),
                              border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                                borderSide: BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                ),
                              ),
                              filled: true,
                              prefixIcon: const Icon(
                                Icons.numbers_sharp,
                                color: Color(0xFF666666),
                                size: 15,
                              ),
                              fillColor: const Color(0xFFF2F3F5),
                              hintStyle: TextStyle(
                                color: const Color(0xFF666666),
                                fontFamily: Config.fontFamilyPoppinsMedium,
                              ),
                              hintText: userInputtxt,
                            ),
                            keyboardType: TextInputType.emailAddress,
                            onFieldSubmitted: (value) {
                              //Validator
                            },
                            validator: (value) {
                              if (value?.isEmpty == true ||
                                  !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(value!)) {
                                return 'Enter a valid email!';
                              }
                              return null;
                            },
                          ),
                        ),
                        Visibility(
                          visible: ismultiple && type != 5,
                          child: Text(
                            userCheck,
                            style: TextStyle(
                              fontSize: 14,

                              fontWeight: FontWeight.normal,
                              height: 2,
                              //line height 200%, 1= 100%, were 0.9 = 90% of actual line height
                              color: userError ? Colors.red : Colors.green,
                              //font color
                              //background color

                              //make underline
                              decorationStyle: TextDecorationStyle.double,
                              //double underline
                              decorationColor: Colors.brown,
                              //text decoration 'underline' color
                              decorationThickness:
                                  1.5, //decoration 'underline' thickness
                            ),
                          ),
                        ),

                        //box styling
                        SizedBox(
                          height: ismultiple ? 15 : 0,
                        ),
                        TextFormField(
                          controller: amountController,
                          onChanged: (text) async {
                            if (text.length > 0) {
                              amountCheck = text;
                              amountError = false;
                            } else {
                              amountCheck = "";
                              amountError = true;
                            }
                            setState(() {});
                          },
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(vertical: 15.0),
                            border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                              borderSide: BorderSide(
                                width: 0,
                                style: BorderStyle.none,
                              ),
                            ),
                            filled: true,
                            prefixIcon: const Icon(
                              Icons.numbers_sharp,
                              color: Color(0xFF666666),
                              size: 15,
                            ),
                            fillColor: const Color(0xFFF2F3F5),
                            hintStyle: TextStyle(
                              color: const Color(0xFF666666),
                              fontFamily: Config.fontFamilyPoppinsMedium,
                            ),
                            hintText: "Number of ITC",
                          ),
                          keyboardType: TextInputType.number,
                          onFieldSubmitted: (value) {
                            //Validator
                          },
                          validator: (value) {
                            if (value?.isEmpty == true ||
                                !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(value!)) {
                              return 'Enter a valid email!';
                            }
                            return null;
                          },
                        ),
                        //box styling

                        //box styling
                        SizedBox(
                          height: 15,
                        ),
                        //text input

                        ElevatedButton(
                          onPressed: () async {
                            if (getType(type)) {
                              String address = addressController.text;
                              String amount = amountController.text;

                              var internet = await UtilClass.checkInternet();
                              if (internet) {
                                UtilClass.showProgress(context: context);
                                await Future.wait([
                                  Repository.withdrawApi(
                                      type: type,
                                      id: userId,
                                      password: password,
                                      coins: amount,
                                      address: address ?? "")
                                ]).then((value) {
                                  UtilClass.hideProgress(context: context);

                                  WithdrawResponse? responses = value[0];

                                  if (responses?.status?.error == "false") {
                                    String? msg =
                                        responses?.data?.transaction?.details;

                                    UtilClass.showAlertDialog(
                                        context: context,
                                        message: msg,
                                        onOkClick: () =>
                                            {Navigator.pop(context)});

                                    // Navigator.pop(context);
                                  } else {
                                    String? msg = responses?.data?.message ??
                                        "Server error";
                                    UtilClass.showAlertDialog(
                                        context: context, message: msg);
                                  }
                                }, onError: (err) {
                                  UtilClass.showAlertDialog(
                                      context: context,
                                      message: err.toString());
                                });
                              } else {
                                UtilClass.showAlertDialog(
                                    context: context,
                                    message: Config.kNoInternet);
                              }
                            }
                          },
                          child: const Text("Transfer"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                getType(type) ? Colors.teal : Colors.grey,
                            shadowColor: Colors.grey,
                            elevation: 3,
                            shape: const BeveledRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(2.5))),
                          ),
                          // minimumSize: const Size(double.infinity, 45)
                        )

                        // RaisedButton(
                        //   padding: EdgeInsets.symmetric(
                        //     vertical: 10.0,
                        //     horizontal: 15.0,
                        //   ),
                        //   child: Text(
                        //     "Submit",
                        //     style: TextStyle(
                        //       fontSize: 24.0,
                        //     ),
                        //   ),
                        //   onPressed: () => _submit(),
                        // )
                      ],
                    ),
                  ),
                ),
              ),
            );
          });
        }).then((val) {
      userError = true;
      amountError = false;
      userCheck = "Please Enter the  valid user ";
      addressController.text = "";
      amountController.text = "";

      setState(() {});
      _callProdutDetailsAPI(userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor(MyColors.darkIndigo),
      body: Container(
        color: Colors.transparent,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  //your top widget tree
                  height: 60,
                  child: Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      elevation: 5,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            Colors.redAccent,
                            Colors.green,
                            Colors.purple
                          ]),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              //Center Column contents vertically,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              //Center Column contents horizontally,
                              children: [
                                Text(
                                  "ITC LIVE PRICE : ",
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white),
                                ),
                                Text(
                                  priceValue ?? "",
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                )
                              ],
                            ),
                          ),
                        ),
                      ))),
              Container(
                height: 200,
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
                          Container(
                            height: 40,
                            child: ListTile(
                              leading: Icon(
                                  size: 30.0,
                                  Icons.account_balance_wallet,
                                  color: Colors.white),
                              title: Row(
                                children: [
                                  Text(
                                    gridData[0]["title"],
                                    style: TextStyle(
                                        fontSize: 13.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  SizedBox(width: 20),
                                  Text(
                                    gridData[0]["amount"],
                                    style: TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: 40,
                            child: ListTile(
                              leading: Icon(
                                  size: 30.0,
                                  Icons.add_business,
                                  color: Colors.white),
                              title: Row(
                                children: [
                                  Text(
                                    gridData[1]["title"],
                                    style: TextStyle(
                                        fontSize: 13.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  SizedBox(width: 20),
                                  Text(
                                    gridData[1]["amount"],
                                    style: TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: 40,
                            child: ListTile(
                              leading: Icon(
                                  size: 30.0,
                                  Icons.wallet_travel,
                                  color: Colors.white),
                              title: Row(
                                children: [
                                  Text(
                                    gridData[2]["title"],
                                    style: TextStyle(
                                        fontSize: 13.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  SizedBox(width: 20),
                                  Text(
                                    gridData[2]["amount"],
                                    style: TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: 40,
                            child: ListTile(
                              leading: Icon(
                                  size: 30.0,
                                  Icons.card_giftcard,
                                  color: Colors.white),
                              title: Row(
                                children: [
                                  Text(
                                    gridData[3]["title"],
                                    style: TextStyle(
                                        fontSize: 13.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  SizedBox(width: 20),
                                  Text(
                                    gridData[3]["amount"],
                                    style: TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // Container(
              //   margin: const EdgeInsets.only(left: 10.0, right: 10.0, top: 2.0),
              //   padding: const EdgeInsets.symmetric(vertical: 2,horizontal: 10),
              //   child: Card(
              //
              //     shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(5)),
              //     clipBehavior: Clip.antiAliasWithSaveLayer,
              //     elevation: 5,
              //     child: Padding(
              //       padding: const EdgeInsets.all(0.0),
              //       child: Padding(
              //         padding: const EdgeInsets.all(0.0),
              //         child: Row(
              //           children: [
              //             Align(
              //               alignment:Alignment.centerLeft ,
              //               child: Padding(
              //
              //                 padding: const EdgeInsets.all(8.0),
              //                 child: Icon(size: 30.0, Icons.add_business, color: Colors.purpleAccent),
              //               ),
              //             ),
              //             Padding(
              //
              //               padding: const EdgeInsets.all(8.0),
              //               child: Text(gridData[1]["title"]),
              //             ),
              //             Padding(
              //
              //               padding: const EdgeInsets.all(8.0),
              //               child: Text(gridData[1]["amount"]),
              //             ),
              //           ],
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              // Container(
              //   margin: const EdgeInsets.only(left: 10.0, right: 10.0, top: 2.0),
              //   padding: const EdgeInsets.symmetric(vertical: 2,horizontal: 10),
              //   child: Card(
              //
              //     shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(5)),
              //     clipBehavior: Clip.antiAliasWithSaveLayer,
              //     elevation: 5,
              //     child: Padding(
              //       padding: const EdgeInsets.all(0.0),
              //       child: Padding(
              //         padding: const EdgeInsets.all(0.0),
              //         child: Row(
              //           children: [
              //             Align(
              //               alignment:Alignment.centerLeft ,
              //               child: Padding(
              //
              //                 padding: const EdgeInsets.all(8.0),
              //                 child:  Icon(size: 30.0, Icons.wallet_travel, color: Colors.orange),
              //               ),
              //             ),
              //             Padding(
              //
              //               padding: const EdgeInsets.all(8.0),
              //               child:  Text(gridData[2]["title"]),
              //             ),
              //             Padding(
              //
              //               padding: const EdgeInsets.all(8.0),
              //               child: Text(gridData[2]["amount"]),
              //             ),
              //           ],
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              //
              // Container(
              //   margin: const EdgeInsets.only(left: 10.0, right: 10.0, top: 2.0),
              //   padding: const EdgeInsets.symmetric(vertical: 2,horizontal: 10),
              //   child: Card(
              //
              //     shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(5)),
              //     clipBehavior: Clip.antiAliasWithSaveLayer,
              //     elevation: 5,
              //     child: Padding(
              //       padding: const EdgeInsets.all(0.0),
              //       child: Padding(
              //         padding: const EdgeInsets.all(0.0),
              //         child: Row(
              //           children: [
              //             Align(
              //               alignment:Alignment.centerLeft ,
              //               child: Padding(
              //
              //                 padding: const EdgeInsets.all(8.0),
              //                 child: Icon(size: 30.0, Icons.card_giftcard, color: Colors.indigoAccent),
              //               ),
              //             ),
              //             Padding(
              //
              //               padding: const EdgeInsets.all(8.0),
              //               child: Text(gridData[3]["title"]),
              //             ),
              //             Padding(
              //
              //               padding: const EdgeInsets.all(8.0),
              //               child: Text(gridData[3]["amount"]),
              //             ),
              //           ],
              //         ),
              //       ),
              //     ),
              //   ),
              // ),

              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Text(
              //     "WithDraw Amount ",
              //     style: TextStyle(
              //         fontSize: 16.0,
              //         fontWeight: FontWeight.bold,
              //         color: Colors.white),
              //   ),
              // ),
              Container(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                  child: Text(
                    textAlign: TextAlign.left,
                    "Self ",
                    style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
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
                    showInformationDialog(context, 1);
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
                        leading: Icon(Icons.move_up,
                            color: HexColor(MyColors.colorLogin)),
                        title: Text(
                          'Bonus Wallet to E-Wallet',
                          style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                              color: HexColor(MyColors.colorLogin)),
                        ),
                        trailing: Icon(Icons.arrow_forward_ios_sharp,
                            color: HexColor(MyColors.colorLogin)),
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
                  onTap: () {
                    showInformationDialog(context, 2);
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
                        leading: Icon(Icons.move_up,
                            color: HexColor(MyColors.colorLogin)),
                        title: Text(
                          'E-Wallet to Game Wallet',
                          style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                              color: HexColor(MyColors.colorLogin)),
                        ),
                        trailing: Icon(Icons.arrow_forward_ios_sharp,
                            color: HexColor(MyColors.colorLogin)),
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
                    "Internal ",
                    style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
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
                    showInformationDialog(context, 3);
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
                        leading: Icon(Icons.move_up,
                            color: HexColor(MyColors.colorLogin)),
                        title: Text(
                          'E-Wallet to E-Wallet',
                          style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                              color: HexColor(MyColors.colorLogin)),
                        ),
                        trailing: Icon(Icons.arrow_forward_ios_sharp,
                            color: HexColor(MyColors.colorLogin)),
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
                  onTap: () {
                    showInformationDialog(context, 4);
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
                        leading: Icon(Icons.move_up,
                            color: HexColor(MyColors.colorLogin)),
                        title: Text(
                          'Game Wallet to Game Wallet',
                          style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                              color: HexColor(MyColors.colorLogin)),
                        ),
                        trailing: Icon(Icons.arrow_forward_ios_sharp,
                            color: HexColor(MyColors.colorLogin)),
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
                    "External ",
                    style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
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
                    showInformationDialog(context, 5);
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
                        leading: Icon(Icons.move_up,
                            color: HexColor(MyColors.colorLogin)),
                        title: Text(
                          'Bonus Wallet to External Wallet',
                          style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                              color: HexColor(MyColors.colorLogin)),
                        ),
                        trailing: Icon(Icons.arrow_forward_ios_sharp,
                            color: HexColor(MyColors.colorLogin)),
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
