import 'dart:convert';
import 'dart:io';


import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../appconst/const.dart';
import '../util/event_bus.dart';
part 'network.api.dart';

enum HTTPMETHOD {
   GET,
   POST,
   PUT,
   DELETE
}

// const String _Host = "http://d39zs9rlff2e2c.cloudfront.net:8079/";
// const String _Host = "http://api.0bas7l.cn/";
const String _Host = "https://api.migoap.xyz/";
const String _Host_test = "http://93.179.126.85:8079/";
// const String _Host_test = "http://192.168.0.112:8097/";

class Networktool {
  
  static const String baseURL = AppConst.APP_IS_RELEASE ? _Host : _Host_test;
  static request(
    String url,
    {
      HTTPMETHOD method = HTTPMETHOD.POST,
      Map<String, dynamic>? params,
      Function? success,
      bool jsonbody = true,
      Function(String msg)? fail,
      Function? finaly
    }) async {

      // 判断网络
    var connectivityResult = await (new Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {

    } else if (connectivityResult == ConnectivityResult.wifi) {
      
    } else if (connectivityResult == ConnectivityResult.none){
      return EasyLoading.showError("当前网络信号不佳");
    }
    
    Response? response;
    String temp = baseURL;
    if(!AppConst.APP_IS_RELEASE) {
      // if(url.startsWith("otc/")) {
      //   url = url.replaceFirst("otc/", "");
      // }
      // if(url.startsWith("user/")) {
      //   url = url.replaceFirst("user/", "/");
      // }
    }
    url = temp + url;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String languageStr = prefs.getString('languageCode') ?? "cn";
    if(languageStr == "zh") languageStr = "cn";
    print("api = $url, param = ${json.encode(params)}, method:$method");
    SharedPreferences share = await SharedPreferences.getInstance();
    String? token = share.getString(AppConst.KEY_user_token);

    Options options = Options(contentType: "application/json");

    if(token != null){
      print("token = $token");
      options = Options(
          contentType: "application/json",
          headers: {"token": token, "lang": languageStr}
      );
    }

    try {
      switch (method) {
        case HTTPMETHOD.POST:
          if(jsonbody) {
            response = await Dio().post(url, data: json.encode(params), options: options);
          } else {
            FormData formData = FormData.fromMap(params!);
            response = await Dio().post(url, data: formData, options: options);
          }
          break;
        case HTTPMETHOD.GET:
          if(params == null) params = {};
          response = await Dio().get(url, queryParameters: params, options: options);
          break;
        case HTTPMETHOD.PUT:
          response = await Dio().put(url, data: params, options: options);
          break;
        case HTTPMETHOD.DELETE:
          response = await Dio().delete(url, data: params,options: options);
          break;
        default:
      }
    } catch (e) {
      if(finaly != null) finaly();
      print(e.toString());
      if(fail != null)fail("您目前的网络不佳或服务器目前过于繁忙，建议切换流量或WIFI，再次尝试登录");
    }
    

    if(finaly != null) finaly();
    int? code = response!.statusCode;
    print("$code =======> $url");
    if(code == 200) {
      print("jsondata =====> ${json.encode(response.data)}");
      if(response.data["code"] != 200) {
        if(fail != null)fail(response.data["msg"]);
        if(response.data["code"] == 401) {
          SharedPreferences.getInstance().then((value) => value.clear());// 清楚用户数据
          EventBus.instance!.commit(EventKeys.Login, null);
        } else {
          if(fail != null)fail(response.data["msg"]);
        }
      } else {
        if(success != null) success(response.data);
      }
      
    } else {
      if(fail != null) {
        if(response.data is Map) {
          fail(response.data["msg"].toString());
        } else {
          // fail(response.toString());
          fail("您目前的网络不佳或服务器目前过于繁忙，建议切换流量或WIFI，再次尝试登录");
        }
      }
    }
  }





  // 下载图片到本地
  static downloadImage(String url, {Function(int count, int total)? progress,Function(dynamic)? success}) async {
    var connectivityResult = await (new Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {

    } else if (connectivityResult == ConnectivityResult.wifi) {
      
    } else if (connectivityResult == ConnectivityResult.none){
      return EasyLoading.showError("当前网络信号不佳");
    }
    var response = await Dio().get(url, onReceiveProgress:progress, options: Options(responseType: ResponseType.bytes));
    if(success != null) success(response.data);
  }


  // 上传单个文件
  static uploadImage(
    String url, 
    File file, 
    {HTTPMETHOD method = HTTPMETHOD.POST, 
    Map<String,dynamic>? params,
    Function? success,
    Function(String msg)? fail,
    Function? finaly
  }) async {

    var connectivityResult = await (new Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {

    } else if (connectivityResult == ConnectivityResult.wifi) {
      
    } else if (connectivityResult == ConnectivityResult.none){
      return EasyLoading.showError("当前网络信号不佳");
    }
    
    Response response;
    url = baseURL + url;

    SharedPreferences share = await SharedPreferences.getInstance();
    String? token = share.getString(AppConst.KEY_user_token);

    Options options = Options();
    if(params == null) params = {};
    if(token != null){
      options = Options(
        contentType: "multipart/form-data",
      );
    }

    final fil = await MultipartFile.fromFile(file.path);
    // final base64data = await Tool.image2Base64(file);
    params["files"] = fil;
    FormData formData = FormData.fromMap(params);
    
    try{
      response = await Dio().post(url, data: formData, options: options);
    } catch (e) {
      // fail("您目前的网络不佳，建议切换流量或WIFI，再次尝试登录");
      if(fail != null)fail("您目前的网络不佳或服务器目前过于繁忙，建议切换流量或WIFI，再次尝试登录");
      return;
    }
    

    if(finaly != null) finaly();

    int? code = response.statusCode;
    if(code == 200) {
      print(response.data);
      // if(success != null) success(json.decode(response.data.toString()));
      if(success != null) success(response.data);
    } else {
      if(fail != null) {
        if(response.data is Map) {
          fail(response.data["msg"].toString());
        } else {
          // fail(response.toString());
          fail("您目前的网络不佳或服务器目前过于繁忙，建议切换流量或WIFI，再次尝试登录");
        }
      }
    }
  }
}
