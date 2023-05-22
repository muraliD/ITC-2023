import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:itc_community/utils/my_colors.dart';
import 'package:itc_community/services//repository.dart';
import 'package:itc_community/utils/config.dart';
import 'package:itc_community/utils/util_class.dart';
import 'package:itc_community/models/plans_response.dart';
import 'package:itc_community/models/PlanIndividual_response.dart';
import 'package:itc_community/models/planData_response.dart';
import 'package:itc_community/models/dashboard_response.dart';
import 'package:itc_community/models/liveToken_response.dart';
import 'package:itc_community/data/preferences.dart';
import 'package:itc_community/models/purchase_response.dart';
import 'dart:math';
import 'package:itc_community/models/login_response.dart';
import 'package:badges/badges.dart' as badges;
import 'package:blinking_text/blinking_text.dart';

class RanksFragment extends StatefulWidget {
  const RanksFragment({Key? key}) : super(key: key);

  @override
  State<RanksFragment> createState() => _RanksFragmentState();
}

class _RanksFragmentState extends State<RanksFragment> {
  final List<int> numbers = [1, 2, 3, 5, 8, 13, 21, 34, 55];
  late List<Map<String, dynamic>> gridData = [];
  List<Plan> plans = [];
  List<User1> users = [];
  PlansResponse? plansResponse;
  IndividualPlans? individualPlans;
  PlanData? planDataResponse;
  Purchase? purchase;
  LiveTokenResponse? livetokenResponse;
  DashboardResponse? dashboardResponse;
  User1? user1;
  late String userId;
  late String password;

  void plansApiRefresh() {
    Preferences.initSharedPreference();
    var user = Preferences.getUserDetails();
    var decoded = json.decode(user!);
    final payload = UserL.fromJson(decoded);
    userId = (payload.id).toString();
    password = (payload.password).toString();

    Future.delayed(Duration.zero, () async {
      UtilClass.showProgress(context: context);
      var plans = await callPlansAPI();

      if (plans?.status!.type == "Success") {
        var liveToken = await liveTokens(plans!);
        var indToken = await indivPlans(plans!);
        _callProdutDetailsAPI(plans, liveToken, indToken);
      } else {
        UtilClass.hideProgress(context: context);
        UtilClass.showAlertDialog(
            context: context,
            message: plans?.status!.message ?? "Server Error");
      }

      //here is the async code, you can execute any async code here
    });
  }

  @override
  void initState() {
    plansApiRefresh();

    super.initState();
  }

  Future<PlansResponse?> callPlansAPI() async {
    PlansResponse? plansdatas;

    var internet = await UtilClass.checkInternet();
    if (internet) {
      await Repository.getRanksApi().then((value) {
        plansdatas = value;
      }, onError: (err) {
        print(err);

        UtilClass.hideProgress(context: context);
        UtilClass.showAlertDialog(context: context, message: "planissue");
      });
    } else {
      UtilClass.hideProgress(context: context);
      UtilClass.showAlertDialog(context: context, message: Config.kNoInternet);
    }
    return plansdatas;
  }

  Future<List> liveTokens(PlansResponse plansdatass) async {
    var data = [];

    var internet = await UtilClass.checkInternet();
    if (internet) {
      var plans = plansdatass.data?.plan;
      // for (var land in plans!) {
      //   var response = await Repository.getLiveTokenDataApi((land.id).toString());
      //   data.add(response);
      // }

      data = await Future.wait([
        for (var land in plans!)
          Repository.getLiveTokenDataApi((land.id).toString()),
      ]);
    } else {
      UtilClass.hideProgress(context: context);
      UtilClass.showAlertDialog(context: context, message: Config.kNoInternet);
    }
    return data;
  }

  Future<List> indivPlans(PlansResponse plansdatass) async {
    var data = [];

    var internet = await UtilClass.checkInternet();
    if (internet) {
      UtilClass.showProgress(context: context);

      var plans = plansdatass.data?.plan;

      data = await Future.wait([
        for (var land in plans!)
          Repository.getPlanDataApi((land.id).toString()),
      ]);
    } else {
      UtilClass.showAlertDialog(context: context, message: Config.kNoInternet);
    }
    return data;
  }

  _callProdutDetailsAPI(presponse, livetokens, indtokens) async {
    var internet = await UtilClass.checkInternet();
    if (internet) {
      UtilClass.showProgress(context: context);
      await Future.wait([
        Repository.getItcPriceApi(),
        Repository.getUsertokensApi(userid: userId),
        Repository.getDashboardData(userid: userId),
      ]).then((value) async {
        /*Plans*/

        plansResponse = presponse;
        if (plansResponse?.status!.type == "Success") {
          plans = plansResponse!.data!.plan!;
        }

        /*UserTokens*/
        individualPlans = value[1];
        if (individualPlans?.status!.type == "Success") {
          users = individualPlans!.data!.user!;
        }

        PoolPoints? poolpoints;
        PlanCredits? planCredeits;
        dashboardResponse = value[2];
        if (dashboardResponse?.status!.type == "Success") {
          try{
            poolpoints = dashboardResponse?.data?.user?.poolPoints;
          }catch(err){
            poolpoints = null;
          }
          try{
            planCredeits = dashboardResponse?.data?.user?.planCredits;
          }catch(err){
            poolpoints = null;
          }

        } else {
          poolpoints = null;
          planCredeits = null;
        }

        List<Map<String, dynamic>> dataTemp = [];

        for (var i = 0; i < plans.length; i++) {
          var val = plans[i];

          planDataResponse = indtokens[i];
          livetokenResponse = livetokens[i];
          var amount = val.price! + " " + "ITC";
          // if (planDataResponse?.status!.type == "Success") {
          //   String? data = planDataResponse?.data!.plan!.price;
          //   amount =
          //       data != null ? (double.parse(data).toStringAsFixed(0)) : "";
          // }

          int length = val.currencySymbol!.length;

          if(length>0){
            var pricVal =
            val.priceInCurrency != null ? (double.parse(val.priceInCurrency!).toStringAsFixed(0)) : "";
            amount = val.currencySymbol! + " " + pricVal;

          }

          var itcAmount  =
          val.price != null ? (double.parse(val.price!).toStringAsFixed(2)) : "0.00";


          String? plan = val.name;
          int? planId = val.id;

          //Plan Credits
          StarPlans? starPlans = planCredeits?.starPlans ?? null;
          ElitePlans? elitePlans = planCredeits?.elitePlans ?? null;
        String? credits = "0";

        try {
        starPlans?.toJson()?.forEach((final String key, final value) {
        if (key.split("_")[1] == planId.toString()) {

          var pricValst =
          value != null ? (double.parse(value).toStringAsFixed(0)) : "";
        credits = pricValst.toString();
        }
        });
        } catch (err) {


        }


        try {
        elitePlans?.toJson()?.forEach((final String key, final value) {
        if (key.split("_")[1] == planId.toString()) {
          var pricValet =
          value != null ? (double.parse(value).toStringAsFixed(0)) : "";
        credits =pricValet;
        }
        });
        } catch (err) {


        }


          //poolpoiints

          SelfDash? games = poolpoints?.gamePoolPoints?.self ?? null;

          LevelDash? games1 = poolpoints?.gamePoolPoints?.level ?? null;

          Self? eleite = poolpoints?.elitePoolPoints?.self ?? null;

          Level? eleite1 = poolpoints?.elitePoolPoints?.level ?? null;

          String? self = "0";
          String? level = "0";

          try {
            games?.toJson()?.forEach((final String key, final value) {
              if (key.split("_")[1] == planId.toString()) {
                self = value.toString();
              }
            });
          } catch (err) {}

          try {
            games1?.toJson()?.forEach((final String key, final value) {
              if (key.split("_")[1] == planId.toString()) {
                level = value.toString();
                ;
              }
            });
          } catch (err) {}

          try {
            eleite?.toJson()?.forEach((final String key, final value) {
              if (key.split("_")[1] == planId.toString()) {
                self = value.toString();
                ;
              }
            });
          } catch (err) {}

          try {
            eleite1?.toJson()?.forEach((final String key, final value) {
              if (key.split("_")[1] == planId.toString()) {
                level = value.toString();
                ;
              }
            });
          } catch (err) {}

          // String? plan = val.name;
          //
          // if (games?.hasOwnProperty(plan!) ==  false) {
          //   // do stuff
          // }

          var userTok = [];

          for (var i = 0; i < users.length; i++) {
            if (users[i].plan == val.id) {
              userTok.add(users[i]);
            }
          }

          dynamic title = "UPGRADE";
          dynamic color = Colors.red;
          dynamic count = 0;

          dynamic selectedplan = dashboardResponse?.data?.user?.plan ?? null;
          if (selectedplan != null) {
            if (selectedplan == val.id) {
              title = "Active";
              color = Colors.teal;

              if (userTok.length > 0) {
                User1? datas = userTok[0];
                int? length = datas?.reActivatedCount;
                if (length! > 0) {
                  title = "Re Activated";
                  color = Colors.indigoAccent;
                  count = length!;
                }
              }
            } else if (userTok.length == 4) {
              title = "Active";
              color = Colors.teal;

              if (userTok.length > 0) {
                User1? datas = userTok[0];
                int? length = datas?.reActivatedCount;
                if (length! > 0) {
                  title = "Re Activated";
                  color = Colors.indigoAccent;
                  count = length!;
                }
              }
            }

            if (selectedplan + 1 == val.id) {
              title = "UPGRADE";
              color = Colors.orange;
            }
          } else {
            if (i == 0) {
              title = "UPGRADE";
              color = Colors.orange;
            }
          }

          var object = {
            'color': [Colors.purple, Colors.deepPurpleAccent],
            "name": val.name,
            "id": val.id,
            'price': amount ,
            "credits":credits,
            "tokens": userTok,
            'subtitle': "Total Earningssss",
            "type": "amount",
            "liveToken":
                (livetokenResponse?.data?.liveTokenId).toString() ?? "",
            "title": title,
            'self': self,
            "level": level,
            "btnColor": color,
            "count": count,
            "itc": "[ITC"+" "+itcAmount+"]"
          };

          dataTemp.add(object);
        }
        ;

        UtilClass.hideProgress(context: context);

        setState(() {
          gridData = dataTemp;
        });
      }, onError: (err) {
        UtilClass.hideProgress(context: context);
        UtilClass.showAlertDialog(context: context, message: err.toString());
      });
    } else {
      UtilClass.showAlertDialog(context: context, message: Config.kNoInternet);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor(MyColors.white),
      body: ListView.builder(
          itemCount: gridData?.length,
          itemBuilder: (context, index) {
            var val = gridData[index];

            dynamic selfToken0 = "";
            dynamic selfToken1 = "";
            dynamic selfToken2 = "";
            dynamic selfToken3 = "";
            dynamic selfToken4 = "";

            dynamic lgtAmt1 = "";
            dynamic lgtAmt2 = "";
            dynamic lgtAmt3 = "";
            dynamic lgtAmt4 = "";

            dynamic selfToken1Col = false;
            dynamic selfToken2Col = false;
            dynamic selfToken3Col = false;
            dynamic selfToken4Col = false;

            dynamic buttonTitle = "New";

            if (val["tokens"] != null && val["tokens"].length > 0) {
              var userd = val["tokens"];
              if (userd[0] != null && userd.length > 0) {
                User1 usertoken1 = userd[0];
                selfToken1 = usertoken1.childTokens.toString();
                selfToken1Col = usertoken1.childTokenStatus == 1 ? true : false;
                selfToken0 = usertoken1.selfToken.toString();
                lgtAmt1 = usertoken1.childLtgAmt.toString() ?? "";
                var data = usertoken1.toJson();

                lgtAmt1 = data["child_ltg_amt"] != null
                    ? (double.parse(data["child_ltg_amt"]))
                            .toStringAsFixed(2) ??
                        ""
                    : "";
              }
              if (userd[1] != null && userd.length > 0) {
                User1 usertoken2 = userd[1];
                selfToken2 = usertoken2.childTokens.toString();
                selfToken2Col = usertoken2.childTokenStatus == 1 ? true : false;
                var data2 = usertoken2.toJson();

                lgtAmt2 = data2["child_ltg_amt"] != null
                    ? (double.parse(data2["child_ltg_amt"]))
                            .toStringAsFixed(2) ??
                        ""
                    : "";
              }

              if (userd[2] != null && userd.length > 0) {
                User1 usertoken3 = userd[2];
                selfToken3 = usertoken3.childTokens.toString();
                selfToken3Col = usertoken3.childTokenStatus == 1 ? true : false;
                var data3 = usertoken3.toJson();

                lgtAmt3 = data3["child_ltg_amt"] != null
                    ? (double.parse(data3["child_ltg_amt"]))
                            .toStringAsFixed(2) ??
                        ""
                    : "";
              }

              if (userd[3] != null && userd.length > 0) {
                User1 usertoken4 = userd[3];
                selfToken4 = usertoken4.childTokens.toString();
                selfToken4Col = usertoken4.childTokenStatus == 1 ? true : false;
                var data4 = usertoken4.toJson();

                lgtAmt4 = data4["child_ltg_amt"] != null
                    ? (double.parse(data4["child_ltg_amt"]))
                            .toStringAsFixed(2) ??
                        ""
                    : "";
              }
            }

            return Padding(
              padding: const EdgeInsets.all(3.0),
              child: Card(
                margin: const EdgeInsets.all(2),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                elevation: 5,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      HexColor(MyColors.colorLogin),
                      HexColor(MyColors.colorLogin).withOpacity(0.7),
                      HexColor(MyColors.colorLogin)
                    ]),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: Container(
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Container(
                                          child: Text(
                                            val["name"],
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              fontSize: 18,

                                              fontWeight: FontWeight.bold,
                                              height: 2,
                                              //line height 200%, 1= 100%, were 0.9 = 90% of actual line height
                                              color: Colors.white,
                                              //font color
                                              //background color

                                              //make underline
                                              decorationStyle:
                                                  TextDecorationStyle.double,
                                              //double underline
                                              decorationColor: Colors.brown,
                                              //text decoration 'underline' color
                                              decorationThickness:
                                                  1.5, //decoration 'underline' thickness
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 5.0),
                                      child: Container(
                                        height: 40,
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            if (val["title"] == "UPGRADE") {
                                              if (val["btnColor"] ==
                                                  Colors.orange) {
                                                UtilClass.showProgress(
                                                    context: context);
                                                var internet = await UtilClass
                                                    .checkInternet();
                                                if (internet) {
                                                  await Repository
                                                          .purchasePlanApi(
                                                              id: userId,
                                                              password:
                                                                  password,
                                                              plan: val["id"]
                                                                  .toString())
                                                      .then((value) {
                                                    purchase = value;
                                                    UtilClass.hideProgress(
                                                        context: context);

                                                    if (purchase
                                                            ?.status?.error ==
                                                        "true") {
                                                      UtilClass.showAlertDialog(
                                                          context: context,
                                                          message: purchase
                                                              ?.data?.message,
                                                          onOkClick: () => {});
                                                    } else {
                                                      var message = purchase
                                                              ?.data
                                                              ?.plan
                                                              ?.details ??
                                                          "Plan Upgraded Successfully";

                                                      UtilClass.showAlertDialog(
                                                          context: context,
                                                          message: message,
                                                          onOkClick: () => {
                                                                plansApiRefresh()
                                                              });
                                                    }
                                                  }, onError: (err) {
                                                    print(err);

                                                    UtilClass.hideProgress(
                                                        context: context);
                                                    UtilClass.showAlertDialog(
                                                        context: context,
                                                        message: "planissue");
                                                  });
                                                } else {
                                                  UtilClass.hideProgress(
                                                      context: context);
                                                  UtilClass.showAlertDialog(
                                                      context: context,
                                                      message:
                                                          Config.kNoInternet);
                                                }
                                              }
                                            }
                                          },
                                          child: val["btnColor"] ==
                                                  Colors.indigoAccent
                                              ? badges.Badge(
                                                  position: badges.BadgePosition
                                                      .topEnd(
                                                          top: -20, end: -18),
                                                  showBadge: true,
                                                  ignorePointer: false,
                                                  badgeContent: Text(
                                                      val["count"].toString() ??
                                                          "0"),
                                                  badgeStyle: badges.BadgeStyle(
                                                    badgeColor: Colors.white,
                                                    elevation: 0,
                                                  ),
                                                  child: Text(val["title"]),
                                                )
                                              : Text(val["title"]),
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: val["btnColor"],
                                              shape:
                                                  const BeveledRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  2.5))),
                                              minimumSize: const Size(44, 44)),
                                        ),
                                      ),
                                    )
                                  ]),
                            ),
                          ),
                        ),
                        Divider(
                          height: 5,
                          color: HexColor(MyColors.colorLogin),
                        ),
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Container(
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2.0, horizontal: 3.0),
                                      child: Container(
                                        child: Text(
                                          val["price"],
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            height: 2,
                                            //line height 200%, 1= 100%, were 0.9 = 90% of actual line height
                                            color: Colors.white,
                                            //font color
                                            //background color

                                            //make underline
                                            decorationStyle:
                                                TextDecorationStyle.double,
                                            //double underline
                                            decorationColor: Colors.brown,
                                            //text decoration 'underline' color
                                            decorationThickness:
                                                1.5, //decoration 'underline' thickness
                                          ),
                                        ),
                                      ),
                                    ),

                                    val["title"]=="UPGRADE"?Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2.0, horizontal: 2.0),
                                      child: Container(
                                      
                                        child: BlinkText(
                                            val["itc"],
                                            style: TextStyle(fontSize: 15.0, height: 2, color: Colors.white),
                                          endColor: val["btnColor"],
                                            duration: Duration(seconds: 1)
                                        ),
                                      ),
                                    ):Text(""),

                                    val["title"] == "UPGRADE"? Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2.0, horizontal: 2.0),
                                      child: Container(
                                        child: Text(
                                          '-'+val["credits"]+" "+"credits",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontSize: 15,
                                            height: 2,
                                            //line height 200%, 1= 100%, were 0.9 = 90% of actual line height
                                            color: Colors.grey,
                                            //font color
                                            //background color

                                            //make underline
                                            decorationStyle:
                                                TextDecorationStyle.double,
                                            //double underline
                                            decorationColor: Colors.brown,
                                            //text decoration 'underline' color
                                            decorationThickness:
                                                1.0, //decoration 'underline' thickness
                                          ),
                                        ),
                                      ),
                                    ):Text(""),
                                  ]),
                            ),
                          ),
                        ),
                        Container(
                          height: 40,
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(2)),
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              elevation: 5,
                              color: Colors.indigo,
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Expanded(
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: 40,
                                        color: Colors.indigoAccent,
                                        child: Tooltip(
                                          triggerMode: TooltipTriggerMode.tap,
                                          decoration: BoxDecoration(
                                              color: Colors.indigo,
                                              borderRadius:
                                                  BorderRadius.circular(22)),
                                          richMessage: TextSpan(
                                            text: selfToken0,
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          child: Text(
                                            selfToken0,
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.white),
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: 40,
                                        color: selfToken1Col
                                            ? Colors.green
                                            : Colors.black,
                                        child: Tooltip(
                                          decoration: BoxDecoration(
                                              color: Colors.indigo,
                                              borderRadius:
                                                  BorderRadius.circular(22)),
                                          triggerMode: TooltipTriggerMode.tap,
                                          richMessage: TextSpan(
                                            text: selfToken1,
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          child: Text(
                                            selfToken1,
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.white),
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        color: selfToken2Col
                                            ? Colors.green
                                            : Colors.black,
                                        alignment: Alignment.center,
                                        height: 40,
                                        child: Tooltip(
                                          decoration: BoxDecoration(
                                              color: Colors.indigo,
                                              borderRadius:
                                                  BorderRadius.circular(22)),
                                          triggerMode: TooltipTriggerMode.tap,
                                          richMessage: TextSpan(
                                            text: selfToken2,
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          child: Text(
                                            selfToken2,
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.white),
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        color: selfToken3Col
                                            ? Colors.green
                                            : Colors.black,
                                        alignment: Alignment.center,
                                        height: 40,
                                        child: Tooltip(
                                          decoration: BoxDecoration(
                                              color: Colors.indigo,
                                              borderRadius:
                                                  BorderRadius.circular(22)),
                                          triggerMode: TooltipTriggerMode.tap,
                                          richMessage: TextSpan(
                                            text: selfToken3,
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          child: Text(
                                            selfToken3,
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.white),
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        color: selfToken4Col
                                            ? Colors.green
                                            : Colors.black,
                                        alignment: Alignment.center,
                                        height: 40,
                                        child: Tooltip(
                                          decoration: BoxDecoration(
                                              color: Colors.indigo,
                                              borderRadius:
                                                  BorderRadius.circular(22)),
                                          triggerMode: TooltipTriggerMode.tap,
                                          richMessage: TextSpan(
                                            text: selfToken4,
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          child: Text(
                                            selfToken4,
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.white),
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ]),
                            ),
                          ),
                        ),
                        Container(
                          height: 50,
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Card(
                              color: Colors.redAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(3),
                              ),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Expanded(
                                      child: Container(
                                        height: 50,
                                        alignment: Alignment.center,
                                        color: Colors.pinkAccent,
                                        child: Tooltip(
                                            decoration: BoxDecoration(
                                                color: Colors.indigo,
                                                borderRadius:
                                                    BorderRadius.circular(22)),
                                            triggerMode: TooltipTriggerMode.tap,
                                            richMessage: TextSpan(
                                              text: val["liveToken"],
                                              style:
                                                  TextStyle(color: Colors.lime),
                                            ),
                                            child: Text(
                                              val["liveToken"],
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.white),
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.ellipsis,
                                            )),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        height: 50,
                                        alignment: Alignment.center,
                                        color: Colors.black,
                                        child: Tooltip(
                                            triggerMode: TooltipTriggerMode.tap,
                                            decoration: BoxDecoration(
                                                color: Colors.indigo,
                                                borderRadius:
                                                    BorderRadius.circular(22)),
                                            richMessage: TextSpan(
                                              text: lgtAmt1 + " " + "ITC",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            child: Text(
                                              lgtAmt1 + " " + "ITC",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.white),
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.ellipsis,
                                            )),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        height: 50,
                                        alignment: Alignment.center,
                                        color: Colors.black,
                                        child: Tooltip(
                                            triggerMode: TooltipTriggerMode.tap,
                                            decoration: BoxDecoration(
                                                color: Colors.indigo,
                                                borderRadius:
                                                    BorderRadius.circular(22)),
                                            richMessage: TextSpan(
                                              text: lgtAmt2 + " " + "ITC",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            child: Text(
                                              lgtAmt2 + " " + "ITC",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.white),
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.ellipsis,
                                            )),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        height: 50,
                                        alignment: Alignment.center,
                                        color: Colors.black,
                                        child: Tooltip(
                                            triggerMode: TooltipTriggerMode.tap,
                                            decoration: BoxDecoration(
                                                color: Colors.indigo,
                                                borderRadius:
                                                    BorderRadius.circular(22)),
                                            richMessage: TextSpan(
                                              text: lgtAmt3 + " " + "ITC",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            child: Text(
                                              lgtAmt3 + " " + "ITC",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.white),
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.ellipsis,
                                            )),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        height: 50,
                                        alignment: Alignment.center,
                                        color: Colors.black,
                                        child: Tooltip(
                                            triggerMode: TooltipTriggerMode.tap,
                                            decoration: BoxDecoration(
                                                color: Colors.indigo,
                                                borderRadius:
                                                    BorderRadius.circular(22)),
                                            richMessage: TextSpan(
                                              text: lgtAmt4 + " " + "ITC",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            child: Text(
                                              lgtAmt4 + " " + "ITC",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.white),
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.ellipsis,
                                            )),
                                      ),
                                    ),
                                  ]),
                            ),
                          ),
                        ),
                        Divider(
                          height: 5,
                          color: HexColor(MyColors.colorLogin),
                        ),
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Container(
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      'Game Pool Points',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.lime),
                                    )
                                  ]),
                            ),
                          ),
                        ),
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Container(
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Self : ' + val["self"],
                                        textAlign: TextAlign.left,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Level One: ' + val["level"],
                                        textAlign: TextAlign.right,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    )
                                  ]),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
            // child: ListTile(
            //     title: Tooltip( richMessage: TextSpan(
            //       text: 'I am a rich tooltip. ',
            //       style: TextStyle(color: Colors.red),
            //
            //     ),
            //       child: Text('Tap this '),),
            //     subtitle: Text("iiiiiii"),
            //     leading: CircleAvatar(
            //         backgroundImage: NetworkImage(
            //             "https://images.unsplash.com/photo-1547721064-da6cfb341d50")),
            //     trailing: Icon(Icons.ice_skating)));
          }),
    );
  }
}
