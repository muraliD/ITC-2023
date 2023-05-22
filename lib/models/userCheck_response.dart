class UserCheckResponse {
   Status? status;
   Data? data;

  UserCheckResponse({
    this.status,
    this.data,
  });

  UserCheckResponse.fromJson(Map<String, dynamic> json){
    status =
    json['status'] != null ? new Status.fromJson(json['status']) : null;
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() =>
      {'status': status?.toJson(), 'data': data?.toJson()};
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

  Map<String, dynamic> toJson() =>
      {'type': type, 'message': message, 'code': code, 'error': error};
}

class Data {
  final String? toUser;

  Data({
    this.toUser,
  });

  Data.fromJson(Map<String, dynamic> json)
      : toUser = json['to_user'] as String?;

  Map<String, dynamic> toJson() => {'to_user': toUser};
}
