class PlanData {
   Status? status;
   Data? data;

  PlanData({
    this.status,
    this.data,
  });

  PlanData.fromJson(Map<String, dynamic> json){
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
  final PlanI? plan;

  Data({
    this.plan,
  });

  Data.fromJson(Map<String, dynamic> json)
      : plan = (json['plan'] as Map<String,dynamic>?) != null ? PlanI.fromJson(json['plan'] as Map<String,dynamic>) : null;

  Map<String, dynamic> toJson() => {
    'plan' : plan?.toJson()
  };
}

class PlanI {
  final int? id;
  final String? name;
  final String? price;
  final String? priceInCurrency;
  final String? currencySymbol;
  final String? archCoins;
  final int? status;

  PlanI({
    this.id,
    this.name,
    this.price,
    this.priceInCurrency,
    this.currencySymbol,
    this.archCoins,
    this.status,
  });

  PlanI.fromJson(Map<String, dynamic> json)
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