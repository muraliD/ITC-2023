import 'dart:convert';

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
import 'package:itc_community/models/history_response.dart';
import 'dart:math';
import 'package:itc_community/models/login_response.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/services.dart';

class ReferralsQRFragment extends StatefulWidget {
  const ReferralsQRFragment({Key? key}) : super(key: key);

  @override
  State<ReferralsQRFragment> createState() => _ReferralsQRFragmentState();
}

class _ReferralsQRFragmentState extends State<ReferralsQRFragment> {
  final List<int> numbers = [1, 2, 3, 5, 8, 13, 21, 34, 55];
  late List<Map<String, dynamic>> gridData = [];
  late List<UserH>? history = [];
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

  late String link;

  void plansApiRefresh() async {
    Preferences.initSharedPreference();
    var user = Preferences.getUserDetails();
    var decoded = json.decode(user!);
    final payload = UserL.fromJson(decoded);
    userId = (payload.id).toString();
    password = (payload.password).toString();

    var referalCode = Preferences.getReferralLink();
    link = json.decode(referalCode!);


  }

  @override
  void initState() {
     plansApiRefresh();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Referral Link"),
      ),
      backgroundColor: HexColor(MyColors.colorLogin),
      body: Container(

        child: Card(
          color: HexColor(MyColors.colorLogin),


          margin: const EdgeInsets.all(10),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          elevation: 5,
          child: Padding(

            padding: const EdgeInsets.all(10.0),
            child: Align(
              alignment: Alignment.center,
              child: Container(


                height: 350,
                child: Column(



                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        color: Colors.white,
                        height: 200,
                        width: 200,
                        child: QrImage(
                          data: link,
                          version: QrVersions.auto,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      link,
                      style: TextStyle(
                          fontSize: 12.0,

                          fontWeight: FontWeight.normal,
                          color: HexColor(MyColors.white)),
                    ),
                    SizedBox(
                      height: 15,
                    ),

                    ElevatedButton(
                        onPressed: () {
                          Clipboard.setData(ClipboardData(
                              text:link));
                        },
                        child: Text("Copy Link"))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
