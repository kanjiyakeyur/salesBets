class BaseModelResp {
  String? message;
  bool? success;

  BaseModelResp({this.success, this.message});

  BaseModelResp.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (message != null) {
      data['message'] = message;
    }
    if(success != null) {
      data['success'] = success;
    }
    return data;
  }
}

enum ApiStatus {
  none,
  waiting,
  complete,
  failed,
}