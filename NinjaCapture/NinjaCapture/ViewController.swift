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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    //MARK: Actions
    
    @IBAction func startRecording(_ sender: Any) {
        _ = Capture()
    }
    
    @IBAction func stopRecording(_ sender: Any) {
    }
    
    @IBAction func mergeVideos(_ sender: Any) {
        _ = Merge(pathToVideos: "1", pathToSave: "2")
    }
    
}

