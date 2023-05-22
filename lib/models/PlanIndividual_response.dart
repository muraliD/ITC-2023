class IndividualPlans {
   Status? status;
   Data? data;

  IndividualPlans({
    this.status,
    this.data,
  });

  IndividualPlans.fromJson(Map<String, dynamic> json) {
    status =
    json['status'] != null ? new Status.fromJson(json['status']) : null;
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }


  Map<String, dynamic> toJson() => {
    'status' : status?.toJson(),
    'data' : data?.toJson()
  };
}

class Status {
  final String? type;
  final String? message;
  final int? code;
  final String? error;

  Status({
    this.type,
    this.message,
    this.code,
    this.error,
  });

  Status.fromJson(Map<String, dynamic> json)
      : type = json['type'] as String?,
        message = json['message'] as String?,
        code = json['code'] as int?,
        error = json['error'] as String?;

  Map<String, dynamic> toJson() => {
    'type' : type,
    'message' : message,
    'code' : code,
    'error' : error
  };
}

class Data {
  final List<User1>? user;

  Data({
    this.user,
  });

  Data.fromJson(Map<String, dynamic> json)
      : user = (json['user'] as List?)?.map((dynamic e) => User1.fromJson(e as Map<String,dynamic>)).toList();

  Map<String, dynamic> toJson() => {
    'user' : user?.map((e) => e.toJson()).toList()
  };
}

class User1 {
  final int? id;
  final int? plan;
  final int? selfToken;
  final int? childTokens;
  final int? childTokenStatus;
  final String? childLtgAmt;
  final dynamic childUserId;
  final dynamic childPurchasedDateTime;
  final int? selfTokenStatus;
  final String? selfPurchasedDateTime;
  final int? reActivatedCount;

  User1({
    this.id,
    this.plan,
    this.selfToken,
    this.childTokens,
    this.childTokenStatus,
    this.childLtgAmt,
    this.childUserId,
    this.childPurchasedDateTime,
    this.selfTokenStatus,
    this.selfPurchasedDateTime,
    this.reActivatedCount,
  });

  User1.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        plan = json['plan'] as int?,
        selfToken = json['self_token'] as int?,
        childTokens = json['child_tokens'] as int?,
        childTokenStatus = json['child_token_status'] as int?,
        childLtgAmt = json['child_ltg_amt'] as String?,
        childUserId = json['child_user_id'],
        childPurchasedDateTime = json['child_purchased_date_time'],
        selfTokenStatus = json['self_token_status'] as int?,
        selfPurchasedDateTime = json['self_purchased_date_time'] as String?,
        reActivatedCount = json['re_activated_count'] as int?;


  Map<String, dynamic> toJson() => {
    'id' : id,
    'plan' : plan,
    'self_token' : selfToken,
    'child_tokens' : childTokens,
    'child_token_status' : childTokenStatus,
    'child_ltg_amt' : childLtgAmt,
    'child_user_id' : childUserId,
    'child_purchased_date_time' : childPurchasedDateTime,
    'self_token_status' : selfTokenStatus,
    'self_purchased_date_time' : selfPurchasedDateTime,
    're_activated_count' : reActivatedCount
  };
}