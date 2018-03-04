//
//  Capture.swift
//  NinjaCapture
//
//  Created by Igor Yunash on 18.01.18.
//  Copyright © 2018 Igralino. All rights reserved.
//

import Cocoa
import Foundation
import AVFoundation
import os.log
class Capture: NSObject, AVCaptureFileOutputRecordingDelegate {
    
    var session : AVCaptureSession!
    var input : AVCaptureScreenInput?
    var output_file : AVCaptureMovieFileOutput!
    var output_screen : AVCaptureVideoDataOutput!
    var save_url : URL!
    var length : Int = 3*10
    var FPS: Int = 30
    var quality: Int = 2
    var file_queue = Queue<URL>()
    var capturing: Bool = false
    
    override init(){
        super.init()
        self.output_file = AVCaptureMovieFileOutput.init()
        self.session = AVCaptureSession()
        self.input = AVCaptureScreenInput.init(displayID: CGMainDisplayID())
        configureInput()
        tryInput()
        configureMovieOutput()
        tryOutput()
    }
    
    func captureQueue(){
        if capturing {
            if (file_queue.count < length/10){
                
                tryCapture()
            }
            else {
                let delete_url = file_queue.dequeue()
                do {
                    try FileManager.default.removeItem(at: delete_url!)
                }
                catch {
                    os_log(error as! StaticString, type: .error)
                }
                tryCapture()
            }
        }
    }
    
    func deletePrevious(){
        let enumerator = FileManager.default.enumerator(at: save_url, includingPropertiesForKeys: nil)
        while let file = enumerator?.nextObject() as? URL {
            do {
                try FileManager.default.removeItem(at: file)
            }
            catch {
                os_log(error as! StaticString, type: .error)
            }
        }
    }
    func configureInput(){
        if (self.input != nil){
            self.input?.capturesCursor = true
            self.input?.capturesMouseClicks = true
            self.input?.minFrameDuration = CMTimeMake(1, Int32(FPS))
            switch (quality) {
                
            case 0:
                self.session.sessionPreset = AVCaptureSession.Preset.low
                break;
            case 1:
                self.session.sessionPreset = AVCaptureSession.Preset.medium
                break;
            case 2:
                self.session.sessionPreset = AVCaptureSession.Preset.high
                break;
            default:
                break;
            }
        }
    }
    
    func configureMovieOutput(){
        if (self.output_file != nil){
            self.output_file.movieFragmentInterval = CMTimeMake(2, 1) // 2 second per interval
            self.output_file.maxRecordedDuration = CMTimeMake(23, 2) // 10 seconds maximum duration
        }
    }
    
    func tryInput(){
        if (self.session.canAddInput(self.input!)){
            self.session.addInput(self.input!)
        }
    }
    
    func tryOutput(){
        
        if (self.session.canAddOutput(self.output_file)){
            self.session.addOutput(self.output_file)
        }
    }
    
    func getDate() -> String{
        let date = Date()
        let formatter = ISO8601DateFormatter.init()
        let res = formatter.string(from: date)
        return res
    }
    
    func tryCapture(){
        self.session.startRunning()
        let date = getDate()
        let directory = save_url
        let folder = directory?.appendingPathComponent("Videos/")
        let url = directory?.appendingPathComponent("Videos/\(date).mov")
        do{
            try FileManager.default.createDirectory(at: folder!, withIntermediateDirectories: true, attributes: nil)
        }
        catch{
            os_log (error as! StaticString, type: .error)
        }
        file_queue.enqueue(url!)
        self.output_file.startRecording(to: url!, recordingDelegate: self)
    }
    
    func tryStop(){
        self.session.stopRunning()
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if error != nil{
            os_log("Video capturing successfully finished!", type: .info)
        }
        else{
            os_log("\nVideo capturing finished with errors:\n", type: .info)
        }
        self.captureQueue()
    }
}
