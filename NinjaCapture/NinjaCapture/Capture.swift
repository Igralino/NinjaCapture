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
    var length : Int64 = 3*10
    var file_queue = Queue<URL>()
    var capturing: Bool = false
    
    override init(){
        super.init()
        self.session = AVCaptureSession()
        self.session.sessionPreset = AVCaptureSession.Preset.high
        self.input = AVCaptureScreenInput.init(displayID: CGMainDisplayID())
        configureInput()
        tryInput()
        
        self.output_file = AVCaptureMovieFileOutput.init()
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
    
    func configureInput(){
        if (self.input != nil){
            self.input?.capturesCursor = true
            self.input?.capturesMouseClicks = true
            self.input?.minFrameDuration = CMTimeMake(1, 60) //min 60 FPS
            
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
        let url = directory?.appendingPathComponent("Videos/\(date).mov")
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
