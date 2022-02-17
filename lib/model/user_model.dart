import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

const String KEY_USER_INFO = "KEY_USER_INFO";

class UserInfoModel {

  String? mobile;
  String? nickName;
  String? password;

  UserInfoModel(
      { this.mobile,
       this.nickName,
       this.password});
  
  static void saveData(Map<String, dynamic> val) {
    SharedPreferences.getInstance().then((value) => value.setString(KEY_USER_INFO, json.encode(val)));
  }

  static Future<UserInfoModel?> data() async {
    final share = await SharedPreferences.getInstance();
    final str = share.getString(KEY_USER_INFO);
    if(str == null) return null;
    return UserInfoModel.fromJson(json.decode(str));
  }

  UserInfoModel.fromJson(Map<String, dynamic> json) {

    mobile = json['mobile'];
    nickName = json['nickName'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mobile'] = this.mobile;
    data['nickName'] = this.nickName;
    data['password'] = this.password;
    return data;
  }
}
