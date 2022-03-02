class LoginEntity {
  LoginEntity({
      this.code, 
      this.message, 
      this.data,});

  LoginEntity.fromJson(dynamic json) {
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  int? code;
  String? message;
  Data? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['code'] = code;
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    return map;
  }

}

class Data {
  Data({
      this.userInfo,});

  Data.fromJson(dynamic json) {
    userInfo = json['userInfo'] != null ? UserInfo.fromJson(json['userInfo']) : null;
  }
  UserInfo? userInfo;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (userInfo != null) {
      map['userInfo'] = userInfo?.toJson();
    }
    return map;
  }

}

class UserInfo {
  UserInfo({
      this.name, 
      this.nickName, 
      this.headImg, 
      this.mobile, 
      this.userType, 
      this.token,});

  UserInfo.fromJson(dynamic json) {
    name = json['name'];
    nickName = json['nickName'];
    headImg = json['headImg'];
    mobile = json['mobile'];
    userType = json['userType'];
    token = json['token'];
  }
  String? name;
  String? nickName;
  dynamic headImg;
  String? mobile;
  int? userType;
  String? token;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['nickName'] = nickName;
    map['headImg'] = headImg;
    map['mobile'] = mobile;
    map['userType'] = userType;
    map['token'] = token;
    return map;
  }

}