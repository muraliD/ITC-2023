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
import 'package:itc_community/screens/home/fragments/referralsHistory_page.dart';
import 'package:itc_community/screens/home/fragments/referralsQr_page.dart';

class ReferalFragment extends StatefulWidget {
  const ReferalFragment({Key? key}) : super(key: key);

  @override
  State<ReferalFragment> createState() => _ReferalFragmentState();
}

class _ReferalFragmentState extends State<ReferalFragment> {
  final List<int> numbers = [1, 2, 3, 5, 8, 13, 21, 34, 55];
  late List<Map<String, dynamic>> gridData = [];
  late  List<UserH>? history = [];
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



  void plansApiRefresh()async {

    Preferences.initSharedPreference();
    var user = Preferences.getUserDetails();
    var decoded = json.decode(user!);
    final payload = UserL.fromJson(decoded);
    userId = (payload.id).toString();
    password = (payload.password).toString();




    UtilClass.showProgress(context: context);
    var internet = await UtilClass.checkInternet();
    if (internet) {
      await Repository.historyApi(id: userId).then((value) {
        UtilClass.hideProgress(context: context);
        HistoryResponse data = value;

        setState(() {
          history = data.data?.user;
        });
      }, onError: (err) {
        print(err);

        UtilClass.hideProgress(context: context);
        UtilClass.showAlertDialog(context: context, message: "planissue");
      });
    } else {
      UtilClass.hideProgress(context: context);
      UtilClass.showAlertDialog(context: context, message: Config.kNoInternet);
    }






  }
  @override
  void initState() {


    // plansApiRefresh();


    super.initState();
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor(MyColors.white),
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.qr_code_2_outlined),text: 'Referrals'),
                Tab(icon: Icon(Icons.list_alt_outlined),text: 'Last 6 Referals')

              ],
            ), // TabBar
            title: const Text('Referral'),
            backgroundColor:HexColor(MyColors.colorLogin),
          ), // AppBar
          body: const TabBarView(
            children: [
              ReferralsQRFragment(),
              ReferralsHistoryFragment()

            ],
          ), // TabBarView
        ), // Scaffold
       // DefaultTabController
    ),
    );
  }
}
