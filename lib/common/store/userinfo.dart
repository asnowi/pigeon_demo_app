class UserInfo{
  String? phone;
  String? username;
  String? nickname;
  String? avatar;
  String? token;

  UserInfo({this.phone = "",this.username = "",this.nickname = "",this.avatar = "",this.token = ""});

  factory UserInfo.fromJson(Map<String, dynamic> json) =>
      UserInfo(
        phone: json["phone"],
        username: json["username"],
        nickname: json["nickname"],
        avatar: json["avatar"],
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
    "phone": phone,
    "username": username,
    "nickname": nickname,
    "avatar": avatar,
    "token": token,
  };
}