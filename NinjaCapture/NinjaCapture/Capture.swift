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

class Capture: NSObject, AVCaptureFileOutputRecordingDelegate {
    
    var session : AVCaptureSession!
    var input : AVCaptureScreenInput?
    var output_file : AVCaptureMovieFileOutput!
    var output_screen : AVCaptureVideoDataOutput!
    var started : Bool = false
    var finished : Bool = false
    
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
        
        tryCapture()
        
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
            self.output_file.movieFragmentInterval = CMTimeMake(5, 1) // 2 second per interval
            self.output_file.maxRecordedDuration = CMTimeMake(10, 1) // 10 seconds maximum duration
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
        let directory = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask)[0]
        let url = directory.appendingPathComponent("Videos/\(date).mov")
        print ("\nSaving URL: \(url) \n")
        self.output_file.startRecording(to: url, recordingDelegate: self)
        started = true
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if error != nil{
            print ("\nSuccsesfully finished!\n")
        }
        else{
            
            print ("\nFinished with errors:\n")
            print (error!.localizedDescription)
        }
        started = false
        finished = true
    }
}
