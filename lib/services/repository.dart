// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:itc_community/services//end_points.dart';
import 'package:itc_community/data/preferences.dart';

import 'package:itc_community/models/login_response.dart';
import 'package:itc_community/models/dashboard_response.dart';
import 'package:itc_community/models/price_response.dart';
import 'package:itc_community/models/plans_response.dart';
import 'package:itc_community/models/PlanIndividual_response.dart';
import 'package:itc_community/models/planData_response.dart';
import 'package:itc_community/models/liveToken_response.dart';

import 'package:itc_community/utils/config.dart';
import 'package:itc_community/utils/util_class.dart';
import 'package:itc_community/models/purchase_response.dart';
import 'package:itc_community/models/userCheck_response.dart';
import 'package:itc_community/models/withdraw_response.dart';
import 'package:itc_community/models/changePassword_response.dart';
import 'package:itc_community/models/history_response.dart';
import 'package:itc_community/models/registration_response.dart';
import 'package:http/http.dart' as http;

class Repository {
  static final Dio dio = Dio();

  static Options headerParameters() {
    Options options = Options(
      contentType: Headers.jsonContentType,
      headers: {},
    );
    dio.interceptors.add(LogInterceptor());
    return options;
  }

  static Map<String, String> getHeaders() {

    return {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Charset': 'utf-8'

    };
  }

  initializeInterceptors() {
    dio.interceptors.add(LogInterceptor());
  }

  static getUserId(){
    var user = Preferences.getUserDetails();
    var decoded = json.decode(user!);
    final payload = UserL.fromJson(decoded);
    return (payload.id).toString();
  }

  static getPassword(){
    var user = Preferences.getUserDetails();
    var decoded = json.decode(user!);
    final payload = UserL.fromJson(decoded);
    return (payload.password).toString();;

  }

  static getUserKey(){

    var user = Preferences.getUserDetails();
    var decoded = json.decode(user!);
    final payload = UserL.fromJson(decoded);
    return Uri.encodeComponent((payload.user_security_key).toString());

  }

  static getAppKey(){

    var user = Preferences.getUserDetails();
    var decoded = json.decode(user!);
    final payload = UserL.fromJson(decoded);
    return  "securityKey="+Uri.encodeComponent((payload.app_security_key).toString());

  }
  static getAppKeyDummy(){

    return "securityKey=f9ed864b583304199c405999358e4a581915f353";
  }


  static  getErrorResponse(){


    return {
      "status": {
      "type": "Error",
      "message": "Server Errors",
      "code": 200,
      "error": "true"
    }
    };

  }

  static Future<dynamic> register({required String refcode,required String name,required String countryCode,required String mobile,required String email, required String password,required String cpassword,required String term}) async {
    RegistrationResponse registerResponse;


    var response = await http.post(
        Uri.parse(EndPoints.registerAPI +
            "?ref_code="+refcode+"&name="+name+"&c_code="+countryCode+"&mobile="+mobile+"&email="+email+"&pass="+Uri.encodeComponent(password)+"&newpass="+Uri.encodeComponent(cpassword)+"&terms="+term+"&"+getAppKeyDummy()),
        headers: getHeaders()
    );

    // print('PAYLOAD>>>>$params');
    // UtilClass.printWrapped('Login RES>>>>>${jsonDecode(response.body)}');

    dynamic parsed = {};
    try{
      parsed = await json.decode(response.body);
    }catch(e){
      print(e);
    }
    try{
      if (parsed["data"] != null) {

        registerResponse = RegistrationResponse.fromJson(parsed);
        return registerResponse;
      } else {
        registerResponse = RegistrationResponse.fromJson(parsed);
        return registerResponse;
      }

    }catch(err){
      var data = getErrorResponse();
      registerResponse = RegistrationResponse.fromJson(data);
      return registerResponse;

    }

  }
  static Future<dynamic> forgot({required String username}) async {
    RegistrationResponse registerResponse;


    var response = await http.post(
        Uri.parse(EndPoints.forgotAPI +
            "?username="+username+"&"+getAppKeyDummy()),
        headers: getHeaders()
    );

    // print('PAYLOAD>>>>$params');
    // UtilClass.printWrapped('Login RES>>>>>${jsonDecode(response.body)}');

    dynamic parsed = {};
    try{
      parsed = await json.decode(response.body);
    }catch(e){
      print(e);
    }
    try{
      if (parsed["data"] != null) {

        registerResponse = RegistrationResponse.fromJson(parsed);
        return registerResponse;
      } else {
        registerResponse = RegistrationResponse.fromJson(parsed);
        return registerResponse;
      }

    }catch(err){
      var data = getErrorResponse();
      registerResponse = RegistrationResponse.fromJson(data);
      return registerResponse;

    }

  }

  static Future<dynamic> getLogin({required String email, required String password}) async {
    LoginResponse loginResponse;

    var params = {
      'email': "60732",
      'password': "money@1985",
    };

    var response = await http.post(
      Uri.parse(EndPoints.loginAPI +
          "?email=" +
          email +
          "&password=" +
          Uri.encodeComponent(password) +
          "&"+getAppKeyDummy()),
         headers: getHeaders()
    );
   // UtilClass.printWrapped('Login RES>>>>>${jsonDecode(response.body)}');

    dynamic parsed = {};
    try{
      parsed = await json.decode(response.body);
    }catch(e){
      print(e);
    }
  try{
    if (parsed["data"] != null) {

      parsed["data"]["user"]["password"] = password;
      loginResponse = LoginResponse.fromJson(parsed);
      return loginResponse;
    } else {
      loginResponse = LoginResponse.fromJson(parsed);
      return loginResponse;
    }

  }catch(err){
    var data = getErrorResponse();
    loginResponse = LoginResponse.fromJson(data);
    return loginResponse;

  }

  }
  static Future<dynamic> changePassword({required String userid,required String password, required String newPassword,required String cNewpassword}) async {
    ChangePassword changeResponse;


    var response = await http.post(
        Uri.parse(EndPoints.changePasswordAPI +
            "?id="+userid+"&oldPassword="+Uri.encodeComponent(password)+"&newPassword="+Uri.encodeComponent(newPassword)+"&confirmNewPassword="+Uri.encodeComponent(cNewpassword)+"&"+getAppKey()),
        headers: getHeaders()
    );
    
    // print(EndPoints.changePasswordAPI +
    //     "?id="+userid+"&oldPassword="+password+"&newPassword="+newPassword+"&confirmNewPassword="+cNewpassword+"&securityKey=ITC_GLOBAL_RR_MSK_%26^%@)(^_1230987_msk");
    // UtilClass.printWrapped(
    //     EndPoints.changePasswordAPI + 'change password*************************************** RES>>>>>${jsonDecode(response.body)}');


    dynamic parsed = {};
    try{
      parsed = await json.decode(response.body);
    }catch(e){
      print(e);
    }
    try{
      if (parsed["data"] != null) {
        changeResponse = ChangePassword.fromJson(parsed);
        return changeResponse;
      } else {
        var data = getErrorResponse();
        changeResponse = ChangePassword.fromJson(data);
        return changeResponse;
      }

    }catch(err){
      var data = getErrorResponse();
      changeResponse = ChangePassword.fromJson(data);
      return changeResponse;

    }

  }

  static Future<dynamic> getItcPriceApi() async {
    PriceResponse priceResponse;

    var response = await http.post(
      Uri.parse(EndPoints.itcPriceAPI +
          "?"+getAppKeyDummy()),
    );

    dynamic parsed = {};
    try{
       parsed = await json.decode(response.body);
    }catch(e){

      print(e);
    }


try {
  if (parsed["data"] != null) {
    priceResponse = PriceResponse.fromJson(parsed);
    return priceResponse;
  } else {
    var data = getErrorResponse();
    priceResponse = PriceResponse.fromJson(data);
    return priceResponse;
  }
}catch(err){

  var data = getErrorResponse();
  priceResponse = PriceResponse.fromJson(data);
  return priceResponse;
}





  }

  static Future<dynamic> getDashboardData({required String userid}) async {
    DashboardResponse dashboardResponse;

    var response = await http.post(
      Uri.parse(EndPoints.userdataAPI +
          "?id=" +
          userid +
          "&"+getAppKey()),
    );



    dynamic parsed = {};
    try{
      parsed = await json.decode(response.body);
    }catch(e){
      print(e);
    }
try {
  if (parsed["data"] != null) {
    dashboardResponse = DashboardResponse.fromJson(parsed);
    return dashboardResponse;
  } else {
    var data = getErrorResponse();
    dashboardResponse = DashboardResponse.fromJson(data);
    return dashboardResponse;
  }
}catch(err){
  var data = getErrorResponse();
  dashboardResponse = DashboardResponse.fromJson(data);
  return dashboardResponse;
}



  }

  static Future<dynamic> getRanksApi() async {
    PlansResponse plansResponse;

    var response = await http.post(
      Uri.parse(EndPoints.plansAPI +
          "?"+getAppKey()),
        headers: getHeaders()
    );


    dynamic parsed = {};

    try{
      parsed = await json.decode(response.body);
    }catch(e){
      print(e);
    }
try {
  if (parsed["data"] != null) {
    plansResponse = PlansResponse.fromJson(parsed);
  } else {
    var data = getErrorResponse();
    plansResponse = PlansResponse.fromJson(data);
    return plansResponse;
  }


  return plansResponse;
}catch(err){

  var data = getErrorResponse();
  plansResponse = PlansResponse.fromJson(data);
  return plansResponse;
}



  }

  static Future<dynamic> getUsertokensApi({required String userid}) async {
    IndividualPlans plansResponse;

    var response = await http.post(
      Uri.parse(EndPoints.userTokensAPI +
          "?id="+userid+"&"+getAppKey()),
    );



    dynamic parsed = {};
    try{
      parsed = await json.decode(response.body);
    }catch(e){
      print(e);
    }
try {
  if (parsed["data"] != null) {
    plansResponse = IndividualPlans.fromJson(parsed);
    return plansResponse;
  } else {
    var data = getErrorResponse();
    plansResponse = IndividualPlans.fromJson(data);
    return plansResponse;
  }
}catch(err){
  var data = getErrorResponse();
  plansResponse = IndividualPlans.fromJson(data);
  return plansResponse;
}



  }

  static Future<dynamic> getPlanDataApi(id) async {
    PlanData plansResponse;

    var response = await http.post(
      Uri.parse(EndPoints.planDataAPI +
          "?plan_id=" +
          id +
          "+&"+getAppKey()),
    );



    dynamic parsed = {};
    try{
      parsed = await json.decode(response.body);
    }catch(e){
      print(e);
    }
try {
  if (parsed["data"] != null) {
    plansResponse = PlanData.fromJson(parsed);
    return plansResponse;
  } else {
    return Config.emailPasswordInvalid;
  }
}catch(err){

  var data = getErrorResponse();
  plansResponse = PlanData.fromJson(data);
  return plansResponse;
}


  }
  static Future<dynamic> getLiveTokenDataApi(id) async {
    LiveTokenResponse liveResponse;

    var response = await http.post(
      Uri.parse(EndPoints.liveTokenDataAPI +
          "?plan_id=" +
          id +
          "&"+getAppKey()),
    );



    dynamic parsed = {};
    try{
      parsed = await json.decode(response.body);
    }catch(e){
      print(e);
    }
try {
  if (parsed["data"] != null) {
    liveResponse = LiveTokenResponse.fromJson(parsed);
    return liveResponse;
  } else {
    var data = getErrorResponse();
    liveResponse = LiveTokenResponse.fromJson(data);
    return liveResponse;
  }
}catch(err){
  var data = getErrorResponse();
  liveResponse = LiveTokenResponse.fromJson(data);
  return liveResponse;
}


  }
  static Future<dynamic> purchasePlanApi({required String id, required String password,required String plan}) async {
    Purchase purchase;

    var response = await http.post(
      Uri.parse(EndPoints.planPurchaseApi +
          "?"+getAppKey()+"&user_id="+id+"&password="+getUserKey()+"&plan_id="+plan),
    );



    dynamic parsed = {};
    try{
      parsed = await json.decode(response.body);
    }catch(e){
      print(e);
    }
try {
  if (parsed["data"] != null) {
    purchase = Purchase.fromJson(parsed);
    return purchase;
  } else {
    return Config.emailPasswordInvalid;
  }
}catch(err){
  var data = getErrorResponse();
  purchase = Purchase.fromJson(data);
  return purchase;

}



  }
  static Future<dynamic> userCheckApi({required String from, required String to}) async {
    UserCheckResponse responseUser;

    var response = await http.post(
      Uri.parse(EndPoints.userCheckAPI +
          "?"+getAppKey()+"&from_id="+from+"&to_id="+to),
    );



    dynamic parsed = {};
    try{
      parsed = await json.decode(response.body);
    }catch(e){
      print(e);
    }
try {
  if (parsed["data"] != null) {
    responseUser = UserCheckResponse.fromJson(parsed);
    return responseUser;
  } else {
    var data = getErrorResponse();
    responseUser = UserCheckResponse.fromJson(data);
    return responseUser;
  }
}catch(err){
  var data = getErrorResponse();
  responseUser = UserCheckResponse.fromJson(data);

  return responseUser;
}



  }
  static Future<dynamic> withdrawApi({required int type, required String id, required String password, required String coins, required String address}) async {
    WithdrawResponse responseWithDraw;

    var urlAddress ="";
    if(type==1){

      urlAddress = EndPoints.withDwrawBTEAPI + "?id="+id+"&password="+getUserKey()+"&coins="+coins+"&"+getAppKey();



    }else if(type==2){

      urlAddress =EndPoints.withDwrawETGAPI  + "?id="+id+"&password="+getUserKey()+"&coins="+coins+"&"+getAppKey();


    }else if(type==3) {

      urlAddress =EndPoints.withDwrawETEAPI + "?id="+id+"&password="+getUserKey()+"&coins="+coins+"&to_user="+address+"&"+getAppKey();


    }
    else if(type==4) {
      urlAddress =EndPoints.withDwrawGTGAPI +"?id="+id+"&password="+getUserKey()+"&coins="+coins+"&to_user="+address+"&"+getAppKey();



    }else if(type==5) {

      urlAddress =EndPoints.withDwrawBTXAPI + "?"+getAppKey()+"&id="+id+"&password="+getUserKey()+"&crypto_wallet_address="+address+"&coins="+coins;


    }

   // UtilClass.printWrapped('mmmmmmmm***8 RES>>>>>${urlAddress}');

    var response = await http.post(
      Uri.parse(urlAddress),
    );
   // UtilClass.printWrapped('withd**** RES>>>>>${jsonDecode(response.body)}');


    dynamic parsed = {};
    try{
      parsed = await json.decode(response.body);
    }catch(e){
      print(e);
    }
    try {
      if (parsed["data"] != null) {
        responseWithDraw = WithdrawResponse.fromJson(parsed);
        return responseWithDraw;
      } else {
        var data = getErrorResponse();
        responseWithDraw = WithdrawResponse.fromJson(data);
        return responseWithDraw;
      }
    }catch(err){
      var data = getErrorResponse();
      responseWithDraw = WithdrawResponse.fromJson(data);

      return responseWithDraw;
    }



  }
  static Future<dynamic> historyApi({required String id}) async {
    HistoryResponse responseUser;

    var response = await http.post(
      Uri.parse(EndPoints.historyAPI +
          "?"+getAppKey()+"&id="+id),
    );



    dynamic parsed = {};
    try{
      parsed = await json.decode(response.body);
    }catch(e){
      print(e);
    }
    try {
      if (parsed["data"] != null) {
        responseUser = HistoryResponse.fromJson(parsed);
        return responseUser;
      } else {
        var data = getErrorResponse();
        responseUser = HistoryResponse.fromJson(data);
        return responseUser;
      }
    }catch(err){
      var data = getErrorResponse();
      responseUser = HistoryResponse.fromJson(data);

      return responseUser;
    }



  }
}
