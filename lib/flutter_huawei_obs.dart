
import 'dart:async';

import 'package:flutter/services.dart';

class FlutterHuaweiObs {
  static const MethodChannel _channel = MethodChannel('flutter_huawei_obs');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }


  static Future<String?> initConfig(
      {required String endPoint,
        required String accessKey,
        required String secretKey,
        required String securityToken}) async{
    final String? isSuccess = await _channel.invokeMethod('initConfig', {
      "endPoint" :endPoint,
      "accessKey" : accessKey,
      "secretKey" : secretKey,
      "securityToken" : securityToken
    });
    return isSuccess;
  }

  static Future<String?> putObject(
      {required String bucketname,
        required String objectname,
        required String objectContent}) async{
    final String? isSuccess = await _channel.invokeMethod('putObject', {
      "bucketname" : bucketname,
      "objectname":objectname,
      "objectContent" : objectContent
    });
    return isSuccess;
  }

  static Future<String?> putFile(
      {required String bucketname,
        required String objectname,
        required String filePath}) async{
    dynamic result = await _channel.invokeMethod('putFile', {
      "bucketname" : bucketname,
      "objectname":objectname,
      "filePath" : filePath
    });
    return result?["url"];
  }

}
