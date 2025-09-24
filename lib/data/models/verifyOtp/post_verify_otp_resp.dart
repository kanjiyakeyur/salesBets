
import '../user/user.dart';

class PostVerifyOtpResp {
  bool? success;
  String? message;
  User? user;
  String? token;

  PostVerifyOtpResp({this.success, this.message, this.user, this.token});

  PostVerifyOtpResp.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if(json['data'] != null){
      var data = json['data'];
      if(data['user'] != null) {
        user = User.fromJson(data['user']);
        token = data['token'];
      }
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
    if (user != null) {
      data['user'] = user?.toJson();
    }
    if (token != null) {
      data['token'] = token;
    }
    return data;
  }
}

