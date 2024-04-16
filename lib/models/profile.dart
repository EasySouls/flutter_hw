class Profile {
  String? uid;
  String? name;
  String? email;
  String? profilePicUrl;

  Profile({this.uid, this.name, this.email, this.profilePicUrl});

  Profile.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    name = json['name'];
    email = json['email'];
    profilePicUrl = json['profilePicUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uid'] = uid;
    data['name'] = name;
    data['email'] = email;
    data['profilePicUrl'] = profilePicUrl;
    return data;
  }
}
