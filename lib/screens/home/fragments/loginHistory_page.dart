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

class HistoryFragment extends StatefulWidget {
  const HistoryFragment({Key? key}) : super(key: key);

  @override
  State<HistoryFragment> createState() => _HistoryFragmentState();
}

class _HistoryFragmentState extends State<HistoryFragment> {
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


    plansApiRefresh();


    super.initState();
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login History"),
      ),
      backgroundColor: HexColor(MyColors.white),
      body: ListView.builder(
          itemCount: history?.length,
          itemBuilder: (context, index) {


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
                                          child: Padding(
                                            padding: const EdgeInsets.all(0.0),
                                            child: Column(
                                              children: [
                                                Container(
                                                  height: 40,
                                                  child: ListTile(

                                                    title: Row(
                                                      children: [
                                                        Text(
                                                         "IP ADDRESS",
                                                          style: TextStyle(
                                                              fontSize: 13.0,
                                                              fontWeight: FontWeight.bold,
                                                              color: Colors.white),
                                                        ),
                                                        SizedBox(width: 20),
                                                        Text(
                                                            history![index].ipAddress!,
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

                                                    title: Row(
                                                      children: [
                                                        Text(
                                                          "BROWSER NAME	",
                                                          style: TextStyle(
                                                              fontSize: 13.0,
                                                              fontWeight: FontWeight.bold,
                                                              color: Colors.white),
                                                        ),
                                                        SizedBox(width: 20),
                                                        Text(
                                                          history![index].browserName!,
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

                                                    title: Row(
                                                      children: [
                                                        Text(
                                                          "PLOTFORM NAME",
                                                          style: TextStyle(
                                                              fontSize: 13.0,
                                                              fontWeight: FontWeight.bold,
                                                              color: Colors.white),
                                                        ),
                                                        SizedBox(width: 20),
                                                        Text(
                                                          history![index].platformName!,
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

                                                    title: Row(
                                                      children: [
                                                        Text(
                                                          "TIMESTAMP",
                                                          style: TextStyle(
                                                              fontSize: 13.0,
                                                              fontWeight: FontWeight.bold,
                                                              color: Colors.white),
                                                        ),
                                                        SizedBox(width: 20),
                                                        Text(
                                                          history![index].dateTime!,
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

                                  ]),
                            ),
                          ),
                        ),
                        Divider(
                          height: 5,
                          color: HexColor(MyColors.colorLogin),
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
