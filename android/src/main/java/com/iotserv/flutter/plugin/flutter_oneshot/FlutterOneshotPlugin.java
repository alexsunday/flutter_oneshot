package com.iotserv.flutter.plugin.flutter_oneshot;

import android.app.Activity;
import android.net.wifi.WifiManager;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import com.winnermicro.smartconfig.*;

/** FlutterOneshotPlugin */
public class FlutterOneshotPlugin implements MethodCallHandler {
  private int timeout = 60;//miao
  private Activity activity;
  private MethodChannel channel;

  private String ssid;
  private String password = null;
  private IOneShotConfig oneshotConfig = null;
  private SmartConfigFactory factory = null;

  public FlutterOneshotPlugin(Activity activity,MethodChannel channel) {
    this.activity = activity;
    this.channel = channel;
  }

  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "flutter_oneshot");
    channel.setMethodCallHandler(new FlutterOneshotPlugin(registrar.activity(),channel));
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    } else if (call.method.equals("start")){
      //参数获取
      ssid = call.argument("ssid");
      password = call.argument("password");
      try {
        timeout = call.argument("timeout");
      }catch (Exception e){
        e.printStackTrace();
        timeout = 30;
      }

      factory = new SmartConfigFactory();
      oneshotConfig = factory.createOneShotConfig(ConfigType.UDP);
      //      start config
      try {
        oneshotConfig.start(ssid, password, timeout, activity.getApplicationContext());
        result.success("success!");
      }
      catch (Exception e) {
        e.printStackTrace();
        result.error("Fail", "config wifi fail.", null);
      }
      finally{
        oneshotConfig.stop(	);
      }
    }
    else {
      result.notImplemented();
    }
  }

}
