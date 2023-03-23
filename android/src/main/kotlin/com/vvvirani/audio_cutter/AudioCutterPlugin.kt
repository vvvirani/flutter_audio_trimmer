package com.vvvirani.audio_cutter

import android.os.Build
import androidx.annotation.RequiresApi
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class AudioCutterPlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "vvvirani/audio_cutter")
        channel.setMethodCallHandler(this)
    }

    @RequiresApi(Build.VERSION_CODES.JELLY_BEAN_MR2)
    override fun onMethodCall(call: MethodCall, result: Result) {
        if (call.method == "trim") {

            val audioFilePath = call.argument<String?>("file_path")
            val outputFilePath = call.argument<String?>("output_path")
            val startTime = call.argument<Double?>("start_time")
            val endTime = call.argument<Double?>("end_time")

            if (audioFilePath != null && outputFilePath != null && startTime != null && endTime != null) {

                try {
                    result.success(audioFilePath)

                } catch (e: java.lang.Exception) {
                    result.error("failed", e.message, e.localizedMessage)
                }

            } else {
                result.error("missing_arguments", "Missing Arguments", null)
            }

        } else {
            result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
