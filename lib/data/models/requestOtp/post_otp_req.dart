class PostOtpReq {
  String? email;

  PostOtpReq({this.email});

  PostOtpReq.fromJson(Map<String, dynamic> json) {
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (email != null) {
      data['email'] = email;
    }
    return data;
  }
}
