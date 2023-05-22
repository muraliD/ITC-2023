class HistoryResponse {
   Status? status;
   Data? data;

  HistoryResponse({
    this.status,
    this.data,
  });

  HistoryResponse.fromJson(Map<String, dynamic> json){
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
  final Records? records;
  final List<UserH>? user;

  Data({
    this.records,
    this.user,
  });

  Data.fromJson(Map<String, dynamic> json)
      : records = (json['records'] as Map<String,dynamic>?) != null ? Records.fromJson(json['records'] as Map<String,dynamic>) : null,
        user = (json['user'] as List?)?.map((dynamic e) => UserH.fromJson(e as Map<String,dynamic>)).toList();

  Map<String, dynamic> toJson() => {
    'records' : records?.toJson(),
    'user' : user?.map((e) => e.toJson()).toList()
  };
}

class Records {
  final int? count;
  final String? remarks;

  Records({
    this.count,
    this.remarks,
  });

  Records.fromJson(Map<String, dynamic> json)
      : count = json['count'] as int?,
        remarks = json['remarks'] as String?;

  Map<String, dynamic> toJson() => {
    'count' : count,
    'remarks' : remarks
  };
}

class UserH {
  final int? id;
  final String? ipAddress;
  final String? browserName;
  final String? platformName;
  final String? dateTime;

  UserH({
    this.id,
    this.ipAddress,
    this.browserName,
    this.platformName,
    this.dateTime,
  });

  UserH.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        ipAddress = json['ip_address'] as String?,
        browserName = json['browser_name'] as String?,
        platformName = json['platform_name'] as String?,
        dateTime = json['date_time'] as String?;

  Map<String, dynamic> toJson() => {
    'id' : id,
    'ip_address' : ipAddress,
    'browser_name' : browserName,
    'platform_name' : platformName,
    'date_time' : dateTime
  };
}