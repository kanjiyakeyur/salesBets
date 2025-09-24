
class User {
  String? id;
  String? email;
  String? name;
  String? profilePic;
  bool? isEmailVerified;
  String? createdAt;

  User({
    this.id,
    this.email,
    this.name,
    this.profilePic,
    this.isEmailVerified,
    this.createdAt,
  });

  User.fromJson(Map<String, dynamic> json) {
    if(json['id'] != null) {
      id = json['id'];
    }
    if(json['email'] != null) {
      email = json['email'];
    }
    if(json['name'] != null) {
      name = json['name'];
    }
    if(json['profilePic'] != null) {
      profilePic = json['profilePic'];
    }
    if(json['isEmailVerified'] != null){
      isEmailVerified = json['isEmailVerified'];
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (id != null) {
      data['id'] = id;
    }
    if (email != null) {
      data['email'] = email;
    }
    if (name != null) {
      data['name'] = name;
    }
    if (profilePic != null) {
      data['profilePic'] = profilePic;
    }
    if (isEmailVerified != null) {
      data['isEmailVerified'] = isEmailVerified;
    }
    if (createdAt != null) {
      data['createdAt'] = createdAt;
    }
    return data;
  }
}