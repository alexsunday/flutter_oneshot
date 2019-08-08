import 'package:flutter/material.dart';
import 'dart:async';
import 'package:permission_handler/permission_handler.dart';

import 'package:flutter/services.dart';
import 'package:flutter_oneshot/flutter_oneshot.dart';

void main() {
  requestPermission().then((_){
    print(DateTime.now());
    FlutterOneshot.start("wifi", "password", 30).then((v){
      print(DateTime.now());
      print(v);
    });
  });

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await FlutterOneshot.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Running on: $_platformVersion\n'),
        ),
      ),
    );
  }
}

Future<bool> requestPermission() async {
  // 申请权限
  Map<PermissionGroup, PermissionStatus> permissions =
  await PermissionHandler().requestPermissions([
    PermissionGroup.location,
  ]);
  // 申请结果
  PermissionStatus permission = await PermissionHandler()
      .checkPermissionStatus(PermissionGroup.location);
  if (permission == PermissionStatus.granted) {
    return true;
  } else {
//      提示失败！
    return false;
  }
}
