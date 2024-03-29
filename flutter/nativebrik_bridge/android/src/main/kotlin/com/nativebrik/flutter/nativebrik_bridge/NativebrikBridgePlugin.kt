package com.nativebrik.flutter.nativebrik_bridge

import android.content.Context
import com.nativebrik.sdk.Config

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import com.nativebrik.sdk.VERSION
import com.nativebrik.sdk.NativebrikClient
import kotlinx.coroutines.DelicateCoroutinesApi
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch

internal const val EMBEDDING_VIEW_ID = "nativebrik-embedding-view"
internal const val OVERLAY_VIEW_ID = "nativebrik-overlay-view"
internal const val EMBEDDING_PHASE_UPDATE_METHOD = "embedding-phase-update"
internal const val ON_EVENT_METHOD = "on-event"

/** NativebrikBridgePlugin */
class NativebrikBridgePlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private lateinit var context: Context
  private lateinit var manager: NativebrikBridgeManager

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    val messenger = flutterPluginBinding.binaryMessenger
    manager = NativebrikBridgeManager(messenger)
    context = flutterPluginBinding.applicationContext
    channel = MethodChannel(messenger, "nativebrik_bridge")
    channel.setMethodCallHandler(this)

    flutterPluginBinding.platformViewRegistry.registerViewFactory(
      OVERLAY_VIEW_ID,
      OverlayViewFactory(manager)
    )
    flutterPluginBinding.platformViewRegistry.registerViewFactory(
      EMBEDDING_VIEW_ID,
      NativeViewFactory(manager)
    )
  }

  @OptIn(DelicateCoroutinesApi::class)
  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
        "getNativebrikSDKVersion" -> {
          result.success(VERSION)
        }
        "connectClient" -> {
          val projectId = call.arguments as String
          if (projectId.isEmpty()) {
            result.success("no")
            return
          }
          val client = NativebrikClient(
              Config(
                  projectId,
                  onEvent = { it ->
                      this.channel.invokeMethod(ON_EVENT_METHOD, mapOf(
                          "name" to it.name,
                          "deepLink" to it.deepLink,
                          "payload" to it.payload?.map { prop ->
                              mapOf(
                                  "name" to prop.name,
                                  "value" to prop.value,
                                  "type" to prop.type,
                              )
                          }
                      ))
                  }
              ), context)
          this.manager.setNativebrikClient(client)
          result.success("ok")
        }
        "connectEmbedding" -> {
          val channelId = call.argument<String>("channelId") as String
          val id = call.argument<String>("id") as String
          this.manager.connectEmbedding(channelId, id)
          result.success("ok")
        }
        "disconnectEmbedding" -> {
          val channelId = call.arguments as String
          this.manager.disconnectEmbedding(channelId)
          result.success("ok")
        }
        "connectRemoteConfig" -> {
          val channelId = call.argument<String>("channelId") as String
          val id = call.argument<String>("id") as String
          GlobalScope.launch(Dispatchers.IO) {
            manager.connectRemoteConfig(channelId, id).onSuccess {
              result.success(it)
            }.onFailure {
              result.success("failed")
            }
          }
        }
        "disconnectRemoteConfig" -> {
          val channelId = call.arguments as String
          this.manager.disconnectRemoteConfig(channelId)
          result.success("ok")
        }
        "getRemoteConfigValue" -> {
          val channelId = call.argument<String>("channelId") as String
          val key = call.argument<String>("key") as String
          val value = this.manager.getRemoteConfigValue(channelId, key)
          result.success(value)
        }
        "connectEmbeddingInRemoteConfigValue" -> {
          val channelId = call.argument<String>("channelId") as String
          val embeddingChannelId = call.argument<String>("embeddingChannelId") as String
          val key = call.argument<String>("key") as String
          this.manager.connectEmbeddingInRemoteConfigValue(channelId, key, embeddingChannelId)
          result.success("ok")
        }
        "dispatch" -> {
          val event = call.arguments as String
          this.manager.dispatch(event)
          result.success("ok")
        }
        else -> {
          result.notImplemented()
        }
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
