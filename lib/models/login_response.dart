class LoginResponse {
  Status? status;
  Data? data;

  LoginResponse({this.status, this.data});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    status =
    json['status'] != null ? new Status.fromJson(json['status']) : null;
    if(json['status']['type'] == "Success"){
      data = json['data'] != null ? new Data.fromJson(json['data']) : null;

    }else{
      data = null;

    }

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.status != null) {
      data['status'] = this.status!.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Status {
  String? type;
  String? message;
  int? code;
  String? error;

  Status({this.type, this.message, this.code, this.error});

  Status.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    message = json['message'];
    code = json['code'];
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['message'] = this.message;
    data['code'] = this.code;
    data['error'] = this.error;
    return data;
  }
}

class Data {
  String? status;
  UserL? user;

  Data({this.status, this.user});

  Data.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    user = json['user'] != null ? new UserL.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class UserL {
  int? id;
  String? name;
  int? plan;
  String? referralCode;
  String? plan_name;
  int? referredBy;
  String? mobile;
  String? countryCode;
  String? profilePic;
  String? email;
  String? password;
  int? passwordChanged;
  String? app_security_key;
  String? user_security_key;

  UserL(
      { this.password,
        this.id,
        this.name,
        this.plan,
        this.plan_name,
        this.referralCode,
        this.referredBy,
        this.mobile,
        this.countryCode,
        this.profilePic,
        this.email,
        this.passwordChanged,
        this.app_security_key,
        this.user_security_key

      });

  UserL.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    plan = json['plan'];
    plan_name = json['plan_name'];
    referralCode = json['referral_code'];
    referredBy = json['referred_by'];
    mobile = json['mobile'];
    countryCode = json['country_code'];
    profilePic = json['profile_pic'];
    email = json['email'];
    passwordChanged = json['password_changed'];
    password = json['password'];
    app_security_key = json['app_security_key'];
    user_security_key = json['user_security_key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['plan'] = this.plan;
    data['plan_name'] = this.plan_name;
    data['referral_code'] = this.referralCode;
    data['referred_by'] = this.referredBy;
    data['mobile'] = this.mobile;
    data['country_code'] = this.countryCode;
    data['profile_pic'] = this.profilePic;
    data['email'] = this.email;
    data['password'] = this.password;
    data['password_changed'] = this.passwordChanged;
    data['app_security_key'] = this.app_security_key;
    data['user_security_key'] = this.user_security_key;
    return data;
  }
}