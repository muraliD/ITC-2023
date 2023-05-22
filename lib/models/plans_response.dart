class PlansResponse {
   Status? status;
   Data? data;

  PlansResponse({
    this.status,
    this.data,
  });


  PlansResponse.fromJson(Map<String, dynamic> json) {
    status =
    json['status'] != null ? new Status.fromJson(json['status']) : null;
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  // PlansResponse.fromJson(Map<String, dynamic> json)
  //     : status = (json['status'] as Map<String,dynamic>?) != null ? Status.fromJson(json['status'] as Map<String,dynamic>) : null,
  //       data = (json['data'] as Map<String,dynamic>?) != null ? Data.fromJson(json['data'] as Map<String,dynamic>) : null;

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
  final List<Plan>? plan;

  Data({
    this.records,
    this.plan,
  });

  Data.fromJson(Map<String, dynamic> json)
      : records = (json['records'] as Map<String,dynamic>?) != null ? Records.fromJson(json['records'] as Map<String,dynamic>) : null,
        plan = (json['plan'] as List?)?.map((dynamic e) => Plan.fromJson(e as Map<String,dynamic>)).toList();

  Map<String, dynamic> toJson() => {
    'records' : records?.toJson(),
    'plan' : plan?.map((e) => e.toJson()).toList()
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

class Plan {
  final int? id;
  final String? name;
  final String? price;
  final String? priceInCurrency;
  final String? currencySymbol;
  final String? archCoins;
  final int? status;

  Plan({
    this.id,
    this.name,
    this.price,
    this.priceInCurrency,
    this.currencySymbol,
    this.archCoins,
    this.status,
  });

  Plan.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        name = json['name'] as String?,
        price = json['price'] as String?,
        priceInCurrency = json['price_in_currency'] as String?,
        currencySymbol = json['currency_symbol'] as String?,
        archCoins = json['arch_coins'] as String?,
        status = json['status'] as int?;

  Map<String, dynamic> toJson() => {
    'id' : id,
    'name' : name,
    'price' : price,
    'price_in_currency' : priceInCurrency,
    'currency_symbol' : currencySymbol,
    'arch_coins' : archCoins,
    'status' : status
  };
}


class Attempts {
  final String? message;

  Attempts({
    this.message,
  });

  Attempts.fromJson(Map<String, dynamic> json)
      : message = json['message'] as String?;

  Map<String, dynamic> toJson() => {
    'message' : message
  };
}