package com.vvvirani.audio_cutter

import com.googlecode.mp4parser.authoring.Movie
import com.googlecode.mp4parser.authoring.Track
import com.googlecode.mp4parser.authoring.builder.DefaultMp4Builder
import com.googlecode.mp4parser.authoring.container.mp4.MovieCreator
import com.googlecode.mp4parser.authoring.tracks.CroppedTrack
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.io.FileOutputStream

class AudioCutterPlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "vvvirani/audio_cutter")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        if (call.method == "trim") {

            val audioFilePath = call.argument<String?>("file_path")
            val outputFilePath = call.argument<String?>("output_path")
            val startTime = call.argument<Double?>("start_time")
            val endTime = call.argument<Double?>("end_time")

            if (audioFilePath != null && outputFilePath != null && startTime != null && endTime != null) {

                try {
                    val movie = MovieCreator.build(audioFilePath)
                    val audioTracks = mutableListOf<Track>()
                    for (track in movie.tracks) {
                        if (track.handler == "sound") {
                            audioTracks.add(track)
                        }
                    }

                    val newMovie = Movie()
                    for (track in audioTracks) {
                        val startTimeInTrack =
                            track.syncSamples?.let { track.syncSamples.firstOrNull() }?.toDouble()
                                ?: 0.0
                        val duration = track.duration.toDouble()
                        val endTimeInTrack = startTimeInTrack + duration
                        if (startTimeInTrack <= endTime && endTimeInTrack >= startTime) {
                            val newTrack = CroppedTrack(track, startTimeInTrack.toLong(),
                                (endTimeInTrack - startTimeInTrack).toLong())
                            newMovie.addTrack(newTrack)
                        }
                    }

                    val output = FileOutputStream(outputFilePath)
                    val container = DefaultMp4Builder().build(newMovie)
                    container.writeContainer(output.channel)
                    output.close()

                    result.success(outputFilePath)

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
