package com.vvvirani.flutter_audio_trimmer

import android.util.Log
import com.github.hiteshsondhi88.libffmpeg.FFmpeg
import com.github.hiteshsondhi88.libffmpeg.FFmpegExecuteResponseHandler
import com.github.hiteshsondhi88.libffmpeg.FFmpegLoadBinaryResponseHandler
import com.github.hiteshsondhi88.libffmpeg.exceptions.FFmpegNotSupportedException
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** FlutterAudioTrimmerPlugin */
class FlutterAudioTrimmerPlugin : FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel

    private lateinit var ffmpeg: FFmpeg

    private val tag = this::class.java.name

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel =
            MethodChannel(flutterPluginBinding.binaryMessenger, "vvvirani/flutter_audio_trimmer")
        channel.setMethodCallHandler(this)
        ffmpeg = FFmpeg.getInstance(flutterPluginBinding.applicationContext)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        if (call.method == "trim") {


            val inputPath = call.argument<String?>("input_path")
            val outputPath = call.argument<String?>("output_path")
            val startTime = call.argument<Double?>("start_time")
            val endTime = call.argument<Double?>("end_time")

            if (inputPath != null && outputPath != null && startTime != null && endTime != null) {

                try {


                    ffmpeg.loadBinary(object : FFmpegLoadBinaryResponseHandler {
                        override fun onStart() {
                        }

                        override fun onFinish() {
                        }

                        override fun onFailure() {
                        }

                        override fun onSuccess() {

                            val cmd = arrayOf(
                                "-y",
                                "-i", inputPath,
                                "-ss", "$startTime",
                                "-t", "$endTime",
                                "-c", "copy",
                                outputPath
                            )

                            ffmpeg.execute(cmd, object : FFmpegExecuteResponseHandler {
                                override fun onStart() {
                                }

                                override fun onFinish() {
                                }

                                override fun onSuccess(message: String?) {
                                    Log.d(tag, "onSuccess : $message")
                                    result.success(outputPath)
                                }

                                override fun onProgress(message: String?) {
                                }

                                override fun onFailure(message: String?) {
                                    Log.d(tag, "onFailure : $message")
                                    result.error("failed", "Invalid Arguments", message)
                                }

                            })
                        }

                    })


                } catch (e: FFmpegNotSupportedException) {
                    result.error("not_supported", e.message, e.localizedMessage)
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
