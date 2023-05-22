class WithdrawResponse {
   Status? status;
   Data? data;

  WithdrawResponse({
    this.status,
    this.data,
  });

  WithdrawResponse.fromJson(Map<String, dynamic> json){
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
  final Transaction? transaction;

  Data({
    this.message,
    this.transaction,
  });

  Data.fromJson(Map<String, dynamic> json)
      : message = json['message'] as String?,
        transaction = (json['transaction'] as Map<String,dynamic>?) != null ? Transaction.fromJson(json['transaction'] as Map<String,dynamic>) : null;

  Map<String, dynamic> toJson() => {
    'message' : message,
    'transaction' : transaction?.toJson()
  };
}

class Transaction {
  final String? status;
  final String? id;
  final String? type;
  final int? charges;
  final String? details;

  Transaction({
    this.status,
    this.id,
    this.type,
    this.charges,
    this.details,
  });

  Transaction.fromJson(Map<String, dynamic> json)
      : status = json['status'] as String?,
        id = json['id'] as String?,
        type = json['type'] as String?,
        charges = json['charges'] as int?,
        details = json['details'] as String?;

  Map<String, dynamic> toJson() => {
    'status' : status,
    'id' : id,
    'type' : type,
    'charges' : charges,
    'details' : details
  };
}