import 'dart:ffi';
import 'dart:math';
import 'dart:convert';

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
import 'package:blinking_text/blinking_text.dart';
class DashboardFragment extends StatefulWidget {
  const DashboardFragment({Key? key}) : super(key: key);

  @override
  State<DashboardFragment> createState() => _DashboardFragmentState();
}

class _DashboardFragmentState extends State<DashboardFragment> {
  DashboardResponse? dashboardData;
  PriceResponse? priceData;

  String priceValue = "";
  List<Map<String, dynamic>> gridData = [
    {
      'color': [Colors.purple, Colors.deepPurpleAccent],
      "amount": "0.00",
      'title': "Total Bonus",
      'subtitle': "Total Earningssss",
      "type": "amount"
    },
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
      'color':[Colors.indigo, Colors.indigoAccent],
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
    },
    {
      'color': [Colors.amber, Colors.amberAccent],
      "amount": "0.00",
      'title': "ITC CONNECT",
      'subtitle': "Earned ITC Coins",
      "type": "amount"
    },
    {
      'color': [Colors.white, Colors.white70],
      "amount": "",
      'title': "Referral Link",
      'subtitle': "Earned ITC Coins",
      "type": "qrcode"
    },
    {
      'color': [Colors.white, Colors.white70],
      "amount": "",
      'title': "Deposits",
      'subtitle': "Earned ITC Coins",
      "type": "qrcode"
    }
  ];

  iconByName(name) {
    if (name == "Total Bonus") {
      return Icon(size: 50.0, Icons.account_balance, color: Colors.white);
    } else if (name == "E-Wallet") {
      return Icon(size: 50.0, Icons.account_balance_wallet, color: Colors.white);
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
    Preferences.initSharedPreference();
    var user = Preferences.getUserDetails();
    var decoded = json.decode(user!);
    final payload = User.fromJson(decoded);
    var id =payload.id.toString();
    _callProdutDetailsAPI(id);
    super.initState();
  }

  _callProdutDetailsAPI(String id) async {
    var internet = await UtilClass.checkInternet();
    if (internet) {
      UtilClass.showProgress(context: context);
      await Future.wait([
        Repository.getDashboardData(userid: id),
        Repository.getItcPriceApi()
      ]).then((value) {
        UtilClass.hideProgress(context: context);

        dashboardData = value[0];
        priceData = value[1];
        if(priceData?.status!.type == "Success") {
          String? dataPrice = priceData?.data?.tokenInfo?.value;
          dynamic data = dataPrice != null ? dataPrice : "0.00";
          dynamic currency =  priceData?.data?.tokenInfo?.valueShownIn??"";
          double? tbonus =double.parse(data);
          priceValue =
          tbonus != null ? tbonus.toString() + " "+currency : "";
          setState(() {});
        }else{
          priceValue = "";
        }


        if(dashboardData?.status!.type == "Success") {
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

          var tbonusData =
          tbonus != null ? tbonus.toStringAsFixed(2) : "";
          var ewalletData =
          ewallet != null ? (double.parse(ewallet)).toStringAsFixed(2) : "";
          var bonusData =
          bwallet != null ? (double.parse(bwallet)).toStringAsFixed(2) : "";
          var upgradeData = upgradeCredits != null
              ? (double.parse(upgradeCredits)).toStringAsFixed(2)
              : "";
          var arcCoinsData =
          arcCoins != null ? (double.parse(arcCoins)).toStringAsFixed(2) : "";
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
              'color': [Colors.purple, Colors.deepPurpleAccent],
              "amount": tbonusData,
              'title': "Total Bonus",
              'subtitle': "Total Earningssss",
              "type": "amount"
            },
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
            },
            {
              'color': [Colors.amber, Colors.amberAccent],
              "amount": itc,
              'title': "ITC CONNECT",
              'subtitle': "Earned ITC Coins",
              "type": "amount"
            },
            {
              'color': [Colors.white, Colors.white70],
              "amount": referal,
              'title': "Referral Link",
              'subtitle': "Earned ITC Coins",
              "type": "qrcode"
            },
            {
              'color': [Colors.white, Colors.white70],
              "amount": depositData,
              'title': "Deposits",
              'subtitle': "Earned ITC Coins",
              "type": "qrcode"
            }
          ];

          // counter = int.parse(_productDetailsResponse?.prodData![0]?.price != null &&
          //         _productDetailsResponse!.prodData![0]?.value!.isNotEmpty
          //     ? "${_productDetailsResponse!.data!.quantityValue}"
          //     : "1");

          setState(() {});
        }
      }, onError: (err) {
        print(err);
        UtilClass.showAlertDialog(context: context, message: err.toString());
      });
    } else {
      UtilClass.showAlertDialog(context: context, message: Config.kNoInternet);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor(MyColors.darkIndigo),
      body: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Stack(
          children: [
            Positioned(
                top: 60,
                //display after the height of top widtet
                bottom: 0,
                //display untill the height of bottom widget
                left: 0,
                right: 0,
                //mention top, bottom, left, right, for full size widget
                child: GridView.count(
                    crossAxisCount: 2,
                    controller: new ScrollController(keepScrollOffset: false),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    // Create a grid with 2 columns. If you change the scrollDirection to
                    // horizontal, this produces 2 rows.

                    // Generate 100 widgets that display their index in the List.
                    children: gridData.map<Widget>((item) {
                      if (item["type"] == "amount") {
                        return Container(
                          height: 20,
                          child: Card(
                            margin: const EdgeInsets.all(10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            elevation: 5,
                            child: Container(
                              decoration:  BoxDecoration(
                                boxShadow: [
                                  BoxShadow( //<-- SEE HERE
                                    color: Colors.greenAccent,
                                    blurRadius: 10.0,
                                  ),
                                ],
                                gradient:
                                LinearGradient(colors:item["color"]),
                              ),
                              child: Center(
                                child: InkWell(
                                  splashColor: Colors.blue.withAlpha(30),
                                  onTap: () {
                                    debugPrint('Card tapped.');
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width / 2,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      //Center Column contents vertically,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        iconByName(item['title']),
                                        Text(
                                          item['title'],
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
                                              item['amount'],
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
                                            item['subtitle'],
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
                        );
                      } else {
                        return Container(
                          height: 20,
                          child: Card(
                            margin: const EdgeInsets.all(10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            elevation: 5,
                            child: Container(
                              decoration:  BoxDecoration(
                                gradient:
                                LinearGradient(colors:item["color"]),
                              ),
                              child: Center(
                                child: InkWell(
                                  splashColor: Colors.blue.withAlpha(30),
                                  onTap: () {
                                    debugPrint('Card tapped.');
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width / 2,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      //Center Column contents vertically,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          flex: 4,
                                          child: Container(
                                            child: QrImage(
                                              data: item['amount'],
                                              version: QrVersions.auto,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            item['title'],
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ElevatedButton(
                                                onPressed: () {
                                                  Clipboard.setData(ClipboardData(
                                                      text: item['amount']));
                                                },
                                                child: Text("Copy Link")),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                    }).toList())),

            //set top/bottom widget after content,
            //other wise it wil go below content
            Positioned(
                //position at top
                top: 0,
                left: 0,
                right: 0, //set left right to 0 for 100% width
                child: Container(
                    //your top widget tree
                    height: 60,
                    child: Card(
                        margin: const EdgeInsets.symmetric(vertical:5,horizontal: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        elevation: 5,
                        child: Container(
                          decoration:  BoxDecoration(
                            gradient:
                            LinearGradient(colors:[Colors.redAccent,Colors.green,Colors.purple]),
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
                        )))),

            // Positioned( //position at bottom
            //     bottom: 0,
            //     left:0, right:0, //set left right to 0 for 100% width
            //     child: Container( //your bototm widget tree
            //         height: 100,
            //         color: Colors.greenAccent
            //     )
            // ),
          ],
        ),
      ),
    );
  }
}
