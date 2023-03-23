import Flutter
import UIKit
import AVFoundation

public class AudioCutterPlugin: NSObject, FlutterPlugin {
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "vvvirani/audio_cutter", binaryMessenger: registrar.messenger())
        let instance = AudioCutterPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        
        if call.method == "trim" {
            
            if let arguments = call.arguments as? Dictionary<String, Any>{
                
                let audioFilePath =  arguments["file_path"] as? String?
                let trimmedAudioPath =  arguments["output_path"] as? String?
                let startTimeSeconds =  arguments["start_time"] as? Double?
                let endTimeSeconds =  arguments["end_time"] as? Double?
                
                if audioFilePath != nil && trimmedAudioPath != nil && startTimeSeconds != nil && endTimeSeconds != nil {
                    let audioURL = URL(fileURLWithPath: audioFilePath!!)
                    
                    let asset = AVAsset(url: audioURL)
                    
                    let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetAppleM4A)
                    
                    let startTime = CMTime(seconds: startTimeSeconds!!, preferredTimescale: 1)
                    let endTime = CMTime(seconds: endTimeSeconds!!, preferredTimescale: 1)
                    
                    exportSession?.timeRange = CMTimeRange(start: startTime, end: endTime)
                    exportSession?.outputFileType = .m4a
                    exportSession?.outputURL = URL(fileURLWithPath: trimmedAudioPath!!)
                    
                    exportSession?.exportAsynchronously(completionHandler: {
                        switch exportSession?.status {
                        case .completed:
                            result(trimmedAudioPath!!)
                            
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
}
