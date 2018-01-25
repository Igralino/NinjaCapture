//
//  ViewController.swift
//  NinjaCapture
//
//  Created by Igor Yunash on 18.01.18.
//  Copyright © 2018 Igralino. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    //MARK: Properties
    @IBOutlet weak var startButton: NSButton!
    @IBOutlet weak var stopButton: NSButton!
    @IBOutlet weak var mergeButton: NSButton!
    @IBOutlet weak var folderPicker: NSPopUpButton!
    @IBOutlet weak var folderLabel: NSTextField!
    let capture_session = Capture()
    var save_url: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        set_folder()
    }
    

    func set_folder(){
        if (folderPicker.indexOfSelectedItem == 0){
            var url = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask)[0]
            url = url.appendingPathComponent("NinjaCapture")
            folderLabel.stringValue = url.debugDescription
            save_url = url
        }
        else if (folderPicker.indexOfSelectedItem == 1){
            var url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            url = url.appendingPathComponent("NinjaCapture")
            folderLabel.stringValue = url.debugDescription
            save_url = url

        }
    }
    
    
    //MARK: Actions
    
    @IBAction func startRecording(_ sender: Any) {
        capture_session.capturing = true
        capture_session.save_url = save_url
        capture_session.deletePrevious()
        capture_session.captureQueue()
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        capture_session.capturing = false
        capture_session.tryStop()

    }
    
    @IBAction func mergeVideos(_ sender: Any) {
        let url_list = capture_session.file_queue.array
        let merge_session = Merge()
        merge_session.save_url = save_url
        
        merge_session.url_list = url_list
        merge_session.merge()
    }
    
    @IBAction func folderChanged(_ sender: Any) {
        set_folder()
    }
}

