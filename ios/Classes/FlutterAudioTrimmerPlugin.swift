import Flutter
import UIKit
import AVFoundation

public class FlutterAudioTrimmerPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "vvvirani/flutter_audio_trimmer", binaryMessenger: registrar.messenger())
        let instance = FlutterAudioTrimmerPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        
        if call.method == "trim" {
            
            if let arguments = call.arguments as? Dictionary<String, Any>{
                
                let inputPath =  arguments["input_path"] as? String?
                let outputPath =  arguments["output_path"] as? String?
                let startTimeSeconds =  arguments["start_time"] as? Double?
                let endTimeSeconds =  arguments["end_time"] as? Double?
                let outputFileType =  arguments["file_type"] as? String?
                
                if inputPath != nil && outputPath != nil && startTimeSeconds != nil && endTimeSeconds != nil && outputFileType != nil {
                    let audioURL = URL(fileURLWithPath: inputPath!!)
                    
                    let asset = AVAsset(url: audioURL)
                    
                    let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetAppleM4A)
                    
                    let startTime = CMTime(seconds: startTimeSeconds!!, preferredTimescale: 1)
                    let endTime = CMTime(seconds: endTimeSeconds!!, preferredTimescale: 1)
                    
                    exportSession?.timeRange = CMTimeRange(start: startTime, end: endTime)
                    exportSession?.outputFileType = getOutputFileType(outputFileType!!)
                    exportSession?.outputURL = URL(fileURLWithPath: outputPath!!)
                    
                    exportSession?.exportAsynchronously(completionHandler: {
                        switch exportSession?.status {
                        case .completed:
                            result(outputPath!!)
                            
                        case .failed:
                            let error = FlutterError(code: "failed", message: exportSession?.error?.localizedDescription, details: exportSession?.error)
                            result(error)
                            
                        case .cancelled:
                            let error = FlutterError(code: "cancelled", message: exportSession?.error?.localizedDescription, details: nil)
                            result(error)
                            
                        default:
                            break
                        }
                    })
                    
                } else {
                    let error = FlutterError(code: "missing_arguments", message: "Missing Arguments", details: nil)
                    result(error)
                }
                
            }  else {
                result(FlutterMethodNotImplemented)
            }
        }
        
    }
    
    func getOutputFileType(_ type: String) -> AVFileType {
        switch type {
        case "m4a":
            return .m4a
        case "wav":
            return .wav
        case "aiff":
            return .aiff
        case "aifc":
            return .aifc
        case "amr":
            return .amr
        case "au":
            return .au
        case "ac3":
            return .ac3
        default:
            return .m4a
        }
    }
}
