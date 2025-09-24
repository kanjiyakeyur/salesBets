
class PostVerifyOtpReq {
  String? email;
  String? otp;

  PostVerifyOtpReq({this.email, this.otp});

  PostVerifyOtpReq.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    otp = json['otp'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (email != null) {
      data['email'] = email;
    }
    if (otp != null) {
      data['otp'] = otp;
    }
    return data;
  }
}

