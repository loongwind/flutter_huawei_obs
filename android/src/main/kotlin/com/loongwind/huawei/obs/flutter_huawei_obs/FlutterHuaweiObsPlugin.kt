package com.loongwind.huawei.obs.flutter_huawei_obs

import android.os.Handler
import android.os.Looper
import androidx.annotation.NonNull
import com.obs.services.ObsClient
import com.obs.services.model.PutObjectResult

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.io.ByteArrayInputStream
import java.io.File
import kotlin.concurrent.thread

/** FlutterHuaweiObsPlugin */
class FlutterHuaweiObsPlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private lateinit var endPoint: String
  private lateinit var obsClient : ObsClient
  private val uiHandler : Handler = Handler(Looper.getMainLooper())

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_huawei_obs")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when (call.method) {
        "getPlatformVersion" -> {
          result.success("Android ${android.os.Build.VERSION.RELEASE}")
        }
        "initConfig" -> {
          config(call, result)
        }
        "putObject" -> {
          putObject(call, result)
        }
        "putFile" -> {
          putFile(call, result)
        }
        else -> {
          result.notImplemented()
        }
    }
  }


  private fun config(call: MethodCall, result: Result){
    val endPoint : String? = call.argument("endPoint")
    val accessKey:String? = call.argument("accessKey")
    val secretKey : String? = call.argument("secretKey")
    val securityToken : String? = call.argument("securityToken")
    print("endPoint : $endPoint  accessKey:$accessKey  secretKey:$secretKey   securityToken:$securityToken" )
    if(endPoint == null || accessKey == null || secretKey == null || securityToken == null){
      result.error("-1", "accessKey or secretKey or endPoint  or securityToken is null", null)
      return
    }

    thread{
      try {
        obsClient = ObsClient(accessKey, secretKey, securityToken, endPoint)
        uiHandler.post {
          result.success("success")
        }
      } catch (e: Exception) {
        e.printStackTrace()
        uiHandler.post{
          result.error("-2", e.message, null)
        }
      }
    }
  }

  private fun putObject(call: MethodCall, result: Result){
    val bucketname : String? = call.argument("bucketname")
    val objectname:String? = call.argument("objectname")
    val objectContent : String? = call.argument("objectContent")
    if(bucketname == null || objectname == null || objectContent == null ){
      result.error("-1", "bucketname or objectname or objectContent is null", null)
      return
    }
    thread {
      try {
        val objectResult = obsClient.putObject(bucketname, objectname, ByteArrayInputStream(objectContent.toByteArray()))
        uiHandler.post {
          result.success(objectResult.objectUrl)
        }
      } catch (e: Exception) {
        e.printStackTrace()
        uiHandler.post {
          result.error("-3", e.message, null)
        }
      }
    }
  }
  private fun putFile(call: MethodCall, result: Result){
    val bucketname : String? = call.argument("bucketname")
    val objectname:String? = call.argument("objectname")
    val filePath : String? = call.argument("filePath")
    if(bucketname == null || objectname == null || filePath == null ){
      result.error("-1", "bucketname or objectname or filePath is null", null)
      return
    }
    thread {
      try {
        val objectResult = obsClient.putObject(bucketname, objectname, File(filePath))
        uiHandler.post {
          result.success(mapOf(
            "url" to objectResult.objectUrl
          ))
        }
      } catch (e: Exception) {
        e.printStackTrace()
        uiHandler.post {
          result.error("-3", e.message, null)
        }
      }
    }
  }



  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
