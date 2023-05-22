class PriceResponse {
  Status? status;
  Data? data;

  PriceResponse({this.status, this.data});

  PriceResponse.fromJson(Map<String, dynamic> json) {
    status =
    json['status'] != null ? new Status.fromJson(json['status']) : null;
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
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
  TokenInfo? tokenInfo;

  Data({this.tokenInfo});

  Data.fromJson(Map<String, dynamic> json) {
    tokenInfo = json['token_info'] != null
        ? new TokenInfo.fromJson(json['token_info'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.tokenInfo != null) {
      data['token_info'] = this.tokenInfo!.toJson();
    }
    return data;
  }
}

class TokenInfo {
  String? symbol;
  String? address;
  int? decimals;
  String? name;
  String? value;
  String? valueShownIn;

  TokenInfo(
      {this.symbol,
        this.address,
        this.decimals,
        this.name,
        this.value,
        this.valueShownIn});

  TokenInfo.fromJson(Map<String, dynamic> json) {
    symbol = json['symbol'];
    address = json['address'];
    decimals = json['decimals'];
    name = json['name'];
    value = json['value'];
    valueShownIn = json['value_shown_in'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['symbol'] = this.symbol;
    data['address'] = this.address;
    data['decimals'] = this.decimals;
    data['name'] = this.name;
    data['value'] = this.value;
    data['value_shown_in'] = this.valueShownIn;
    return data;
  }
}
