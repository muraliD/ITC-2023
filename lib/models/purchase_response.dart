class Purchase {
   Status? status;
   Data? data;

  Purchase({
    this.status,
    this.data,
  });

  Purchase.fromJson(Map<String, dynamic> json) {
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
  final String? message;
  final PlanPurchase? plan;

  Data({
    this.message,
    this.plan,
  });

  Data.fromJson(Map<String, dynamic> json)
      : message = json['message'] as String?,
        plan = (json['Plan'] as Map<String,dynamic>?) != null ? PlanPurchase.fromJson(json['Plan'] as Map<String,dynamic>) : null;

  Map<String, dynamic> toJson() => {
    'message' : message,
    'Plan' : plan?.toJson()
  };
}

class PlanPurchase {
  final String? details;

  PlanPurchase({
    this.details,
  });

  PlanPurchase.fromJson(Map<String, dynamic> json)
      : details = json['details'] as String?;

  Map<String, dynamic> toJson() => {
    'details' : details
  };
}