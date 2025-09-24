class PostOtpResp {
  bool? success;
  String? message;
  String? email;

  PostOtpResp({this.success, this.message, this.email});

  PostOtpResp.fromJson(Map<String, dynamic> json) {
    if (json['success'] == null) {
      success = false;
    } else {
      success = json['success'];
    }
    if (json['message'] != null) {
      message = json['message'];
    }
    if (json['email'] != null) {
      email = json['email'];
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (success != null) {
      data['success'] = success;
    }
    if (message != null) {
      data['message'] = message;
    }
    if (email != null) {
      data['email'] = email;
    }
    return data;
  }
}
