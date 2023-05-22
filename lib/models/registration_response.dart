class RegistrationResponse {
   Status? status;
   Data? data;

  RegistrationResponse({
    this.status,
    this.data,
  });

  RegistrationResponse.fromJson(Map<String, dynamic> json) {
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
  final User? user;
  final String? message;

  Data({
    this.user,
    this.message,
  });

  Data.fromJson(Map<String, dynamic> json)
      : user = (json['user'] as Map<String,dynamic>?) != null ? User.fromJson(json['user'] as Map<String,dynamic>) : null,
        message = json['message'] as String?;

  Map<String, dynamic> toJson() => {
    'user' : user?.toJson(),
    'message' : message
  };
}

class User {
  final String? email;

  User({
    this.email,
  });

  User.fromJson(Map<String, dynamic> json)
      : email = json['email'] as String?;

  Map<String, dynamic> toJson() => {
    'email' : email
  };
}