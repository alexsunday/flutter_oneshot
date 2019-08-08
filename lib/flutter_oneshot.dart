import 'dart:async';

import 'package:flutter/services.dart';

class FlutterOneshot {
  static const MethodChannel _channel =
      const MethodChannel('flutter_oneshot');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future start(String ssid, String pass, int timeout) async {
    try {
      Map<String, dynamic> rm = new Map<String, dynamic>.from(await _channel.invokeMethod('start', {"ssid": ssid, "pass": pass, "timeout": timeout}));
      return rm;
    } catch(err){
      print("Error===, $err");
      return null;
    }

  }
}
